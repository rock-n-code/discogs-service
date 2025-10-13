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
import struct HTTPTypes.HTTPField
import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest
import struct HTTPTypes.HTTPResponse

/// A middleware that attaches the user agent header into the requests to the service.
///
/// Please refer to the [Discogs documentation](https://www.discogs.com/developers/#page:home,header:home-general-information) for further information.
public struct UserAgentMiddleware {
    
    // MARK: Properties

    /// A formatted value for the user agent header.
    let agentField: HTTPField
    
    // MARK: Initializers
    
    /// Initializes this middleware.
    /// - Parameter product: A product from which the user agent will be generated from.
    /// - Throws: An error of type ``InputValidationError`` in case an input failed any validation.
    public init(product: Product) throws {
        let agentName = ValidateInputUseCase(rules: .notNil, .notEmpty, .camelCase)
        let agentVersion = ValidateInputUseCase(rules: .notNil, .notEmpty, .semanticVersion)
        let agentURL = ValidateInputUseCase(rules: .notNil, .notEmpty, .url)
        
        try agentName(product.name)
        try agentVersion(product.version)
        try agentURL(product.url)
        
        self.agentField = .init(
            name: .userAgent,
            value: .init(format: .Format.userAgent, product.name, product.version, product.url)
        )
    }
    
}

// MARK: - ClientMiddleware

extension UserAgentMiddleware: ClientMiddleware {
    
    // MARK: Functions
    
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        return try await next(
            .init(
                method: request.method,
                scheme: request.scheme,
                authority: request.authority,
                path: request.path,
                headerFields: userAgentHeader(request.headerFields)
            ),
            body,
            baseURL
        )
    }
    
}

// MARK: - Helpers

private extension UserAgentMiddleware {
    
    // MARK: Functions
    
    /// Adds a user agent header to the existing header fields.
    /// - Parameter fields: A set of header fields to update.
    /// - Returns: An updated set of header fields including the user agent header.
    func userAgentHeader(_ fields: HTTPFields) -> HTTPFields {
        var fields = fields
        
        fields.append(agentField)

        return fields
    }
    
}

// MARK: - Constants

private extension String.Format {
    /// A format for the user agent header.
    static let userAgent = "%@/%@ +%@"
}
