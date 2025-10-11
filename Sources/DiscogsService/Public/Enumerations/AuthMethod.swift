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

/// A representation of the available authentication methods at the Discogs service.
///
/// The differences between these authentication methods.
///
/// Credentials in request | Rate limiting? | Image URLs? |Authenticated as user?
/// --- | :---: | :---: | :---:
/// None | 🐢 Low tier | ❌ No |❌ No
/// Only Consumer key/secret | 🐰 High tier | ✔️ Yes | ❌ No
/// Personal access token | 🐰 High tier | ✔️ Yes | ✔️ Yes, for token holder only 👩
///
/// Please refer to the [Discogs documentation](https://www.discogs.com/developers#page:authentication,header:authentication-discogs-auth-flow) for further details.
public enum AuthMethod: Equatable, Sendable {
    /// A consumer key and secret that allows access to endpoints that requires authentication.
    case consumer(key: String, secret: String)
    /// No authentication method defined.
    case none
    /// A user token that allows access to its own account information.
    case user(token: String)
}
