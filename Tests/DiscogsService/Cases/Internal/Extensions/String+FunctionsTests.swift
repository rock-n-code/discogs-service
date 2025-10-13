// ===----------------------------------------------------------------------===
//
// This source file is part of the DiscogsService open source project
//
// Copyright (c) 2025 Röck+Cöde VoF. and the DiscogsService project authors
// Licensed under Apache license v2.0
//
// See LICENSE for license information
// See CONTRIBUTORS for the list of DiscogsService project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===

import Testing

@testable import DiscogsService

@Suite("String Functions", .tags(.extension))
struct StringFunctionsTests {
    
    // MARK: Functions tests
    
#if swift(>=6.2)
    @Test(arguments: zip(
        Input.stringsToMatch,
        Output.stringsToMatch
    ))
    func `fully match`(
        string: String,
        expects isMatch: Bool
    ) {
        assertFullyMatch(
            string: string,
            pattern: .Pattern.sample,
            expects: isMatch
        )
    }
#else
    @Test("fully match", arguments: zip(
        Input.stringsToMatch,
        Output.stringsToMatch
    ))
    func fullyMatch(
        string: String,
        expects isMatch: Bool
    ) {
        assertFullyMatch(
            string: string,
            pattern: .Pattern.sample,
            expects: isMatch
        )
    }
#endif
    
}

// MARK: - Assertions

private extension StringFunctionsTests {
    
    // MARK: Functions
    
    /// Asserts the result of the `fullyMatch` function.
    /// - Parameters:
    ///   - string: A string to match against a pattern.
    ///   - pattern: A regular expression pattern to match a string against.
    ///   - isMatch: An expected flag that indicates whether there is a match or not.
    func assertFullyMatch(
        string: String,
        pattern: String,
        expects isMatch: Bool
    ) {
        // GIVEN
        // WHEN
        let result = string.fullyMatch(pattern: pattern)

        // THEN
        #expect(result == isMatch)
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of strings to match against a regular expression pattern in test cases.
    static let stringsToMatch: [String] = ["Some Pattern", "Some", "Some Other Pattern", "Pattern", .empty]
}

private extension Output {
    /// A list of expected results from matching a sample string against a sample regular expression pattern in test cases.
    static let stringsToMatch: [Bool] = [true, false, false, false, false]
}

private extension String.Pattern {
    /// A sample regular expression pattern to match against.
    static let sample = "Some Pattern"
}
