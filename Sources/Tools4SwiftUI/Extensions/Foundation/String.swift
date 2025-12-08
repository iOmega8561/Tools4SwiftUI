//
//  Copyright 2025 Giuseppe Rocco
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  -----------------------------------------------------------------------
//
//  String.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

import Foundation

/// A collection of helper methods for loading localized strings
/// from both the package's module bundle and the main application bundle.
extension String {
    
    /// Returns a localized string from the Swift package's module bundle.
    ///
    /// This helper is a convenience wrapper around `String(localized:bundle:)`
    /// that always uses `Bundle.module`, which is the bundle generated for
    /// the Swift Package target. It is intended to be used by code that lives
    /// inside the package itself.
    ///
    /// - Parameter key: The localization key or value to be looked up in the
    ///   package's string catalog associated with `Bundle.module`.
    /// - Returns: The localized string resolved from the module bundle.
    static func module(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
    
    /// Returns a localized string by first looking in the main application
    /// bundle and, if no override is found, falling back to the package's
    /// module bundle.
    ///
    /// This method enables a cross-localization pattern where:
    /// 1. The app can provide its own localized string for a given key in its
    ///    own string catalog (stored in `Bundle.main`).
    /// 2. If the app does not provide an override, the default translation
    ///    shipped with the Swift package (stored in `Bundle.module`) is used.
    ///
    /// The `key` parameter is a `StaticString` so that it can safely be used
    /// as a localization key and be picked up by tooling for string catalogs.
    ///
    /// - Parameters:
    ///   - key: The static localization key that is used both by the app and
    ///     the package. If the key exists in the app's string catalog, that
    ///     value takes precedence; otherwise, the package's value is used.
    ///   - table: The optional name of the strings table (or string catalog).
    ///     Pass `nil` to use the default table.
    /// - Returns: The localized string resolved from the main bundle if an
    ///   override exists, or from the module bundle otherwise.
    static func crossLocalized(_ key: StaticString) -> String {
        
        // Sentinel value that should never appear as a real localization
        // and is used to detect whether the key exists in `Bundle.main`.
        let sentinelRaw = "\u{0001}__NO_OVERRIDE__"
        let sentinel = String.LocalizationValue(stringLiteral: sentinelRaw)
        
        // Step 1: Try to resolve the key from the app's main bundle
        // (`Bundle.main`). If the app has provided an override, this call
        // will return the localized string; otherwise, it will return the
        // sentinel value.
        let fromMain = String(
            localized: key,
            defaultValue: sentinel,
            bundle: .main
        )
        
        /// If the app has provided an override (i.e., we did not get the
        /// sentinel value back), return the string from the main bundle.
        if fromMain != sentinelRaw {
            return fromMain
        }
        
        /// Step 2: Fallback to the Swift package's module bundle. We convert
        /// the `StaticString` key into a regular `String`, then into a
        /// `String.LocalizationValue`, and use that to look up the localized
        /// value in `Bundle.module`.
        let keyString = key.description
        let keyValue = String.LocalizationValue(keyString)
        
        return .module(keyValue)
    }
}
