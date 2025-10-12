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

/// A validation rule type that checks whether an input is nil or not.
struct NotNilValidationRule: InputValidationRule {
    
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

// MARK: - Helpers

private extension NotNilValidationRule {
    
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
            throw InputValidationError.inputIsNil
        }
        
        return true
    }

}

// MARK: - Constants

extension InputValidationRule where Self == NotNilValidationRule {
    /// A validation rule that checks whether an input is nil or not.
    static var notNil: Self { .init() }
}
