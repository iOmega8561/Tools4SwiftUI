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
//  SceneCommands.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 11/11/24.
//

#if os(macOS)
/// `SceneCommands` is a custom set of app commands that enhances and customizes the macOS menu bar.
///
/// This struct defines a collection of commands for macOS applications, including custom actions for window management,
/// help links, and overriding default command groups. The commands are grouped and organized using SwiftUI's `Commands` API.
///
/// - Features:
///   - Custom commands for opening windows.
///   - Help menu links to external resources such as a README or privacy policy.
///   - Keyboard shortcuts for quick access to help links.
///   - Overrides for default macOS menu groups like pasteboard, undo/redo, and toolbar.
///
/// - Note:
///   - The help menu items include customizable keyboard shortcuts.
@available(macOS 13.0, *)
public struct SceneCommands: Commands {
    
    /// The URL of the website to be linked in the help menu.
    ///
    /// This URL is used to generate links for the README and privacy policy in the help menu.
    private let websiteURL: URL
    
    /// Provides access to the `openWindow` environment value, allowing commands to open specific app windows.
    @Environment(\.openWindow) private var openWindow
    
    /// The body of the `SceneCommands`, defining the commands and their behavior.
    ///
    /// This includes:
    /// - Customization of command groups, such as removing or replacing default macOS commands.
    /// - Adding custom commands to manage windows and provide help links.
    @CommandsBuilder public var body: some Commands {
        
        // Removes the default Pasteboard commands
        CommandGroup(replacing: .pasteboard) { }
        
        // Removes the default Undo/Redo commands
        CommandGroup(replacing: .undoRedo) { }
        
        // Removes the default Toolbar commands
        CommandGroup(replacing: .toolbar) { }
        
        // Adds a custom window management command
        CommandGroup(after: .windowArrangement) {
            Button("window-main-title") { openWindow(id: "main") }
        }
        
        // Adds custom help commands with links to external resources
        CommandGroup(replacing: .help) {
            
            Link(destination: websiteURL) {
                Text(verbatim: .module("action-help-readme"))
            }
            .keyboardShortcut("/", modifiers: [.command, .control])
            
            Link(destination: websiteURL.appendingPathComponent("privacy.html")) {
                Text(verbatim: .module("action-help-privacy"))
            }
            .keyboardShortcut("/", modifiers: [.command, .option])
        }
    }
    
    /// Initializes a `SceneCommands` instance with the given website URL.
    ///
    /// - Parameter websiteURL: The base URL for the help menu links.
    public init(websiteURL: URL) {
        self.websiteURL = websiteURL
    }
}
#endif
