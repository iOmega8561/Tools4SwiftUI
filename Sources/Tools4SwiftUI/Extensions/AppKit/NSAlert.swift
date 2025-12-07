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
//  NSAlert.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

#if os(macOS)
public extension NSAlert {
    
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
    static func displayError(_ error: Error, style: NSAlert.Style = .warning) {
        let alert = NSAlert()
        
        alert.alertStyle = style
        alert.informativeText = error.localizedDescription
        alert.messageText = .module("alert-title-error")
        alert.addButton(
            withTitle: .module("alert-button-dismiss")
        )
        
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
    static func fatalError(_ error: Error) -> Never {
        displayError(error, style: .critical); exit(EXIT_FAILURE)
    }
}
#endif
