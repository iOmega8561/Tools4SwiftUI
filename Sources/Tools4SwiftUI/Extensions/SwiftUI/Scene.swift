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
//  Scene.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 07/12/25.
//

public extension Scene {
    
    /// Removes the default command group associated with the given placement
    /// from this scene by replacing it with an empty `CommandGroup`.
    ///
    /// SwiftUI’s `commands` modifier does not provide a built-in API to
    /// “disable” or “hide” system command groups individually. However, a
    /// `CommandGroup` created with the `replacing:` initializer will override
    /// the system-provided group at that placement. By providing an empty
    /// group (`{}`), we effectively remove all the default commands that
    /// would normally appear there.
    ///
    /// This helper is intended to be used in extension methods on `Scene`
    /// (for example, when building utilities that accept a list of
    /// `CommandGroupPlacement` values) so that each placement can be removed
    /// in a concise and expressive way.
    ///
    /// - Parameter placement: The `CommandGroupPlacement` whose default
    ///   commands should be replaced with an empty group, such as
    ///   `.pasteboard`, `.undoRedo`, or `.toolbar`.
    /// - Returns: A new scene with the specified command group replaced
    ///   and therefore effectively removed from the app’s menu structure.
    func removeCommand(for placement: CommandGroupPlacement) -> some Scene {
        return self.commands {
            CommandGroup(replacing: placement) {}
        }
    }
    
    /// Adds a reusable set of utility commands to the scene.
    ///
    /// These commands customize the standard macOS menu by:
    /// - Replacing the default “New” and “Open” items with async-aware actions.
    /// - Removing unused default command groups (Pasteboard, Undo/Redo, Toolbar).
    /// - Providing help items that open the official website and the privacy policy.
    ///
    /// - Parameters:
    ///   - officialWebsiteURL: The URL of the app’s official website, used in the Help menu.  
    ///   - privacyPolicyURL: The URL of the privacy policy page to open from the Help menu.
    ///   - newDocumentAction: An optional async action invoked when the user selects “New” (⌘N).
    ///   - openDocumentAction: An optional async action invoked when the user selects “Open” (⌘O).
    func helpCommands(
        officialWebsiteURL: URL? = nil,
        privacyPolicyURL: URL? = nil,
    ) -> some Scene {
        return self.commands {
            HelpCommands(
                officialWebsiteURL: officialWebsiteURL,
                privacyPolicyURL: privacyPolicyURL,
            )
        }
    }
    
    /// Adds a reusable set of document-oriented utility commands to the scene.
    ///
    /// These commands customize the standard macOS menu by:
    /// - Replacing the default “New” and “Open” items with async-aware actions (Create, Read).
    /// - Replacing the default “Save” group with async-aware Save/Delete actions (Update, Delete).
    /// - Removing unused default command groups (Pasteboard, Undo/Redo, Toolbar).
    /// - Providing help items that open the official website and the privacy policy.
    ///
    /// - Parameters:
    ///   - newDocumentAction: An optional async action invoked when the user selects “New” (⌘N).
    ///   - openDocumentAction: An optional async action invoked when the user selects “Open” (⌘O).
    ///   - saveDocumentAction: An optional async action invoked when the user selects “Save” (⌘S).
    ///   - deleteDocumentAction: An optional async action invoked when the user selects “Delete”
    ///
    func editorCommands(
        newDocumentAction: (@Sendable () async throws -> Void)? = nil,
        openDocumentAction: (@Sendable () async throws -> Void)? = nil,
        saveDocumentAction: (@Sendable () async throws -> Void)? = nil,
        deleteDocumentAction: (@Sendable () async throws -> Void)? = nil
    ) -> some Scene {
        return self.commands {
            EditorCommands(
                newDocumentAction: newDocumentAction,
                openDocumentAction: openDocumentAction,
                saveDocumentAction: saveDocumentAction,
                deleteDocumentAction: deleteDocumentAction
            )
        }
    }
}

/*
 func removeEditorCommands() -> some Scene {
     return self
         .removeCommand(for: .pasteboard)
         .removeCommand(for: .undoRedo)
         .removeCommand(for: .toolbar)
 }
 */
