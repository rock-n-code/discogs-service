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
import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest
import struct HTTPTypes.HTTPResponse

/// A middleware that attaches any defined authentication credentials into the requests for the service.
///
/// Please refer to the [Discogs documentation](https://www.discogs.com/developers#page:authentication) for further information.
public struct AuthMiddleware {
    
    // MARK: Properties
    
    /// A representation of an authentication method to use to authenticate requests.
    private let method: AuthMethod
    
    /// A representation of a transport option to send credentials in requests.
    private let transport: AuthTransport
    
    // MARK: Initializers
    
    /// Initializes this middleware.
    /// - Parameters:
    ///   - method: A representation of an authentication method to use to authenticate requests.
    ///   - transport: A representation of a transport option to send credentials in requests.
    public init(
        method: AuthMethod = .none,
        transport: AuthTransport
    ) {
        self.method = method
        self.transport = transport
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
        guard method != .none else {
            return try await next(request, body, baseURL)
        }
        
        let headerFields = if transport == .onHeader {
            authenticateHeader(request.headerFields)
        } else {
            request.headerFields
        }
        
        let path = if transport == .onQuery {
            authenticatePath(request.path)
        } else {
            request.path
        }

        return try await next(
            .init(
                method: request.method,
                scheme: request.scheme,
                authority: request.authority,
                path: path,
                headerFields: headerFields
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
    /// - Returns: An updated set of header fields.
    func authenticateHeader(_ fields: HTTPFields) -> HTTPFields {
        var fields = fields
        
        let authorization: String = switch method {
        case let .consumer(key, secret): .init(format: .Format.authConsumer, key, secret)
        case let .user(token): .init(format: .Format.authUser, token)
        default: .empty
        }
        
        fields.append(.init(
            name: .authorization,
            value: authorization
        ))
        
        return fields
    }
    
    /// Adds the authentication parameters to the query of a path
    /// - Parameter path: A request path to authenticate.
    /// - Returns: An updated request path including the authentication parameters.
    func authenticatePath(_ path: String?) -> String? {
        guard
            let path,
            var urlComponents = URLComponents(string: path)
        else {
            return path
        }
        
        let authItems: [URLQueryItem] = switch method {
        case let .consumer(key, secret): [
            .init(name: .Parameter.key, value: key),
            .init(name: .Parameter.secret, value: secret)
        ]
        case let .user(token): [
            .init(name: .Parameter.token, value: token)
        ]
        default: []
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
