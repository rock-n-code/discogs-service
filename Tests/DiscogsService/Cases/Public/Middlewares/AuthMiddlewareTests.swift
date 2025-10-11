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
import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest
import struct HTTPTypes.HTTPResponse

import Testing

@testable import DiscogsService

@Suite("Auth Middleware", .tags(.middleware))
struct AuthMiddlewareTests {
    
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
    
    /// Asserts the interception of a request to add its authentication.
    /// - Parameters:
    ///   - authMethod: A representation of an authentication method.
    ///   - authTransport: A representation of an authentication transport.
    ///   - path: A URI path for a request.
    ///   - headerFields: A set of header fields for a request.
    func assertIntercept(
        authMethod: AuthMethod,
        authTransport: AuthTransport,
        path: String,
        headerFields: HTTPFields = [:],
    ) async throws {
        // GIVEN
        let middleware = AuthMiddleware(
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
                baseURL: .baseURL,
                operationID: .operationId
            ) { request, _, _ in
                // THEN
                switch (authMethod, authTransport) {
                case let (.consumer(key, secret), .onHeader):
                    #expect(request.path == path)
                    #expect(request.headerFields != headerFields)
                    #expect(request.headerFields[.authorization] == "Discogs key=\(key), secret=\(secret)")
                case (.consumer, .onQuery):
                    #expect(request.path != path)
                    try assertAuthInPath(request.path, authMethod)
                    #expect(request.headerFields == headerFields)
                case let (.user(token), .onHeader):
                    #expect(request.path == path)
                    #expect(request.headerFields != headerFields)
                    #expect(request.headerFields[.authorization] == "Discogs token=\(token)")
                case (.user, .onQuery):
                    #expect(request.path != path)
                    try assertAuthInPath(request.path, authMethod)
                    #expect(request.headerFields == headerFields)
                case (.none, _):
                    #expect(request.path == path)
                    #expect(request.headerFields == headerFields)
                }
                
                confirmation()
                
                return (.init(status: .ok) , nil)
            }
        }
    }
    
    /// Asserts a request path to contain authentication parameters in its query.
    /// - Parameters:
    ///   - path: A request path
    ///   - authMethod: A representation of an authentication method.
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

private extension HTTPRequest {
    
    // MARK: Initializers
    
    /// Initializes a HTTP request conveniently.
    /// - Parameters:
    ///   - method: A request method.
    ///   - path: A value of the “:path” pseudo header field.
    ///   - headerFields: A dictionary of request header fields.
    init(
        method: HTTPRequest.Method = .get,
        path: String?,
        headerFields: HTTPFields = [:]
    ) {
        self.init(
            method: method,
            scheme: nil,
            authority: nil,
            path: path,
            headerFields: headerFields
        )
    }
    
}

// MARK: - Constants

private extension Input {
    /// A list of authentication methods for a request.
    static let authMethods: [AuthMethod] = [
        .consumer(key: "SomeKey", secret: "SomeSecret"),
        .user(token: "SomeToken"),
        .none
    ]
}

private extension String {
    /// An operation ID sample.
    static let operationId = "SomeOperationId"
}

private extension URL {
    /// A base URL sample.
    static let baseURL = URL(string: "https://sample.domain.com")!
}
