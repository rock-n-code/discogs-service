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

extension String {
    
    // MARK: Functions
    
    /// Checks whether a regular expression pattern fully matches a string or not.
    /// - Parameter pattern: A regular expression pattern to match a string against.
    /// - Returns: A flag that indicates whether a given pattern fully matches a string or not.
    func fullyMatch(pattern: String) -> Bool {
        do {
            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 6.0, *) {
                let securityInput = try Regex(pattern)
                let matches = self.wholeMatch(of: securityInput)
                
                return matches != nil
            } else {
                let securityInput = try NSRegularExpression(pattern: pattern)
                let matches = securityInput.matches(
                    in: self,
                    range: .init(location: 0, length: count)
                )
                
                return !matches.isEmpty
            }
        } catch {
            return false
        }
    }
    
}
