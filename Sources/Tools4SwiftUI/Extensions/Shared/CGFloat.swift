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
//  CGFloat.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/07/25.
//

import Foundation

public extension CGFloat {
    
    /// A system-inspired default corner radius that adapts to the current Apple platform and OS version.
    ///
    /// This value is **not officially documented by Apple**, but has been determined through **empirical inspection**
    /// of system controls across multiple platforms and OS versions using tools like Xcode’s View Debugger,
    /// layer property introspection, and pixel-accurate comparison against native UI components.
    ///
    /// - On **macOS 15 and earlier**, system buttons and containers typically use a `5 pt` corner radius.
    /// - On **macOS 26 (Tahoe)** and newer, the system standard shifts to `10 pt` for buttons, sheets, and panels,
    ///   aligning with iOS and iPadOS conventions.
    /// - On **iOS, iPadOS, and watchOS**, the typical system radius is `8 pt`. Starting from **iOS 26** we shift to `10 pt`.
    /// - On **tvOS**, system cards and buttons use larger radii (typically `12–16 pt`) for better visibility.
    /// - On **visionOS**, spatial panels use radii in the range of `10–12 pt`.
    ///
    /// While these values are not official, they reflect **Apple’s current visual design across platforms** as seen in
    /// system apps and SwiftUI-rendered controls. This property is useful for achieving a native-feeling interface
    /// while maintaining consistency and adaptability across platforms.
    ///
    /// > ⚠️ This API does not guarantee future-proof visual parity with Apple’s UI. Always prefer native controls like
    /// > `.buttonStyle(.bordered)` or SwiftUI containers where possible to inherit system styling automatically.
    ///
    /// - Returns: A `CGFloat` representing the default corner radius appropriate for the current platform and version.
    static var bestRadius: CGFloat {
        #if os(tvOS)
        12          // tvOS cards & buttons
        #elseif os(visionOS)
        10          // mid-sized spatial panels
        #elseif os(iOS) || os(watchOS)
        if #available(iOS 26, watchOS 26, *) { // Liquid glass
            10
        } else {
            8
        }
        #elseif os(macOS)
        if #available(macOS 26, *) { // Tahoe & beyond
            10
        } else {
            5
        }
        #else
        8           // Fallback
        #endif
    }
}
