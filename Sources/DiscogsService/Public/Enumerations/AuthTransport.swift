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

/// A representation of the available transport options to send credentials in authenticated requests.
public enum AuthTransport: Sendable {
    /// Authentication credential are sent in a request as an `Authentication` header.
    ///
    /// This means that the header will be added to any existing header in a request, like this:
    /// ```bash
    /// curl "https://api.discogs.com/database/search?q=Slayer" -H "Authorization: Discogs key=foo123, secret=bar456"
    /// curl "https://api.discogs.com/database/search?q=Slayer" -H "Authorization: Discogs token=abcxyz123456"
    /// ```
    case onHeader
    /// Authentication credential are sent in a request as parameters in the query string.
    ///
    /// This means that the parameters will be injected into the query in a request, like this:
    /// ```bash
    /// curl "https://api.discogs.com/database/search?q=Slayer&key=foo123&secret=bar456"
    /// curl "https://api.discogs.com/database/search?q=Slayer&token=abcxyz123456"
    /// ```
    case onQuery
}
