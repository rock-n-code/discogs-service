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

/// A validation rule type that checks whether an input is camel-case or not.
struct CamelCaseValidationRule: InputValidationRule {
    
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

extension InputValidationRule where Self == CamelCaseValidationRule {
    
    // MARK: Constants
    
    /// A validation rule that checks whether an input is camel-cased or not.
    static var camelCase: Self { .init() }
    
}

// MARK: - Helpers

private extension CamelCaseValidationRule {
    
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
            pattern: .init(format: .Pattern.camelCase)
        ) else {
            throw InputValidationError.inputNotCamelCase
        }
        
        return true
    }
    
}

// MARK: - Constants

private extension String.Pattern {
    /// A regular expression pattern that represents camel-cased inputs.
    static let camelCase = "([A-Z]([a-z]|[0-9])+)+"
}
