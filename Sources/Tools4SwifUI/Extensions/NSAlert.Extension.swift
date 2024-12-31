//
//  NSAlert.Extension.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 31/12/24.

#if os(macOS)

import AppKit

extension NSAlert {
    
    @MainActor static func displayError(_ error: Error, style: NSAlert.Style = .warning) {
        let alert = NSAlert()
        
        alert.alertStyle = style
        alert.informativeText = error.localizedDescription
        alert.messageText = String(localized: "alert-title-error")
        alert.addButton(withTitle: "OK")
        
        if let main = NSApp.mainWindow, let key = NSApp.keyWindow {
            
            alert.beginSheetModal(for: key.isSheet ? key:main)

        } else { _ = alert.runModal() }
    }
    
    @MainActor static func fatalError(_ error: Error) -> Never {
        displayError(error, style: .critical); exit(EXIT_FAILURE)
    }
}

#endif
