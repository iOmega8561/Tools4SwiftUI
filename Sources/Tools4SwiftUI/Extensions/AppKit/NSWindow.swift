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
//  NSWindow.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 07/12/25.
//

#if os(macOS)
import ObjectiveC

extension NSWindow {
    
    /// A private helper class used only to obtain the correct Objective-C
    /// method signature for `window(_:willUseFullScreenPresentationOptions:)`.
    ///
    /// This type never participates in the actual delegate chain and is
    /// never instantiated at runtime. Instead, it provides a concrete
    /// implementation of the full-screen delegate method so that
    /// `class_getInstanceMethod` can be used to retrieve its type encoding.
    ///
    /// Having a dedicated probe class avoids depending on undocumented
    /// internal SwiftUI or AppKit delegate implementations, and keeps the
    /// patching logic decoupled from any specific framework details.
    ///
    /// By basing the method encoding on this probe instead of on real
    /// delegates, the patch remains more robust against changes in SwiftUI
    /// internals and continues to work as long as the public NSWindowDelegate
    /// API stays stable.
    private final class FullScreenProbe: NSObject, NSWindowDelegate {
        @objc func window(
            _ window: NSWindow,
            willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions
        ) -> NSApplication.PresentationOptions {
            // Never called, just here to provide the correct method signature
            proposedOptions
        }
        
        @available(*, unavailable)
        override init() {}
    }
    
    /// Installs a runtime patch on the current window delegate so that
    /// `window(_:willUseFullScreenPresentationOptions:)` returns the
    /// specified presentation options.
    ///
    /// Instead of replacing the `NSWindow.delegate` object (which in SwiftUI
    /// is managed internally and may implement many other behaviors), this
    /// method patches **only** the single full-screen customization hook.
    /// This allows you to override how full-screen presentation options are
    /// chosen without interfering with the rest of the delegate’s logic.
    ///
    /// This approach is especially useful with SwiftUI windows, where the
    /// framework installs its own private delegate. Replacing that delegate
    /// entirely can break focus handling, tabbing, toolbar behavior, or
    /// window lifecycle callbacks. By contrast, patching a single method:
    ///
    /// - Preserves all of SwiftUI’s internal window management.
    /// - Minimizes the surface area affected by the customization.
    /// - Keeps the change local to the full-screen experience only.
    ///
    /// The patch is applied at the Objective-C runtime level to the delegate
    /// **class**, so all instances of that delegate type will use the new
    /// behavior. This is a powerful technique and should be used carefully,
    /// but it provides a precise way to adapt full-screen behavior without
    /// taking ownership of the entire delegate implementation.
    ///
    /// Example:
    /// ```swift
    /// if let window = NSApp.keyWindow {
    ///     // Force this window to use a custom full-screen presentation
    ///     // where the toolbar auto-hides and the app enters full screen.
    ///     window.patchFullScreenOptions(with: [.autoHideToolbar, .fullScreen])
    /// }
    /// ```
    ///
    /// - Parameter options: The `NSApplication.PresentationOptions` that
    ///   should be returned by `window(_:willUseFullScreenPresentationOptions:)`
    ///   for this window’s delegate.
    func patchFullScreenOptions(with options: NSApplication.PresentationOptions) {
        
        guard let delegateObject = self.delegate as? NSObject else {
            return
        }

        let delegateClass: AnyClass = type(of: delegateObject)

        let selector = #selector(
            NSWindowDelegate.window(
                _:willUseFullScreenPresentationOptions:
            )
        )

        // Block that will become the new implementation.
        // Signature: (self, window, proposedOptions) -> NSApplication.PresentationOptions
        let block: @convention(block) (
            AnyObject,
            NSWindow,
            NSApplication.PresentationOptions
        ) -> NSApplication.PresentationOptions = { _, _, _ in
            return options
        }

        let imp = imp_implementationWithBlock(block)

        // Get the correct method encoding from the probe class
        guard let probeMethod = class_getInstanceMethod(FullScreenProbe.self, selector),
              let types = unsafe method_getTypeEncoding(probeMethod) else { return }

        // Try to *add* the method to the delegate class. If the delegate
        // does not currently implement this method, we simply attach our
        // implementation. If it already exists, we replace it so that only
        // the full-screen options behavior is overridden.
        if unsafe !class_addMethod(delegateClass, selector, imp, types) {
            // If it already exists, replace its implementation
            if let existing = class_getInstanceMethod(delegateClass, selector) {
                unsafe method_setImplementation(existing, imp)
            }
        }
    }
}
#endif
