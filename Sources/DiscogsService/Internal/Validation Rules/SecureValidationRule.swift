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

import Foundation

/// A validation rule type that checks whether an input is secure or not.
struct SecureValidationRule: InputValidationRule {
    
    // MARK: Properties
    
    /// A representation of the available security input types.
    private let inputType: SecurityInput
    
    // MARK: Initializers
    
    /// Initializes this validation rule.
    /// - Parameter inputType: A representation of the available security input types.
    init(inputType: SecurityInput) {
        self.inputType = inputType
    }

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

extension InputValidationRule where Self == SecureValidationRule {
    
    // MARK: Functions
    
    /// A validation rule that checks whether an input is secure or not.
    /// - Parameter securityInput: A representation of the security input type to validate
    /// - Returns: A validation rule that has been configured and it is ready to use.
    static func secure(_ securityInput: SecurityInput) -> Self {
        .init(inputType: securityInput)
    }
    
}

// MARK: - Enumerations

/// A representation of all the possible security input types, based on their respective character length expectations.
enum SecurityInput: Int {
    /// A consumer key is 20 characters long.
    case consumerKey = 20
    /// A consumer key is 32 characters long.
    case consumerSecret = 32
    /// A consumer key is 40 characters long.
    case userToken = 40
}

// MARK: - Helpers

private extension SecureValidationRule {
    
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
            pattern: .init(format: .Pattern.securityInput, inputType.rawValue)
        ) else {
            switch inputType {
            case .consumerKey: throw InputValidationError.inputNotConsumerKey
            case .consumerSecret: throw InputValidationError.inputNotConsumerSecret
            case .userToken: throw InputValidationError.inputNotUserToken
            }
        }

        return true
    }
    
}

// MARK: - Constants

private extension String.Pattern {
    /// A regular expression pattern that represents security inputs.
    static let securityInput = "^([a-z]|[A-Z]){%d}$"
}
