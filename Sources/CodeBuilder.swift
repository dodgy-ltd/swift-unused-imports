// Copyright 2025-2026 Dodgy Ltd.
// Licensed under the MIT-0 license, see LICENSE.md

import Foundation

func runBuild(command: String, workingDirectory: URL, verbose: Bool) -> Bool {
    let process = Process()
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", command]
    process.currentDirectoryURL = workingDirectory
    if !verbose {
        process.standardOutput = nil
        process.standardError = nil
    }
    try! process.run()
    process.waitUntilExit()
    return process.terminationStatus == 0
}

func buildSuccessful(customCommand: String?, workingDirectory: URL, verbose: Bool) -> Bool {
    runBuild(command: customCommand ?? "swift build", workingDirectory: workingDirectory, verbose: verbose)
}
