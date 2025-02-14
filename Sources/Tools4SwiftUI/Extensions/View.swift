//
//  View.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 05/01/25.
//

import UniformTypeIdentifiers

public extension View {
    
    /// Conditionally transforms the view.
    ///
    /// Use this method to apply a transformation to the view only if the specified condition is true.
    /// If the condition is false, the original view is returned unchanged.
    ///
    /// ### Example Usage:
    /// ```swift
    /// someView.conditionalModifier(showDoneButton) { view in
    ///     view.overlay(alignment: .bottom) {
    ///         Button {
    ///             counter += 1
    ///         } label: {
    ///             Text("Ok!")
    ///         }
    ///         .buttonStyle(.bordered)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - booleanCondition: A Boolean value that determines whether the transformation should be applied.
    ///   - transformingClosure: A closure that transforms the view content when the condition is `true`.
    /// - Returns: A modified view if the condition is met; otherwise, the original view.
    @ViewBuilder func conditionalModifier<Content: View>(
        _ booleanCondition: Bool,
        transformingClosure: (Self) -> Content
    ) -> some View {
        
        if booleanCondition { transformingClosure(self) } else { self }
    }
    
    /// Attaches a file importer to the view, allowing users to select files asynchronously.
    ///
    /// This version supports specifying multiple allowed content types for the file importer.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a `Bool` that determines when the file importer is presented.
    ///   - allowedContentTypes: An array of `UTType` values representing the allowed content types.
    ///   - allowsMultipleSelection: A Boolean value indicating whether multiple files can be selected. Defaults to `false`.
    ///   - completionHandler: An asynchronous closure that processes the selected files.
    /// - Returns: A modified view that presents a file importer when `isPresented` is `true`.
    func asyncFileImporter(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        allowsMultipleSelection: Bool = false,
        completionHandler: @escaping ([URL]) async throws -> Void
    ) -> some View {
        return self.modifier(AsyncFileImporter(
            isPresented: isPresented,
            allowedContentTypes: allowedContentTypes,
            allowsMultipleSelection: allowsMultipleSelection,
            completionHandler: completionHandler
        ))
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
    ///             .windowPresentation([.autoHideToolbar, .fullScreen], tabbingMode: .preferred)
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A view modified to apply the specified full-screen presentation options and tabbing mode.
    func windowPresentation(_ fullScreenOptions: NSApplication.PresentationOptions, tabbingMode: NSWindow.TabbingMode = .automatic) -> some View {
        self.modifier(WindowPresentation(fullScreenOptions, tabbingMode: tabbingMode))
    }
    
    /// Opens a new window independently, enabling multiple instances without relying on WindowGroup.
    /// This extension is particularly useful for scenarios like managing virtual machines, where users may need
    /// several independent console windows simultaneously.
    ///
    /// - Important: The `@discardableResult` attribute prevents warnings about unused return values.
    ///
    /// - Parameters:
    ///   - title: The text to display as the window's title.
    ///   - sender: The object instance initiating the action, typically provided as `self`.
    ///   - styleMask: An optional parameter for customizing the window's style properties.
    ///   - toolbarStyle: Specifies the appearance of the window's toolbar. Defaults to `.unifiedCompact`.
    ///
    /// - Returns: The newly created `NSWindow` instance.
    @discardableResult
    func openAsWindow(
        title: String,
        sender: Any?,
        styleMask: NSWindow.StyleMask? = nil,
        toolbarStyle: NSWindow.ToolbarStyle = .unifiedCompact
    ) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let nsWindow = NSWindow(contentViewController: controller)
        nsWindow.contentViewController = controller
        nsWindow.title = title
        nsWindow.makeKeyAndOrderFront(sender)
        nsWindow.toolbarStyle = .unifiedCompact
        if let styleMask { nsWindow.styleMask = styleMask }
        return nsWindow
    }
    #endif
}
