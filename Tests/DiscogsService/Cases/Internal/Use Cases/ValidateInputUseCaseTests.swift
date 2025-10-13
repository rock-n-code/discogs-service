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
        Input.inputsAgentName,
        Output.inputsAgentName
    )) func `validate camel case`(
        input: String,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .agentName,
            input: input,
            expects: error
        )
    }

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
    
    @Test(arguments: zip(
        Input.inputsSemanticVersion,
        Output.inputsSemanticVersion
    )) func `validate semantic version`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .semanticVersion,
            input: input,
            expects: error
        )
    }
    
    @Test(arguments: zip(
        Input.inputsURL,
        Output.inputsURL
    )) func `validate url`(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .url,
            input: input,
            expects: error
        )
    }
#else
    @Test("validate camel case", arguments: zip(
        Input.inputsCamelCase,
        Output.inputsCamelCase
    )) func validateCamelCase(
        input: String,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .camelCase,
            input: input,
            expects: error
        )
    }

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
    
    @Test("validate semantic version", arguments: zip(
        Input.inputsSemanticVersion,
        Output.inputsSemanticVersion
    )) func validateSemanticVersion(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .semanticVersion,
            input: input,
            expects: error
        )
    }
    
    @Test("validate url", arguments: zip(
        Input.inputsURL,
        Output.inputsURL
    )) func validateURL(
        input: String?,
        expects error: InputValidationError?
    ) async throws {
        try assertValidate(
            rule: .url,
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
    /// A list of inputs to validate against a camel-case validation rule.
    static let inputsCamelCase: [String] = ["SampleApp", "Sample4pp", "SampleApp1", "SampleApp🚀", "Sample App", "Sample-App", "Sample_App"]
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
    /// A list of inputs to validate against the semantic version validation rule.
    static let inputsSemanticVersion: [String] = ["0.0.4","1.2.3","10.20.30","1.1.2-prerelease+meta","1.1.2+meta","1.1.2+meta-valid","1.0.0-alpha","1.0.0-beta","1.0.0-alpha.beta","1.0.0-alpha.beta.1","1.0.0-alpha.1","1.0.0-alpha0.valid","1.0.0-alpha.0valid","1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay","1.0.0-rc.1+build.1","2.0.0-rc.1+build.123","1.2.3-beta","10.2.3-DEV-SNAPSHOT","1.2.3-SNAPSHOT-123","1.0.0","2.0.0","1.1.7","2.0.0+build.1848","2.0.1-alpha.1227","1.0.0-alpha+beta","1.2.3----RC-SNAPSHOT.12.9.1--.12+788","1.2.3----R-S.12.9.1--.12+meta","1.2.3----RC-SNAPSHOT.12.9.1--.12","1.0.0+0.build.1-rc.10000aaa-kk-0.1","99999999999999999999999.999999999999999999.99999999999999999","1.0.0-0A.is.legal","1","1.2","1.2.3-0123","1.2.3-0123.0123","1.1.2+.123","+invalid","-invalid","-invalid+invalid","-invalid.01","alpha","alpha.beta","alpha.beta.1","alpha.1","alpha+beta","alpha_beta","alpha.","alpha..","beta","1.0.0-alpha_beta","-alpha.","1.0.0-alpha..","1.0.0-alpha..1","1.0.0-alpha...1","1.0.0-alpha....1","1.0.0-alpha.....1","1.0.0-alpha......1","1.0.0-alpha.......1","01.1.1","1.01.1","1.1.01","1.2","1.2.3.DEV","1.2-SNAPSHOT","1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788","1.2-RC-SNAPSHOT","-1.0.3-gamma+b7718","+justmeta","9.8.7+meta+meta","9.8.7-whatever+meta+meta","99999999999999999999999.999999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12"]
    /// A list of inputs to validate against the URL validation rule.
    static let inputsURL: [String] = ["https://www.google.com", "http://www.google.com", "https://google.com/q=search", "http://google.com/q=search", "3333-768-0948", "1133.168.0248", "7678*999-8978", "httpq://google.com/q=search", "www.google.com", "www.google.com/?search=qppoao", "www . google.com/?search=qppoao", "https : //google.com/q=search", "htt://www.google.com", "://www.google.com", .empty]
}

private extension Output {
    /// A list of expected input validation errors to be thrown after validating inputs against the camel-case validation rule.
    static let inputsCamelCase: [InputValidationError?] = [nil, nil, nil, .inputNotCamelCase, .inputNotCamelCase, .inputNotCamelCase, .inputNotCamelCase]
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
    /// A list of expected input validation errors to be thrown after validating inputs against the semantic version validation rule.
    static let inputsSemanticVersion: [InputValidationError?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputNotSemanticVersion]
    /// A list of expected input validation errors to be thrown after validating inputs against the URL validation rule.
    static let inputsURL: [InputValidationError?] = [nil, nil, nil, nil, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL, .inputNotURL]
}
