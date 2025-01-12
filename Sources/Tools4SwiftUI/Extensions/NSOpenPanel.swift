//
//  NSOpenPanel.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

#if os(macOS)
import AppKit
import UniformTypeIdentifiers

public extension NSOpenPanel {
    
    /// Presents a file picker dialog to the user and returns the selected file URL asynchronously.
    ///
    /// This method uses `NSOpenPanel` to display a macOS file picker, allowing the user to select a single file
    /// that matches the specified content type. The file picker is presented as a modal sheet if a key window is
    /// available; otherwise, it runs as a standalone modal dialog.
    ///
    /// - Parameter allowedContent: The Uniform Type Identifier (`UTType`) that specifies the allowed file type(s) for selection.
    ///   For example, use `.plainText` for text files or `.image` for images.
    /// - Returns: The `URL` of the selected file if the user confirms their selection, or `nil` if the user cancels the dialog.
    ///
    /// ### Example Usage:
    /// ```swift
    /// @MainActor
    /// func selectFile() async {
    ///     if let selectedFile = await FilePicker.filePicker(.plainText) {
    ///         print("Selected file: \(selectedFile.path)")
    ///     } else {
    ///         print("No file selected.")
    ///     }
    /// }
    /// ```
    ///
    /// ### Behavior:
    /// - Displays a file picker dialog restricted to files of the specified type.
    /// - Prevents directory selection by setting `canChooseDirectories` to `false`.
    /// - Disables multiple file selection via `allowsMultipleSelection`.
    /// - The file picker is presented as a sheet if a key window or main window is available; otherwise, it appears as a modal dialog.
    ///
    /// ### Supported Platforms:
    /// - **macOS**
    ///
    /// ### Notes:
    /// - This method must be called from the main thread, as it interacts with AppKit's `NSOpenPanel`.
    /// - If both `mainWindow` and `keyWindow` are available, the method defaults to the `keyWindow` unless it is a sheet.
    ///
    /// - Important: Make sure to call this method from an `@MainActor` context.
    ///
    /// - See Also:
    ///   - `NSOpenPanel`
    ///   - `UTType` (Uniform Type Identifiers)
    static func filePicker(_ allowedContent: UTType) async -> URL? {
        let openPanel = NSOpenPanel()
        
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowedContentTypes = [allowedContent]
        
        if let main = NSApp.mainWindow, let key = NSApp.keyWindow {
            return await openPanel.beginSheetModal(
                for: key.isSheet ? key : main
            ) == .OK ? openPanel.url : nil
        } else {
            return openPanel.runModal() == .OK ? openPanel.url : nil
        }
    }
}
#endif
