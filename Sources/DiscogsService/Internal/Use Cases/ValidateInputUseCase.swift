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

/// A use case that validates an input against a set of validation rules.
struct ValidateInputUseCase {
    
    // MARK: Properties
    
    /// A list of validation rules to match an input against.
    private let rules: [any InputValidationRule]
    
    // MARK: Initializers
    
    /// Initializes this use case.
    /// - Parameter rules: A list of validation rules to match an input against.
    init(rules: any InputValidationRule...) {
        self.rules = rules
    }
    
    // MARK: Functions
    
#if swift(>=6.0)
    /// Validates an input against a set of validation rules.
    /// - Parameter input: An input to be validated against a set of rules, if any.
    /// - Throws: An error of type ``InputValidationError`` in case an input failed any validation.
    func callAsFunction(_ input: String?) throws(InputValidationError) {
        for rule in rules {
            try rule.validate(input)
        }
    }
#else
    /// Validates an input against a set of validation rules.
    /// - Parameter input: An input to be validated against a set of rules, if any.
    /// - Throws: An error of type ``InputValidationError`` in case an input failed any validation.
    func callAsFunction(_ input: String?) throws {
        for rule in rules {
            try rule.validate(input)
        }
    }
#endif

}
