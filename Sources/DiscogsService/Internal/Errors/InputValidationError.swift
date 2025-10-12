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
enum InputValidationError: Error {
    /// An input is empty.
    case inputIsEmpty
    /// An input is nil.
    case inputIsNil
}
