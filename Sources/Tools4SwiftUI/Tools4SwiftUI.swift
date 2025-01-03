//
//  Tools4SwiftUI.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 31/12/24.

@_exported import SwiftUI

import AppKit

import UniformTypeIdentifiers

@MainActor public enum Tools4SwiftUI {
        
    /// Displays an error message to the user using an `NSAlert` object.
    ///
    /// This static method provides a convenient way to present errors to the user in a UI-friendly manner
    /// by using a modal alert dialog. The alert displays the localized description of the error and allows
    /// the user to dismiss it by pressing "OK".
    ///
    /// - Important: This method is marked with `@MainActor` to ensure it is executed on the main thread,
    ///              as `NSAlert` is a UI component that requires interaction on the main thread.
    ///
    /// - Parameters:
    ///   - error: The `Error` to present to the user.
    ///   - style: The style of the alert, which defaults to `.warning` but can be customized based on the severity of the error.
    public static func displayError(_ error: Error, style: NSAlert.Style = .warning) {
        let alert = NSAlert()
        
        alert.alertStyle = style
        alert.informativeText = error.localizedDescription
        alert.messageText = String(localized: "alert-title-error", bundle: .module)
        alert.addButton(withTitle: "OK")
        
        if let main = NSApp.mainWindow, let key = NSApp.keyWindow {
            
            alert.beginSheetModal(for: key.isSheet ? key:main)

        } else { _ = alert.runModal() }
    }
    
    /// Displays a critical error message to the user and terminates the application.
    ///
    /// This static method presents a critical error using an `NSAlert` with a `.critical` style
    /// and immediately exits the application after displaying the alert. This method is intended for
    /// unrecoverable errors where the application cannot continue running.
    ///
    /// - Important: This function is marked with `@MainActor` to ensure execution on the main thread,
    ///              as `NSAlert` requires interaction on the main thread.
    ///
    /// - Parameter error: The `Error` that caused the fatal condition, to be displayed to the user.
    ///
    /// - Returns: This method does not return, as it calls `exit(EXIT_FAILURE)` to terminate the application.
    public static func fatalError(_ error: Error) -> Never {
        displayError(error, style: .critical); exit(EXIT_FAILURE)
    }
    
    /// This method is very useful to access the macOS system file picker
    ///
    /// - Parameters:
    ///   - content: An array of possible `UTType` attributes, mainly to force selection of proper file extensions.
    public static func selectFile(_ allowedContent: UTType) async -> URL? {
        let openPanel = NSOpenPanel()
        
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowedContentTypes = [allowedContent]
        
        if let main = NSApp.mainWindow, let key = NSApp.keyWindow {
            
            return await openPanel.beginSheetModal(
                
                for: key.isSheet ? key:main
                
            ) == .OK ? openPanel.url:nil
                        
        } else { return openPanel.runModal() == .OK ? openPanel.url:nil }
    }
    
}
