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

@Suite("Validate Input Use Cases")
struct ValidateInputUseCaseTests {
    
    // MARK: Functions
    
#if swift(>=6.2)
    @Test(arguments: zip(
        Input.inputsToValidate,
        Output.inputsToValidate
    )) func `validate`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            input: input,
            expects: error
        )
    }
#else
    @Test("validate", arguments: zip(
        Input.inputsToValidate,
        Output.inputsToValidate
    )) func validate(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            input: input,
            expects: error
        )
    }
#endif
    
}

// MARK: - Assertions

private extension ValidateInputUseCaseTests {
    
    // MARK: Functions
    
    /// Asserts an input validation of a ``ValidateInputUseCase`` use case.
    /// - Parameters:
    ///   - input: An input to validate, if any.
    ///   - error: An expected error, if any.
    /// - Throws: An error of type ``InputValidationError`` in case of an unexpected test case scenario.
    func assertValidate(
        input: String?,
        expects error: InputValidationError?
    ) throws {
        // GIVEN
        let validate = ValidateInputUseCase(rules: .notNil, .notEmpty)
        
        // WHEN
        // THEN
        if let error {
            #expect(throws: error) {
                try validate(input)
            }
        } else {
            #expect(throws: Never.self) {
                try validate(input)
            }
        }
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of inputs to validate against a set of validation rules.
    static let inputsToValidate: [String?] = [nil, .empty, "SomeInput"]
}

private extension Output {
    /// A list of expected input validation errors to be thrown (if necessary).
    static let inputsToValidate: [InputValidationError?] = [.inputIsNil, .inputIsEmpty, nil]
}
