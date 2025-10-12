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

import class OpenAPIRuntime.HTTPBody

import protocol OpenAPIRuntime.ClientMiddleware

import struct Foundation.URL
import struct Foundation.URLComponents
import struct Foundation.URLQueryItem
import struct HTTPTypes.HTTPField
import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest
import struct HTTPTypes.HTTPResponse

/// A middleware that attaches any defined authentication credentials into the requests to the service.
///
/// Please refer to the [Discogs documentation](https://www.discogs.com/developers#page:authentication) for further information.
public struct AuthMiddleware {
    
    // MARK: Properties
    
    /// A header field that contains the authentication information.
    let authField: HTTPField?
    
    /// A list of query items that contains the authentication information.
    let authItems: [URLQueryItem]?

    // MARK: Initializers
    
    /// Initializes this middleware.
    /// - Parameters:
    ///   - method: A representation of an authentication method to use to authenticate requests.
    ///   - transport: A representation of a transport option to send credentials in requests.
    public init(
        method: AuthMethod = .none,
        transport: AuthTransport
    ) throws {
        switch method {
        case let .consumer(key, secret):
            let validateKey = ValidateInputUseCase(rules: .notNil, .notEmpty, .secure(.consumerKey))
            let validateSecret = ValidateInputUseCase(rules: .notNil, .notEmpty, .secure(.consumerSecret))
            
            try validateKey(key)
            try validateSecret(secret)
            
            self.authField = switch transport {
            case .onQuery: nil
            case .onHeader: .init(
                name: .authorization,
                value: .init(format: .Format.authConsumer, key, secret)
            )}
            
            self.authItems = switch transport {
            case .onHeader: nil
            case .onQuery: [
                .init(name: .Parameter.key, value: key),
                .init(name: .Parameter.secret, value: secret)
            ]}

        case let .user(token):
            let validateToken = ValidateInputUseCase(rules: .notNil, .notEmpty, .secure(.userToken))
            
            try validateToken(token)
            
            self.authField = switch transport {
            case .onQuery: nil
            case .onHeader: .init(
                name: .authorization,
                value: .init(format: .Format.authUser, token)
            )}
            
            self.authItems = switch transport {
            case .onHeader: nil
            case .onQuery: [
                .init(name: .Parameter.token, value: token)
            ]
            }

        case .none:
            self.authField = nil
            self.authItems = nil
        }
    }
    
    // MARK: Computed
    
    /// A flag that indicates whether the middleware should authenticate the intercepted request or not.
    var shouldAuthenticate: Bool {
        authField != nil || authItems != nil
    }
    
}

// MARK: - ClientMiddleware

extension AuthMiddleware: ClientMiddleware {
    
    // MARK: Functions
    
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        guard shouldAuthenticate else {
            return try await next(request, body, baseURL)
        }

        return try await next(
            .init(
                method: request.method,
                scheme: request.scheme,
                authority: request.authority,
                path: authenticatePath(request.path),
                headerFields: authenticateHeader(request.headerFields)
            ),
            body,
            baseURL
        )
    }
    
}

// MARK: - Helpers

private extension AuthMiddleware {
    
    // MARK: Functions
    
    /// Adds an authorization header to the existing header fields.
    /// - Parameter fields: A set of header fields to update.
    /// - Returns: An updated set of header fields including the authorization header.
    func authenticateHeader(_ fields: HTTPFields) -> HTTPFields {
        var fields = fields

        if let authField {
            fields.append(authField)
        }

        return fields
    }
    
    /// Adds the authentication parameters to the query of a path
    /// - Parameter path: A request path to authenticate.
    /// - Returns: An updated request path including the authentication parameters.
    func authenticatePath(_ path: String?) -> String? {
        guard
            let authItems,
            let path,
            var urlComponents = URLComponents(string: path)
        else {
            return path
        }

        var queryItems = urlComponents.queryItems ?? []
        
        queryItems.append(contentsOf: authItems)
        
        urlComponents.queryItems = queryItems
        
        return if let urlQuery = urlComponents.query {
            urlComponents.path + "?" + urlQuery
        } else {
            urlComponents.path
        }
    }
    
}

// MARK: - Constants

private extension String.Format {
    /// A format for the consumer authentication header.
    static let authConsumer = "Discogs \(String.Parameter.key)=%@, \(String.Parameter.secret)=%@"
    /// A format for the user authentication header.
    static let authUser = "Discogs \(String.Parameter.token)=%@"
}
