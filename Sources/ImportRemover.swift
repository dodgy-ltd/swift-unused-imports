// Copyright 2025 Dodgy Ltd.
// Licensed under the MIT-0 license, see LICENSE.md

import Foundation

struct ImportStatement {
    let name: String
    let range: Range<String.Index>
}

func findImports(in file: URL) -> [ImportStatement] {
    guard let contents = try? String(contentsOf: file, encoding: .utf8) else {
        return []
    }
    let importStatementRegex = #/^[ \t]*(import) \w+/#.anchorsMatchLineEndings()
    let importStatements = contents.matches(of: importStatementRegex).map {
        ImportStatement(name: String(contents[$0.range]), range: $0.range)
    }
    return importStatements
}


/// Remove a single import statement from a file.
/// - Parameters:
///   - importStatement: Import statement within file.
///   - file: URL of file to modify
func removeImport(_ importStatement: ImportStatement, from file: URL) {
    guard var contents = try? String(contentsOf: file, encoding: .utf8) else {
        return
    }
    contents.replaceSubrange(importStatement.range, with: "")
    try? contents.write(to: file, atomically: true, encoding: .utf8)
}
