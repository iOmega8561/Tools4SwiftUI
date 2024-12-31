//
//  SceneCommands.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 11/11/24.
//

#if os(macOS)

import SwiftUI

@available(macOS 13.0, *)
public struct SceneCommands: Commands {
    
    public let websiteURL: URL
    
    @Environment(\.openWindow) private var openWindow
    
    @CommandsBuilder public var body: some Commands {
        
        CommandGroup(replacing: .pasteboard) { }
        
        CommandGroup(replacing: .undoRedo) { }
        
        CommandGroup(replacing: .toolbar) { }
        
        CommandGroup(after: .windowArrangement) {
            Button("window-main-title") { openWindow(id: "main") }
        }
        
        CommandGroup(replacing: .help) {
            
            Link(destination: websiteURL) {
                Text("action-help-readme")
            }
            .keyboardShortcut("/", modifiers: [.command, .control])
            
            Link(destination: websiteURL.appendingPathComponent("privacy.html")) {
                Text("action-help-privacy")
            }
            .keyboardShortcut("/", modifiers: [.command, .option])
        }
    }
}

#endif
