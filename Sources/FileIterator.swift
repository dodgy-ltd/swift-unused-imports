// Copyright 2025-2026 Dodgy Ltd.
// Licensed under the MIT-0 license, see LICENSE.md

import Foundation

/// Walk over all the swift files in a directory tree.
func swiftFilesIn(directory: URL, exclude: [String], verbose: Bool) -> [URL] {
    let fm = FileManager()
    let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
    guard let files = fm.enumerator(at: directory,
                                    includingPropertiesForKeys: Array(resourceKeys))
    else {
        return []
    }
    let excludedPrefixes: [String] = exclude.map {
        directory.appendingPathComponent($0).standardized.absoluteString
    }
    var swiftFiles: [URL] = []
    while let fileURL = files.nextObject() as? URL {
        if fileURL.hasDirectoryPath {
            continue
        }
        if fileURL.pathExtension != "swift" {
            continue
        }
        if fileURL.hasPrefix(in: excludedPrefixes) {
            if verbose {
                print("Excluding \(fileURL)")
            }
            continue
        }
        swiftFiles.append(fileURL)
    }
    return swiftFiles
}

extension URL {
    func hasPrefix(in prefixes: [String]) -> Bool {
        let fileURLStd = self.standardized.absoluteString
        var found = false
        for prefix in prefixes {
            if fileURLStd.hasPrefix(prefix) {
                found = true
                break
            }
        }
        return found
    }
}
