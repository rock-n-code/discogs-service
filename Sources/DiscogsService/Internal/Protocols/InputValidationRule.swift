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

/// A protocol that defines an input validation rule to be applied to an input by the ``ValidateInputUseCase`` use case.
protocol InputValidationRule {

    // MARK: Functions

#if swift(>=6.0)
    /// Validates a given input against a validation rule.
    /// - Parameter input: An input to be validated.
    /// - Returns: A flag that indicates whether an input has been validated or not.
    /// - Throws: An error of type ``InputValidationError`` in case a given input failed a validation.
    @discardableResult func validate(_ input: String?) throws(InputValidationError) -> Bool
#else
    /// Validates a given input against a validation rule.
    /// - Parameter input: An input to be validated.
    /// - Returns: A flag that indicates whether an input has been validated or not.
    /// - Throws: An error of type ``InputValidationError`` in case a given input failed a validation.
    @discardableResult func validate(_ input: String?) throws -> Bool
#endif
    
}
