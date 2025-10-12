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
    enum Format {}
    
    /// A namespaces assigned for the formats of regular expression patterns.
    enum Pattern {}
}
