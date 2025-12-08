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
//  HelpCommands.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 07/12/25.
//

#if os(macOS)
public struct HelpCommands: Commands {
    
    /// The URL of the app’s official website shown in the Help menu.
    ///
    /// When set, this URL is used to create a menu item that opens the app’s main documentation
    /// or landing page (e.g. README / user guide).
    private let officialWebsiteURL: URL?
    
    /// The URL of the app’s privacy policy shown in the Help menu.
    ///
    /// When set, this URL is used to create a dedicated menu item that opens the privacy policy.
    private let privacyPolicyURL: URL?
    
    /// Defines the commands exposed by this `HelpCommands` instance.
    ///
    /// This implementation:
    /// - Replaces the default “New” item with async-aware document creation.
    /// - Replaces the default “Open” item with async-aware document opening.
    /// - Removes the default Pasteboard, Undo/Redo and Toolbar command groups.
    /// - Replaces the Help menu with links to the official website and the privacy policy.
    @CommandsBuilder public var body: some Commands {
        
        CommandGroup(replacing: .help) {
            
            if let officialWebsiteURL {
                Link(destination: officialWebsiteURL) {
                    Label("action-help-readme", systemImage: "safari")
                        .labelStyle(.titleAndIcon)
                }
                .keyboardShortcut("/", modifiers: [.command, .control])
            }
            
            if let privacyPolicyURL {
                Link(destination: privacyPolicyURL) {
                    Label("action-help-privacy", systemImage: "person.badge.key")
                        .labelStyle(.titleAndIcon)
                }
                .keyboardShortcut("/", modifiers: [.command, .option])
            }
        }
    }
    
    /// Creates a new `HelpCommands` configuration.
    ///
    /// Use this initializer to provide:
    /// - A URL for the official website shown in the Help menu.
    /// - A URL for the privacy policy page.
    ///
    /// - Parameters:
    ///   - officialWebsiteURL: The base URL for the official website help link.  
    ///   - privacyPolicyURL: The URL of the privacy policy page.
    public init(
        officialWebsiteURL: URL?,
        privacyPolicyURL: URL?
    ) {
        self.officialWebsiteURL = officialWebsiteURL
        self.privacyPolicyURL = privacyPolicyURL
    }
}
#endif
