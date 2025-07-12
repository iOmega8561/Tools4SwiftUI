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
//  NSSavePanel.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/07/25.
//

#if os(macOS)
import UniformTypeIdentifiers

public extension NSSavePanel {
    
    /// Presents an export dialog to the user and returns the selected file URL asynchronously.
    ///
    /// This method uses `NSSavePanel` to display a macOS file exporter, allowing the to select a single destination
    /// that matches the specified content type. The file exporter is presented as a modal sheet if a key window is
    /// available; otherwise, it runs as a standalone modal dialog.
    ///
    /// - Parameters:
    ///   - allowedContent: The Uniform Type Identifier (`UTType`) that specifies the allowed file type(s) for export.
    ///                     For example, use `.plainText` for text files or `.image` for images.
    ///   - defaultFileName: If passed, this will determine the default file name shown in the file exporter's text field.
    /// - Returns: The `URL` of the selected destination if the user confirms their selection, or `nil` if the user cancels the dialog.
    ///
    /// ### Example Usage:
    /// ```swift
    /// @MainActor
    /// func exportFile() async {
    ///     if let destination = await NSSavePanel.fileExporter(.plainText) {
    ///         print("Selected destination: \(destination.path)")
    ///     } else {
    ///         print("No destination selected.")
    ///     }
    /// }
    /// ```
    ///
    /// ### Behavior:
    /// - Displays a file exporter dialog restricted to files of the specified type.
    /// - Allows directory creation by setting `canCreateDirectories` to `true`.
    /// - The file exporter is presented as a sheet if a key window or main window is available; otherwise, it appears as a modal dialog.
    ///
    /// ### Supported Platforms:
    /// - **macOS**
    ///
    /// ### Notes:
    /// - This method must be called from the main thread, as it interacts with AppKit's `NSSavePanel`.
    /// - If both `mainWindow` and `keyWindow` are available, the method defaults to the `keyWindow` unless it is a sheet.
    ///
    /// - Important: Make sure to call this method from an `@MainActor` context.
    ///
    /// - See Also:
    ///   - `NSSavePanel`
    ///   - `UTType` (Uniform Type Identifiers)
    static func fileExporter(allowedContentTypes: [UTType], defaultFileName: String? = nil) async -> URL? {
        let savePanel = NSSavePanel()
        
        savePanel.canCreateDirectories = false
        savePanel.allowedContentTypes = allowedContentTypes
        
        if let defaultFileName {
            savePanel.nameFieldStringValue = defaultFileName
        }
        
        if let main = NSApp.mainWindow, let key = NSApp.keyWindow {
            return await savePanel.beginSheetModal(
                for: key.isSheet ? key : main
            ) == .OK ? savePanel.url : nil
        } else {
            return savePanel.runModal() == .OK ? savePanel.url : nil
        }
    }
}
#endif
