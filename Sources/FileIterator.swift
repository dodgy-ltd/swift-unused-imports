// Copyright 2025 Dodgy Ltd.
// Licensed under the MIT-0 license, see LICENSE.md

import Foundation

/// Walk over all the swift files in a directory tree.
func swiftFilesIn(directory: URL) -> [URL] {
    let fm = FileManager()
    let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
    guard let files = fm.enumerator(at: directory,
                                    includingPropertiesForKeys: Array(resourceKeys))
    else {
        return []
    }
    var swiftFiles: [URL] = []
    while let fileURL = files.nextObject() as? URL {
        if !fileURL.hasDirectoryPath && fileURL.pathExtension == "swift" {
            swiftFiles.append(fileURL)
        }
    }
    return swiftFiles
}
