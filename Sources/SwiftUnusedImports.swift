// Copyright 2025 Dodgy Ltd.

import ArgumentParser

/// Command-line interface for import tuner tool.
@main struct ImportTuner: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: String(localized: "Finds unneeded Swift import dependencies via a brute force approach."))
    
    @Argument(help: "Paths to scan for Swift files")
    var path: String = "."
    
    func validate() throws {
        // TODO
    }
    
    func run() async throws {
        // TODO
    }
}
