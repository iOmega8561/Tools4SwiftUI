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
//  UIApplication.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 03/05/25.
//

#if canImport(UIKit)
import UIKit

public extension UIApplication {
    
    /// The root view controller of the app’s foreground active key window, if available.
    ///
    /// This computed property searches all connected scenes for one that is:
    /// - Actively in the foreground (user-facing)
    /// - A `UIWindowScene`
    /// - Contains a `keyWindow`
    ///
    /// It then returns the `rootViewController` of that key window. This is useful for presenting alerts
    /// or navigating the UI when you don’t have direct access to a view controller (e.g., in SwiftUI contexts).
    ///
    /// - Returns: The root view controller of the app’s current foreground active window, or `nil` if none is found.
    ///
    /// - Important: This implementation is **multi-scene-safe** and works reliably in multi-window contexts
    /// such as:
    ///   - iPadOS with split view or Slide Over
    ///   - visionOS with multiple simultaneous windows
    ///   - Apps using `UIScene`-based lifecycle (iOS 13+)
    ///
    /// - Note: If your app supports more than one active window at a time,
    ///         this returns the **first active** scene with a `keyWindow`.
    var rootViewController: UIViewController? {
        
        // Find the first active foreground window scene with a key window
        let scene = self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.keyWindow != nil })
        
        // Return its root view controller, if available
        return scene?.keyWindow?.rootViewController
    }
    
    /// Recursively finds and returns the topmost visible view controller in the app’s current view hierarchy.
    ///
    /// This method starts from a given base view controller (by default, the app’s `rootViewController`)
    /// and traverses through container view controllers (`UINavigationController`, `UITabBarController`)
    /// and any modally presented view controllers to locate the one that is currently visible to the user.
    ///
    /// - Parameter base: The starting point of the search. Defaults to `UIApplication.shared.rootViewController`.
    ///
    /// - Returns: The currently visible `UIViewController`, or `nil` if none can be found.
    ///
    /// - Important: This utility is particularly useful in SwiftUI apps when you need to present
    ///              UIKit views or alerts but don't have direct access to a `UIViewController`.
    func topViewController(base: UIViewController? = UIApplication.shared.rootViewController) -> UIViewController? {
        
        // If the base is a navigation controller, recurse into its visible view controller.
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        // If the base is a tab bar controller, recurse into the selected tab.
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        // If there's a view controller presented modally, recurse into it.
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        // Base case: return the last found view controller.
        return base
    }
}
#endif
