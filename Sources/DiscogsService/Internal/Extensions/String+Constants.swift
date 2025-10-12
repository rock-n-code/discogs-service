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

extension String {
    /// An empty string.
    static let empty = ""
    
    /// A namespaces assigned for the names of parameters.
    enum Parameter {
        /// A name for the consumer key.
        static let key = "key"
        /// A name for the consumer secret.
        static let secret = "secret"
        /// A name for the user token.
        static let token = "token"
    }
    /// A namespaces assigned for the formats of string values.
    enum Format {
        /// A format for the consumer authentication header.
        static let authConsumer = "Discogs \(String.Parameter.key)=%@, \(String.Parameter.secret)=%@"
        /// A format for the user authentication header.
        static let authUser = "Discogs \(String.Parameter.token)=%@"
        /// A format for the user agent header.
        static let userAgent = "%@/%@ +%@"
    }
}

