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

import Foundation

/// A type that represents a product that uses the ``Client`` client.
public struct Product: Sendable {
    
    // MARK: Properties
    
    /// A camel-cased name of a product.
    let name: String
    
    /// A URI link related to a product.
    let url: String
    
    /// A semantic version of a product.
    let version: String
    
    // MARK: Initializers
    
    /// Initializes this model.
    /// - Parameters:
    ///   - name: A camel-cased name of a product.
    ///   - version: A semantic version of a product.
    ///   - url: A URI link related to a product.
    public init(
        name: String,
        version: String,
        url: String
    ) {
        self.name = name
        self.url = url
        self.version = version
    }

}
