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

import struct HTTPTypes.HTTPField
import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest

import Testing

@testable import DiscogsService

@Suite("User Agent Middleware", .tags(.middleware))
struct UserAgentMiddlewareTests {
    
    // MARK: Initializers tests
    
#if swift(>=6.2)
    @Test(arguments: Input.userAgents)
    func `initialize`(
        product: Product
    ) throws {
        try assertInit(product: product)
    }
    
    @Test(arguments: zip(
        Input.userAgentsThrows,
        Output.userAgentsThrows
    ))
    func `initialize throws`(
        product: Product,
        expect error: InputValidationError?
    ) {
        assertInitThrows(
            product: product,
            expects: error
        )
    }
#else
    @Test("initialize", arguments: Input.userAgents)
    func initialize(
        product: Product
    ) throws {
        try assertInit(product: product)
    }
    
    @Test("initialize throws", arguments: zip(
        Input.userAgentsThrows,
        Output.userAgentsThrows
    ))
    func initializeThrows(
        product: Product,
        expect error: InputValidationError?
    ) {
        assertInitThrows(
            product: product,
            expects: error
        )
    }
#endif
    
    // MARK: Functions tests
    
#if swift(>=6.2)
    @Test(arguments: Input.userAgents)
    func `intercept with user agent on headers`(
        product: Product
    ) async throws {
        try await assertIntercept(product: product)
    }
    
    @Test(arguments: Input.userAgents)
    func `intercept with user agent on headers when headers are populated`(
        product: Product
    ) async throws {
        try await assertIntercept(
            product: product,
            headerFields: [.accept: "*/*"]
        )
    }
#else
    @Test("intercept with user agent on headers", arguments: Input.userAgents)
    func intercept_withUserAgentOnHeaders(
        product: Product
    ) async throws {
        try await assertIntercept(product: product)
    }
    
    @Test("intercept with user agent on headers when headers are populated", arguments: Input.userAgents)
    func intercept_withUserAgentOnHeaders_whenHeadersPopulated(
        product: Product
    ) async throws {
        try await assertIntercept(
            product: product,
            headerFields: [.accept: "*/*"]
        )
    }
#endif
    
}

// MARK: - Assertions

private extension UserAgentMiddlewareTests {
    
    // MARK: Functions
    
    /// Asserts the initialization of the middleware , especially the assignments of its properties.
    /// - Parameter product: A product to initialize a middleware.
    /// - Throws: an error of type ``InputValidationError`` in case of an unexpected error occurs while running test cases.
    func assertInit(
        product: Product
    ) throws {
        // GIVEN
        // WHEN
        let middleware = try UserAgentMiddleware(product: product)
        
        // THEN
        #expect(middleware.agentField == .init(
            name: .userAgent,
            value: "\(product.name)/\(product.version) +\(product.url)"
        ))
    }
    
    /// Asserts the error throwing (if justified) during the initialization of the middleware.
    /// - Parameters:
    ///   - product: A product to initialize a middleware.
    ///   - error: An expected error of type ``InputValidationError`` during the initialization of a middleware.
    func assertInitThrows(
        product: Product,
        expects error: InputValidationError?
    ) {
        // GIVEN
        // WHEN
        // THEN
        if let error {
            #expect(throws: error) {
                try UserAgentMiddleware(product: product)
            }
        } else {
            #expect(throws: Never.self) {
                try UserAgentMiddleware(product: product)
            }
        }
    }
    
    /// Asserts the interception of a request to add the user agent in its header.
    /// - Parameters:
    ///   - product: A product to initialize a middleware.
    ///   - path: A URI path for a request.
    ///   - headerFields: A set of header fields for a request.
    func assertIntercept(
        product: Product,
        path: String? = nil,
        headerFields: HTTPFields = [:]
    ) async throws {
        // GIVEN
        let middleware = try UserAgentMiddleware(product: product)
        let request = HTTPRequest(
            path: path,
            headerFields: headerFields
        )

        // WHEN
        _ = try await confirmation { confirmation in
            try await middleware.intercept(
                request,
                body: nil,
                baseURL: .Sample.baseURL,
                operationID: .Sample.operationId
            ) { request, _, _ in
                // THEN
                #expect(request.path == path)
                #expect(request.headerFields != headerFields)
                #expect(request.headerFields.count == headerFields.count + 1)
                #expect(request.headerFields.contains(where: { $0.name == .userAgent }))
                
                confirmation()
                
                return (.init(status: .ok) , nil)
            }
        }
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of products to successfully initialize user agent middleware instances.
    static let userAgents: [Product] = [
        .init(name: "SomeApp", version: "0.0.1", url: "http://www.some.app"),
        .init(name: "SomeOther4pp", version: "1.2.3-b1", url: "https://some-other.app"),
        .init(name: "Yet4notherApp", version: "0.8.8+alpha", url: "https://yet.another.app")
    ]
    /// A list of products to use in the initialization throw test cases.
    static let userAgentsThrows: [Product] = userAgents + [
        .init(name: "Some App", version: "0.0.1", url: "http://www.some.app"),
        .init(name: "Some-App", version: "0.0.1", url: "http://www.some.app"),
        .init(name: .empty, version: "0.0.1", url: "http://www.some.app"),
        .init(name: "SomeApp", version: "v0.0.1", url: "http://www.some.app"),
        .init(name: "SomeApp", version: "0.1", url: "http://www.some.app"),
        .init(name: "SomeApp", version: .empty, url: "http://www.some.app"),
        .init(name: "SomeApp", version: "0.0.1", url: "www.some.app"),
        .init(name: "SomeApp", version: "0.0.1", url: "some.app"),
        .init(name: "SomeApp", version: "0.0.1", url: .empty),
        .init(name: "Some App", version: "v0.0.1", url: "www.some.app"),
        .init(name: "SomeApp", version: "v0.0.1", url: "www.some.app"),
        .init(name: "Some App", version: "0.0.1", url: "www.some.app"),
    ]
}

private extension Output {
    /// A list of expected input validation errors (if thrown) coming from the initialization throw test cases.
    static let userAgentsThrows: [InputValidationError?] = [nil, nil, nil, .inputNotCamelCase, .inputNotCamelCase, .inputIsEmpty, .inputNotSemanticVersion, .inputNotSemanticVersion, .inputIsEmpty, .inputNotURL, .inputNotURL, .inputIsEmpty, .inputNotCamelCase,  .inputNotSemanticVersion, .inputNotCamelCase]
}
