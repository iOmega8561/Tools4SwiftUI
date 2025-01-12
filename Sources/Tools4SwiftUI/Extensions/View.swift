//
//  View.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 05/01/25.
//

import SwiftUI

import UniformTypeIdentifiers

public extension View {
    
    func asyncFileImporter(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        allowsMultipleSelection: Bool = false,
        completionHandler: @escaping ([URL]) async throws -> Void
    ) -> some View {
        return self.modifier(AsyncFileImporter(isPresented: isPresented, allowedContentTypes: allowedContentTypes, allowsMultipleSelection: allowsMultipleSelection, completionHandler: completionHandler))
    }
    
    /// Using this method we can simply call `.bootstrapTask` as a modifier on our Views
    /// - Parameter handler: The asynchronous closure to be executed only once
    ///
    /// - SeeAlso: `BootstrapTask`
    func bootstrapTask(handler: @escaping () async throws -> Void) -> some View {
        return self.modifier(BootstrapTask(handler: handler))
    }
    
    /// Adds an error alert to the view, displaying a message whenever the provided error is non-`nil`.
    ///
    /// This method uses the `ErrorAlert` view modifier to present an alert with the localized description
    /// of the provided error. A dismiss button clears the error and hides the alert.
    ///
    /// - Parameter currentError: A binding to an optional `Error` that triggers the alert when non-`nil`.
    /// - Returns: A view modified to present an error alert.
    func errorAlert(currentError: Binding<Error?>) -> some View {
        return self.modifier(ErrorAlert(currentError: currentError))
    }
    
    #if os(macOS)
    /// Applies full-screen presentation options to the window containing the view on macOS.
    ///
    /// Use this modifier to customize how the window behaves when entering full-screen mode. You can specify presentation options such as
    /// automatically hiding the toolbar or setting the full-screen appearance of the window.
    ///
    /// - Parameter options: A set of `NSApplication.PresentationOptions` that define the window's behavior in full-screen mode.
    ///
    /// Example usage:
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Hello, World!")
    ///             .windowFullScreenPresentationOptions([.autoHideToolbar, .fullScreen])
    ///     }
    /// }
    /// ```
    ///
    /// ### Supported Options
    /// - `.autoHideToolbar`: Hides the toolbar when the window enters full-screen mode.
    /// - `.fullScreen`: Ensures the window uses the full-screen space.
    ///
    /// For more options, refer to the `NSApplication.PresentationOptions` documentation.
    ///
    /// - Returns: A view modified to apply the specified full-screen presentation options.
    func windowFullScreenPresentationOptions(_ options: NSApplication.PresentationOptions) -> some View {
        self.modifier(WindowFullScreenPresentationOptions(options))
    }
    
    /// Applies full-screen presentation options and a tabbing mode to the window containing the view on macOS.
    ///
    /// This modifier allows you to customize how the window behaves when entering full-screen mode and control the window's tabbing behavior.
    ///
    /// - Parameters:
    ///   - options: A set of `NSApplication.PresentationOptions` that define the window's behavior in full-screen mode.
    ///   - tabbingMode: The tabbing mode for the window. Options include:
    ///     - `.automatic`: Default behavior for tabbing, based on system settings.
    ///     - `.preferred`: Suggests the window prefers tabbing.
    ///     - `.disallowed`: Prevents the window from using tabs.
    ///
    /// Example usage:
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Hello, World!")
    ///             .windowFullScreenPresentationOptions([.autoHideToolbar, .fullScreen], tabbingMode: .preferred)
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A view modified to apply the specified full-screen presentation options and tabbing mode.
    func windowFullScreenPresentationOptions(_ options: NSApplication.PresentationOptions, tabbingMode: NSWindow.TabbingMode) -> some View {
        self.modifier(WindowFullScreenPresentationOptions(options, tabbingMode: tabbingMode))
    }
    #endif
}
