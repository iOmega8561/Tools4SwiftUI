//
//  WindowFullScreenPresentationOptions.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

#if os(macOS)
import AppKit
import SwiftUI

/// A view modifier that customizes the behavior of a window when entering full-screen mode and manages the tabbing mode on macOS.
///
/// Use `WindowFullScreenPresentationOptions` to define how a macOS window behaves when transitioning to full-screen mode by setting specific
/// `NSApplication.PresentationOptions` and controlling the `NSWindow.TabbingMode`.
///
/// This modifier is macOS-specific and leverages AppKit APIs for precise control over window behaviors.
///
/// ### Features
/// - Customize the full-screen presentation options of a window.
/// - Define the window's tabbing behavior.
/// - Automatically applies settings to the `keyWindow` when the modified view appears.
///
/// Example usage:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Hello, World!")
///             .modifier(WindowFullScreenPresentationOptions([.autoHideToolbar, .fullScreen]))
///     }
/// }
/// ```
public struct WindowFullScreenPresentationOptions: ViewModifier {

    // MARK: - Nested Types

    /// A private class that implements `NSWindowDelegate` to customize window behavior during full-screen transitions.
    private final class WindowDelegate: NSObject, NSWindowDelegate {

        private let presentationOptions: NSApplication.PresentationOptions

        /// Called by the window when determining full-screen presentation options.
        ///
        /// - Parameters:
        ///   - window: The window entering full-screen mode.
        ///   - proposedOptions: The default full-screen presentation options.
        /// - Returns: The custom presentation options provided during initialization.
        func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
            return presentationOptions
        }

        /// Initializes a `WindowDelegate` with the specified presentation options.
        ///
        /// - Parameter options: The full-screen presentation options to use.
        fileprivate init(_ options: NSApplication.PresentationOptions) {
            self.presentationOptions = options
        }
    }

    // MARK: - Properties

    /// The delegate responsible for customizing window behavior.
    private let windowDelegate: WindowDelegate

    /// The tabbing mode for the window.
    private let tabbingMode: NSWindow.TabbingMode

    // MARK: - Body

    /// Modifies the content view to apply the full-screen presentation options and tabbing mode.
    ///
    /// - Parameter content: The content view to modify.
    /// - Returns: A modified view with the specified window behaviors.
    public func body(content: Content) -> some View {
        content
            .onAppear {
                let window = NSApp.keyWindow
                window?.delegate = windowDelegate
                window?.tabbingMode = tabbingMode
            }
    }
    
    // MARK: - Initializers

    /// Creates a `WindowFullScreenPresentationOptions` modifier with the specified full-screen presentation options.
    ///
    /// - Parameter options: A set of presentation options that define the behavior of a window in full-screen mode.
    public init(_ options: NSApplication.PresentationOptions) {
        self.windowDelegate = WindowDelegate(options)
        self.tabbingMode = .automatic
    }

    /// Creates a `WindowFullScreenPresentationOptions` modifier with the specified full-screen presentation options and tabbing mode.
    ///
    /// - Parameters:
    ///   - options: A set of presentation options that define the behavior of a window in full-screen mode.
    ///   - tabbingMode: The tabbing mode for the window. Defaults to `.automatic`.
    public init(_ options: NSApplication.PresentationOptions, tabbingMode: NSWindow.TabbingMode) {
        self.windowDelegate = WindowDelegate(options)
        self.tabbingMode = tabbingMode
    }
}
#endif
