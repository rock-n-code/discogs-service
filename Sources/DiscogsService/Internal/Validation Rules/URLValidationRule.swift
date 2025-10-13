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

/// A validation rule type that checks whether an input is a URL or not.
///
/// This validation rule doesn't necessarily follow the [RFC 3986](https://www.rfc-editor.org/rfc/rfc3986) standard.
/// Thus it doesn't implement a complex regular expression pattern such as [this one](https://rgxdb.com/r/5JXUI5A2).
/// Instead this validation implements a regular expression sufficient enough to satisfy the requirements for a [user agent definition](https://www.discogs.com/developers/#page:home,header:home-general-information).
struct URLValidationRule: InputValidationRule {
    
    // MARK: Functions
    
#if swift(>=6.0)
    func validate(_ input: String?) throws(InputValidationError) -> Bool {
        try validate(input: input)
    }
#else
    func validate(_ input: String?) throws -> Bool {
        try validate(input: input)
    }
#endif
    
}

// MARK: - Definitions

extension InputValidationRule where Self == URLValidationRule {
    
    // MARK: Constants
    
    /// A validation rule that checks whether an input is a URL or not.
    static var url: Self { .init() }
    
}

// MARK: - Helpers

private extension URLValidationRule {
    
    // MARK: Functions
    
    /// Validates a given input.
    ///
    /// > note: This helper function would not be necessary when support for *Swift 5.10* is discontinued.
    ///
    /// - Parameter input: An input to be validated.
    /// - Returns: A flag that indicates whether a given input has been validated or not.
    /// - Throws: An error of type ``InputValidatorError`` in case the validation failed.
    func validate(input: String?) throws -> Bool {
        guard let input else {
            return false
        }
        
        guard input.fullyMatch(
            pattern: .init(format: .Pattern.url)
        ) else {
            throw InputValidationError.inputNotURL
        }
        
        return true
    }
    
}

// MARK: - Constants

private extension String.Pattern {
    /// A regular expression pattern that represents URL inputs.
    ///
    /// This regular expression is based on [this regular expression](https://regex101.com/r/3fYy3x/1) found while researching the topic.
    static let url = "https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,4}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"
}
