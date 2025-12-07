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
//  WindowPresentation.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

#if os(macOS)
/// A view modifier that customizes the behavior of a macOS window in full-screen
/// and manages its tabbing mode without taking ownership of the window delegate.
///
/// `WindowPresentation` is designed to work especially well with SwiftUI windows,
/// where the framework installs its own internal `NSWindowDelegate`. Instead of
/// replacing that delegate (which can break focus handling, tabbing, toolbar
/// behavior, or lifecycle callbacks), this modifier:
///
/// - Patches only the full-screen presentation hook on the existing delegate
///   using `NSWindow.patchFullScreenOptions(with:)`.
/// - Leaves all other delegate methods under SwiftUI’s control.
/// - Applies tabbing and background configuration directly on the window.
///
/// This keeps the customization narrowly focused on full-screen behavior and
/// basic window appearance, while preserving the default integration between
/// SwiftUI and AppKit.
///
/// ### When to use
/// Use `WindowPresentation` when you want to:
/// - Enforce specific `NSApplication.PresentationOptions` when entering full-screen,
///   such as auto-hiding the toolbar or controlling how the app appears system-wide.
/// - Configure `NSWindow.TabbingMode` (for example to disable tabbing for a window).
/// - Set a custom window background color to match the app’s visual design.
/// - Do all of the above **without** replacing the internal SwiftUI window delegate.
///
/// Example usage:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Hello, World!")
///             .modifier(
///                 WindowPresentation(
///                     [.autoHideToolbar, .fullScreen],
///                     tabbingMode: .disallowed,
///                     backgroundColor: .black
///                 )
///             )
///     }
/// }
/// ```
public struct WindowPresentation: ViewModifier {

    // MARK: - Properties

    /// Full-screen presentation options to enforce when the window enters
    /// full-screen. These options are injected into the existing window
    /// delegate instead of replacing it.
    private let fullScreenOptions : NSApplication.PresentationOptions
    
    /// The tabbing mode for the window. This is set directly on the window
    /// so you can opt in or out of macOS window tabbing semantics.
    private let tabbingMode: NSWindow.TabbingMode
    
    /// The background color of the `NSWindow`. This allows the window chrome
    /// to visually match your content, especially in full-screen scenarios.
    private let backgroundColor: NSColor?
            
    // MARK: - Body

    /// Modifies the content view so that, when it appears, the associated
    /// window is configured with the desired full-screen options, tabbing
    /// behavior, and background color.
    ///
    /// The modifier resolves the `keyWindow` at the time of appearance and:
    /// - Patches its delegate to override only `willUseFullScreenPresentationOptions`.
    /// - Applies the requested `tabbingMode`.
    /// - Sets the `backgroundColor` if provided.
    ///
    /// This keeps the configuration localized to the window that owns the
    /// modified SwiftUI hierarchy, and avoids interfering with other windows.
    ///
    /// - Parameter content: The content view to modify.
    /// - Returns: A view whose owning window is configured according to the
    ///   supplied presentation, tabbing, and background settings.
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard let window = NSApp.keyWindow else {
                    return
                }
                
                window.patchFullScreenOptions(with: fullScreenOptions)
                window.tabbingMode = tabbingMode
                window.backgroundColor = backgroundColor
            }
    }
    
    // MARK: - Initializers

    /// Creates a `WindowPresentation` modifier with the specified full-screen
    /// options, tabbing mode, and background color.
    ///
    /// The primary goal of this initializer is to let you define how the
    /// window *behaves* rather than how it is wired internally. By passing
    /// a set of full-screen options, you describe the desired user experience
    /// (e.g. “hide the toolbar when in full-screen” or “enter app-wide
    /// full-screen”), while the modifier handles the underlying delegate
    /// patching transparently.
    ///
    /// - Parameters:
    ///   - fullScreenOptions: A set of `NSApplication.PresentationOptions`
    ///     that define how the window should appear and behave in full-screen.
    ///   - tabbingMode: The tabbing mode for the window. Defaults to
    ///     `.automatic`, which preserves the system’s default behavior.
    ///   - backgroundColor: The optional `NSColor` used as the window’s
    ///     background, allowing visual alignment with the SwiftUI content.
    public init(
        _ fullScreenOptions: NSApplication.PresentationOptions,
        tabbingMode: NSWindow.TabbingMode = .automatic,
        backgroundColor: NSColor = NSColor.windowBackgroundColor
    ) {
        self.fullScreenOptions = fullScreenOptions
        self.tabbingMode = tabbingMode
        self.backgroundColor = backgroundColor
    }
}
#endif
