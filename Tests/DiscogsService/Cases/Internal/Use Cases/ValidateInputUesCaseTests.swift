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

@Suite("Validate Input Use Cases", .tags(.useCase))
struct ValidateInputUseCaseTests {
    
    // MARK: Functions
    
#if swift(>=6.2)
    @Test(arguments: zip(
        Input.inputsNotEmpty,
        Output.inputsNotEmpty
    )) func `validates not empty`(
        input: String,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .notEmpty,
            input: input,
            expects: error
        )
    }

    @Test(arguments: zip(
        Input.inputsNotNil,
        Output.inputsNotNil
    )) func `validate not nil`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .notNil,
            input: input,
            expects: error
        )
    }
    
    @Test(arguments: zip(
        Input.inputsSecureConsumerKey,
        Output.inputsSecureConsumerKey
    )) func `validate secure (consumer key)`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .secure(.consumerKey),
            input: input,
            expects: error
        )
    }
    
    @Test(arguments: zip(
        Input.inputsSecureConsumerSecret,
        Output.inputsSecureConsumerSecret
    )) func `validate secure (consumer secret)`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .secure(.consumerSecret),
            input: input,
            expects: error
        )
    }
    
    @Test(arguments: zip(
        Input.inputsSecureUserToken,
        Output.inputsSecureUserToken
    )) func `validate secure (user token)`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .secure(.userToken),
            input: input,
            expects: error
        )
    }
#else
    @Test("validate not empty", arguments: zip(
        Input.inputsNotEmpty,
        Output.inputsNotEmpty
    )) func validateNotEmpty(
        input: String,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .notEmpty,
            input: input,
            expects: error
        )
    }

    @Test("validate not nil", arguments: zip(
        Input.inputsNotNil,
        Output.inputsNotNil
    )) func validateNotNil(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .notNil,
            input: input,
            expects: error
        )
    }
    
    @Test("validate secure (consumer key)", arguments: zip(
        Input.inputsSecureConsumerKey,
        Output.inputsSecureConsumerKey
    )) func validateSecureConsumerKey(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .secure(.consumerKey),
            input: input,
            expects: error
        )
    }
    
    @Test("validate secure (consumer secret)", arguments: zip(
        Input.inputsSecureConsumerSecret,
        Output.inputsSecureConsumerSecret
    )) func validateSecureConsumerSecret(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .secure(.consumerSecret),
            input: input,
            expects: error
        )
    }
    
    @Test("validate secure (user token)", arguments: zip(
        Input.inputsSecureUserToken,
        Output.inputsSecureUserToken
    )) func validateSecureUserToken(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .secure(.userToken),
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
    ///   - rule: A validation rule to test.
    ///   - input: An input to validate, if any.
    ///   - error: An expected error, if any.
    /// - Throws: An error of type ``InputValidationError`` in case of an unexpected test case scenario.
    func assertValidate(
        rule: InputValidationRule,
        input: String?,
        expects error: InputValidationError?
    ) throws {
        // GIVEN
        let validate = ValidateInputUseCase(rules: rule)
        
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
    /// A list of inputs to validate against the not empty validation rule.
    static let inputsNotEmpty: [String] = ["Something", .empty]
    /// A list of inputs to validate against the not nil validation rule.
    static let inputsNotNil: [String?] = [.empty, nil]
    /// A list of inputs to validate against the secure (consumer key) validation rule.
    static let inputsSecureConsumerKey: [String] = ["aAbBcCdDeEfFgGhHiIjJ", "aAbBcCdDeEfFgGhH", "aAbBcCdDeEfFgGhHiIjJkK", "a4bBcCdDe3fFg6hH1Ij7"]
    /// A list of inputs to validate against the secure (consumer secret) validation rule.
    static let inputsSecureConsumerSecret: [String] = ["aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP", "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoO", "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQ", "a4bBcCdDe3fFg6hH1IjJkK1LmMnNo0p9"]
    /// A list of inputs to validate against the secure (user token) validation rule.
    static let inputsSecureUserToken: [String] = ["aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStT", "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsS", "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuU", "a4bBcCdDe3fFg6hH1IjJkK1LmMnNo0p9qQrRs5t7"]
}

private extension Output {
    /// A list of expected input validation errors to be thrown after validating inputs against the not empty validation rule.
    static let inputsNotEmpty: [InputValidationError?] = [nil, .inputIsEmpty]
    /// A list of expected input validation errors to be thrown after validating inputs against the not nil validation rule.
    static let inputsNotNil: [InputValidationError?] = [nil, .inputIsNil]
    /// A list of expected input validation errors to be thrown after validating inputs against the secure (consumer key) validation rule.
    static let inputsSecureConsumerKey: [InputValidationError?] = [nil, .inputNotConsumerKey, .inputNotConsumerKey, .inputNotConsumerKey]
    /// A list of expected input validation errors to be thrown after validating inputs against the secure (consumer secret) validation rule.
    static let inputsSecureConsumerSecret: [InputValidationError?] = [nil, .inputNotConsumerSecret, .inputNotConsumerSecret, .inputNotConsumerSecret]
    /// A list of expected input validation errors to be thrown after validating inputs against the secure (user token) validation rule.
    static let inputsSecureUserToken: [InputValidationError?] = [nil, .inputNotUserToken, .inputNotUserToken, .inputNotUserToken]
}
