// Copyright 2025 Dodgy Ltd.
// Licensed under the MIT-0 license, see LICENSE.md

import Foundation

func runBuild(command: String, workingDirectory: URL) -> Bool {
    let process = Process()
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", command]
    process.currentDirectoryURL = workingDirectory
    process.standardOutput = nil
    process.standardError = nil
    try! process.run()
    process.waitUntilExit()
    return process.terminationStatus == 0
}

func buildSuccessful(customCommand: String?, workingDirectory: URL) -> Bool {
    if let customCommand {
        return runBuild(command: customCommand, workingDirectory: workingDirectory)
    } else {
        return runBuild(command: "swift build", workingDirectory: workingDirectory)
    }
}
