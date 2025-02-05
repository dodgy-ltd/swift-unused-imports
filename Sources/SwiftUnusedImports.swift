// Copyright 2025 Dodgy Ltd.
// Licensed under the MIT-0 license, see LICENSE.md

import ArgumentParser
import Foundation

/// Command-line interface for import tuner tool.
@main struct SwiftUnusedImports: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: String(localized: "Finds unneeded Swift import dependencies via a brute force approach."))
    
    @Argument(help: "Directory to scan for Swift files and building")
    var path: String = ""
    
    @Option(help: "Build command. Defaults to 'swift build'")
    var buildCmd: String?
    
    func validate() throws {
        let pathValid = try URL(fileURLWithPath: path).checkResourceIsReachable()
        if !pathValid {
            throw ValidationError("Path '\(path)' does not exist")
        }
    }
    
    func run() async throws {
        let root = URL(fileURLWithPath: path)
        print("Testing build without changes...")
        if !buildSuccessful(customCommand: buildCmd, workingDirectory: root) {
            
            throw ValidationError("Build failed without changes")
        }
        let swiftFiles = swiftFilesIn(directory: root)
        var totalJobs = 0
        for swiftFile in swiftFiles {
            let imports = findImports(in: swiftFile)
            totalJobs += imports.count
        }
        var jobNumber = 1
        for swiftFile in swiftFiles {
            var imports = findImports(in: swiftFile)
            var importIndex = 0
            while importIndex < imports.count {
                guard let backupFileContent = try? String(contentsOf: swiftFile, encoding: .utf8) else {
                    fatalError("Error: could not read file \(swiftFile)")
                }
                let importStatement = imports[importIndex]
                removeImport(importStatement, from: swiftFile)
                print("\(jobNumber)/\(totalJobs): \(swiftFile) can \(importStatement.name) be removed?", terminator: "")
                if buildSuccessful(customCommand: buildCmd, workingDirectory: root) {
                    print(" yes!")
                    imports = findImports(in: swiftFile)
                } else {
                    print(" no")
                    importIndex += 1
                    
                    // restore this removed import
                    do {
                        try backupFileContent.write(to: swiftFile, atomically: true, encoding: .utf8)
                    } catch {
                        fatalError("Could not restore file \(swiftFile): \(error)")
                    }
                }
                jobNumber += 1
            }
        }
    }
}
