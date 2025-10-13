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

import struct Foundation.URL
import struct Foundation.URLComponents
import struct Foundation.URLQueryItem
import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest
import struct HTTPTypes.HTTPResponse

import Testing

@testable import DiscogsService

@Suite("Auth Middleware", .tags(.middleware))
struct AuthMiddlewareTests {
    
    // MARK: Initializers tests

#if swift(>=6.2)
    @Test(arguments: Input.authMethods)
    func `initialize`(
        _ authMethod: AuthMethod
    ) async throws {
        try assertInit(
            authMethod: authMethod,
            authTransport: try randomTransport
        )
    }
    
    @Test(arguments: zip(
        Input.authMethodsThrows,
        Output.authMethodsThrows
    ))
    func `initialize throws`(
        _ authMethod: AuthMethod,
        expects error: InputValidationError?
    ) async throws {
        try assertInitThrows(
            authMethod: authMethod,
            authTransport: try randomTransport,
            expects: error
        )
    }
#else
    @Test("initialize", arguments: Input.authMethods)
    func initialize(
        _ authMethod: AuthMethod
    ) throws {
        try assertInit(
            authMethod: authMethod,
            authTransport: try randomTransport
        )
    }
    
    @Test("initialize throws", arguments: zip(
        Input.authMethodsThrows,
        Output.authMethodsThrows
    ))
    func initializeThrows(
        _ authMethod: AuthMethod,
        expects error: InputValidationError?
    ) throws {
        assertInitThrows(
            authMethod: authMethod,
            authTransport: try randomTransport,
            expects: error
        )
    }
#endif
    
    // MARK: Properties tests
#if swift(>=6.2)
    @Test(arguments: zip(
        Input.authMethods,
        Output.authMethodsShouldAuthenticate
    ))
    func `should authenticate`(
        _ authMethod: AuthMethod,
        expects flag: Bool
    ) throws {
        try assertShouldAuthenticate(
            authMethod: authMethod,
            authTransport: try randomTransport,
            expects: flag
        )
    }
#else
    @Test("should authenticate", arguments: zip(
        Input.authMethods,
        Output.authMethodsShouldAuthenticate
    ))
    func shouldAuthenticate(
        _ authMethod: AuthMethod,
        expects flag: Bool
    ) throws {
        try assertShouldAuthenticate(
            authMethod: authMethod,
            authTransport: try randomTransport,
            expects: flag
        )
    }
#endif
    
    // MARK: Functions tests

#if swift(>=6.2)
    @Test(arguments: Input.authMethods)
    func `intercept with authorization on header`(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onHeader,
            path: "/some/path/to/resource"
        )
    }
    
    @Test(arguments: Input.authMethods)
    func `intercept with authorization on query`(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onQuery,
            path: "/some/path/to/resource"
        )
    }
    
    @Test(arguments: Input.authMethods)
    func `intercept with authorization on header when headers populated`(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onHeader,
            path: "/some/path/to/resource",
            headerFields: [.accept: "*/*"]
        )
    }
    
    @Test(arguments: Input.authMethods)
    func `intercept with authorization on query when query is populated`(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onQuery,
            path: "/some/path/to/resource?key=value"
        )
    }
#else
    @Test("intercept with authorization on header", arguments: Input.authMethods)
    func intercept_withAuthOnHeader(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onHeader,
            path: "/some/path/to/resource"
        )
    }
    
    @Test("intercept with authorization on query", arguments: Input.authMethods)
    func intercept_withAuthOnQuery(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onQuery,
            path: "/some/path/to/resource"
        )
    }
    
    @Test(
        "intercept with authorization on header when headers are populated",
        arguments: Input.authMethods
    )
    func intercept_withAuthOnHeader_whenHeadersPopulated(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onHeader,
            path: "/some/path/to/resource",
            headerFields: [.accept: "*/*"]
        )
    }
    
    @Test(
        "intercept with authorization on query when query is populated",
        arguments: Input.authMethods
    )
    func intercept_withAuthOnQuery_whenQueryPopulated(
        _ authMethod: AuthMethod
    ) async throws {
        try await assertIntercept(
            authMethod: authMethod,
            authTransport: .onQuery,
            path: "/some/path/to/resource?key=value"
        )
    }
#endif


}

// MARK: - Assertions

private extension AuthMiddlewareTests {
    
    // MARK: Functions
    
    /// Asserts the initialization of the middleware, especially the assignment of its properties.
    /// - Parameters:
    ///   - authMethod: A representation of an authentication method.
    ///   - authTransport: A representation of an authentication transport.
    /// - Throws: an error of type ``InputValidationError`` in case of an unexpected error occurs while running test cases.
    func assertInit(
        authMethod: AuthMethod,
        authTransport: AuthTransport,
    ) throws {
        // GIVEN
        // WHEN
        let middleware = try AuthMiddleware(
            method: authMethod,
            transport: authTransport
        )

        // THEN
        switch (authMethod, authTransport) {
        case let (.consumer(key, secret), .onHeader):
            #expect(middleware.authItems == nil)
            #expect(middleware.authField == .init(
                name: .authorization,
                value: "Discogs \(String.Parameter.key)=\(key), \(String.Parameter.secret)=\(secret)"
            ))

        case let (.consumer(key, secret), .onQuery):
            #expect(middleware.authField == nil)
            #expect(middleware.authItems == [
                .init(name: .Parameter.key, value: key),
                .init(name: .Parameter.secret, value: secret)
            ])

        case let (.user(token), .onHeader):
            #expect(middleware.authItems == nil)
            #expect(middleware.authField == .init(
                name: .authorization,
                value: "Discogs \(String.Parameter.token)=\(token)"
            ))
            
        case let (.user(token), .onQuery):
            #expect(middleware.authField == nil)
            #expect(middleware.authItems == [
                .init(name: .Parameter.token, value: token)
            ])

        case (.none, _):
            #expect(middleware.authField == nil)
            #expect(middleware.authItems == nil)
        }
    }

    /// Asserts the error throwing (if justified) during the initialization of a middleware.
    /// - Parameters:
    ///   - authMethod: A representation of an authentication method.
    ///   - authTransport: A representation of an authentication transport.
    ///   - error: An expected error of type ``InputValidationError`` during the initialization of a middleware.
    func assertInitThrows(
        authMethod: AuthMethod,
        authTransport: AuthTransport,
        expects error: InputValidationError?
    ) {
        // GIVEN
        // WHEN
        // THEN
        if let error {
            #expect(throws: error) {
                try AuthMiddleware(
                    method: authMethod,
                    transport: authTransport
                )
            }
        } else {
            #expect(throws: Never.self) {
                try AuthMiddleware(
                    method: authMethod,
                    transport: authTransport
                )
            }
        }
    }
    
    /// Asserts the interception of a request to add its authentication.
    /// - Parameters:
    ///   - authMethod: A representation of an authentication method.
    ///   - authTransport: A representation of an authentication transport.
    ///   - path: A URI path for a request.
    ///   - headerFields: A set of header fields for a request.
    /// - Throws:An error in case of an unexpected issue encountered while running a test case.
    func assertIntercept(
        authMethod: AuthMethod,
        authTransport: AuthTransport,
        path: String,
        headerFields: HTTPFields = [:],
    ) async throws {
        // GIVEN
        let middleware = try AuthMiddleware(
            method: authMethod,
            transport: authTransport
        )
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
                switch (authMethod, authTransport) {
                case (.consumer, .onHeader):
                    #expect(request.path == path)
                    #expect(request.headerFields != headerFields)
                    #expect(request.headerFields.contains(where: { $0.name == .authorization }))

                case (.consumer, .onQuery):
                    #expect(request.headerFields == headerFields)
                    try assertAuthInPath(request.path, authMethod)

                case (.user, .onHeader):
                    #expect(request.path == path)
                    #expect(request.headerFields != headerFields)
                    #expect(request.headerFields.contains(where: { $0.name == .authorization }))

                case (.user, .onQuery):
                    #expect(request.headerFields == headerFields)
                    try assertAuthInPath(request.path, authMethod)

                case (.none, _):
                    #expect(request.path == path)
                    #expect(request.headerFields == headerFields)
                }
                
                confirmation()
                
                return (.init(status: .ok) , nil)
            }
        }
    }
    
    /// Asserts the value of `shouldAuthenticate` flag after an initialization of a middleware.
    /// - Parameters:
    ///   - authMethod: A representation of an authentication method.
    ///   - authTransport: A representation of an authentication transport.
    ///   - flag: An expected flag that indicates whether the middleware should authenticate its requests or not.
    /// - Throws: An error of type ``InputValidationError`` in case of an unexpected issue occurs while running test cases.
    func assertShouldAuthenticate(
        authMethod: AuthMethod,
        authTransport: AuthTransport,
        expects flag: Bool
    ) throws {
        // GIVEN
        // WHEN
        let middleware = try AuthMiddleware(
            method: authMethod,
            transport: authTransport
        )
        
        // THEN
        #expect(middleware.shouldAuthenticate == flag)
    }
    
    /// Asserts a request path to contain authentication parameters in its query.
    /// - Parameters:
    ///   - path: A request path
    ///   - authMethod: A representation of an authentication method.
    /// - Throws:An error in case of an unexpected issue encountered while unwrapping the optionals.
    func assertAuthInPath(
        _ path: String?,
        _ authMethod: AuthMethod
    ) throws {
        let pathRequest = try #require(path)
        let urlComponents = try #require(URLComponents(string: pathRequest))
        let queryItems = try #require(urlComponents.queryItems)
        
        switch authMethod {
        case .consumer:
            #expect(queryItems.count >= 2)
            #expect(queryItems.contains(where: { $0.name == .Parameter.key }))
            #expect(queryItems.contains(where: { $0.name == .Parameter.secret }))
        case .user:
            #expect(queryItems.count >= 1)
            #expect(queryItems.contains(where: { $0.name == .Parameter.token }))
        case .none: break
        }
    }

}

// MARK: - Helpers

private extension AuthMiddlewareTests {
    
    // MARK: Properties
    
    /// Provides a random authentication transport representation.
    var randomTransport: AuthTransport {
        get throws {
            try #require(AuthTransport.allCases.randomElement())
        }
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of authentication methods to use in most of the test cases.
    static let authMethods: [AuthMethod] = [
        .consumer(key: "aAbBcCdDeEfFgGhHiIjJ", secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP"),
        .user(token: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStT"),
        .none
    ]
    /// A list of authentication methods to use in the initialization throw test cases.
    static let authMethodsThrows: [AuthMethod] = authMethods + [
        .consumer(key: .empty, secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP"),
        .consumer(key: "aAbBcCdDeEfFgGhHiI", secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP"),
        .consumer(key: "aAbBcCdDeEfFgGhHiIjJkK", secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP"),
        .consumer(key: "a4bBcCdDe3fFg6hH1Ij7", secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpP"),
        .consumer(key: "aAbBcCdDeEfFgGhHiIjJ", secret: .empty),
        .consumer(key: "aAbBcCdDeEfFgGhHiIjJ", secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoO"),
        .consumer(key: "aAbBcCdDeEfFgGhHiIjJ", secret: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQ"),
        .consumer(key: "aAbBcCdDeEfFgGhHiIjJ", secret: "a4bBcCdDe3fFg6hH1IjJkK1LmMnNo0p9"),
        .user(token: .empty),
        .user(token: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsS"),
        .user(token: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuU"),
        .user(token: "a4bBcCdDe3fFg6hH1IjJkK1LmMnNo0p9qQrRs5t7"),
    ]
}

private extension Output {
    /// A list of expected input validation errors (if thrown) coming from the initialization throw test cases.
    static let authMethodsThrows: [InputValidationError?] = [nil, nil, nil, .inputIsEmpty, .inputNotConsumerKey, .inputNotConsumerKey, .inputNotConsumerKey, .inputIsEmpty, .inputNotConsumerSecret, .inputNotConsumerSecret, .inputNotConsumerSecret, .inputIsEmpty, .inputNotUserToken, .inputNotUserToken, .inputNotUserToken]
    /// A list of expected boolean flags coming from the should authenticate test cases.
    static let authMethodsShouldAuthenticate: [Bool] = [true, true, false]
}
