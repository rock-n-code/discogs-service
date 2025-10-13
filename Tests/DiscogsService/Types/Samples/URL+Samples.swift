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

extension URL {
    /// A namespace assigned for URL samples on test cases.
    enum Sample {
        /// A base URL sample.
        static let baseURL = URL(string: "https://sample.domain.com")!
    }
}
