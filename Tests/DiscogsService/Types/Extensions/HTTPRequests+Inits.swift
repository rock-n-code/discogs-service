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

import struct HTTPTypes.HTTPFields
import struct HTTPTypes.HTTPRequest

extension HTTPRequest {
    
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
