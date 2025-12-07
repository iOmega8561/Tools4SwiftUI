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
//  HierarchicalShapeStyle.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 07/12/25.
//

/// Provides canonical foreground styles for buttons across platforms.
/// This is based on empirical testing while migrating to macOS 26,
/// which changed how `.primary` and `.secondary` render for button
/// states compared to earlier OS versions.
public extension HierarchicalShapeStyle {
    
    /// Foreground style used while the button is pressed.
    /// Always returns `.primary` to maximize contrast and legibility
    /// in the pressed state on all supported platforms.
    static var pressedButtonForegroundStyle: HierarchicalShapeStyle {
        return .primary
    }
    
    /// Foreground style used while the button is not pressed.
    /// On macOS 26 (and the corresponding iOS/watchOS/tvOS/visionOS
    /// releases), `.primary` empirically matches the system’s new
    /// unpressed button appearance.
    /// On earlier OS versions, `.secondary` better matches the
    /// legacy unpressed state, so we keep that to preserve the
    /// pre-26 visual behavior.
    static var unpressedButtonForegroundStyle: HierarchicalShapeStyle {
        if #available(macOS 26, iOS 26, watchOS 26, tvOS 26, visionOS 26,  *) {
            return .primary
        }
        
        return .secondary
    }
    
    /// Returns the appropriate foreground style for a button based on
    /// its pressed state.
    /// This centralizes the OS-conditional logic and the empirically
    /// tuned styles, so callers can simply request the correct style
    /// instead of duplicating `isPressed` and version checks.
    static func buttonForegroundStyle(for configuration: ButtonStyleConfiguration) -> HierarchicalShapeStyle {
        configuration.isPressed ? .pressedButtonForegroundStyle : .unpressedButtonForegroundStyle
    }
}
