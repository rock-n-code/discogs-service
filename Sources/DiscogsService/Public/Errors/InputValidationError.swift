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

/// A representation of all the possible validation error that could be thrown while validating an input.
public enum InputValidationError: Error {
    /// An input is empty.
    case inputIsEmpty
    /// An input is nil.
    case inputIsNil
    /// An input is not camel-case.
    case inputNotCamelCase
    /// An input does not comply with the consumer key requirements.
    case inputNotConsumerKey
    /// An input does not comply with the consumer secret requirements.
    case inputNotConsumerSecret
    /// An input is not a semantic version.
    case inputNotSemanticVersion
    /// An input is not a URL.
    case inputNotURL
    /// An input does not comply with the user token requirements.
    case inputNotUserToken
}
