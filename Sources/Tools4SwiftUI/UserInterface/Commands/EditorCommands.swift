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
//  EditorCommands.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 07/12/25.
//

public struct EditorCommands: Commands {
    
    /// Optional async action invoked when the user requests to create a new document.
    ///
    /// The closure is called from the customized “New” menu item and its associated shortcut (⌘N).
    /// If this value is `nil`, the “New” command is omitted.
    private let newDocumentAction: (@Sendable () async throws -> Void)?
    
    /// Optional async action invoked when the user requests to open an existing document.
    ///
    /// The closure is called from the customized “Open” menu item and its associated shortcut (⌘O).
    /// If this value is `nil`, the “Open” command is omitted.
    private let openDocumentAction: (@Sendable () async throws -> Void)?
    
    /// Optional async action invoked when the user requests to save the current document.
    ///
    /// The closure is called from the customized “Save” menu item and its associated shortcut (⌘S).
    /// If this value is `nil`, the “Save” command is omitted.
    private let saveDocumentAction: (@Sendable () async throws -> Void)?
    
    /// Optional async action invoked when the user requests to delete the current document.
    ///
    /// This is intended to perform a destructive operation such as moving the current document
    /// to the trash or removing it from the persistent store.
    ///
    /// If this value is `nil`, the “Delete” command is omitted.
    private let deleteDocumentAction: (@Sendable () async throws -> Void)?
    
    /// Defines the commands exposed by this `EditorCommands` instance.
    ///
    /// This implementation:
    /// - Replaces the default “New” item with async-aware document creation.
    /// - Replaces the default “Open” item with async-aware document opening.
    /// - Replaces the default “Save” group with async-aware Save/Delete commands.
    @CommandsBuilder public var body: some Commands {
        // Create (C) + Read (R)
        // Replaces the default “New” / “Open” items with
        // async variants bound to the provided actions.
        CommandGroup(replacing: .newItem) {
            if let newDocumentAction {
                AsyncButton("action-new-document",
                            systemImage: "plus",
                            action: newDocumentAction)
                .keyboardShortcut("N", modifiers: [.command])
            }
            if let openDocumentAction {
                AsyncButton("action-open-document",
                            systemImage: "arrow.up.forward",
                            action: openDocumentAction)
                .keyboardShortcut("O", modifiers: [.command])
            }
        }
        // Update (U) + Delete (D)
        // Replaces the default Save command group with
        // async Save/Delete operations.
        CommandGroup(replacing: .saveItem) {
            if let saveDocumentAction {
                AsyncButton("action-save-document",
                            systemImage: "square.and.arrow.down",
                            action: saveDocumentAction)
                .keyboardShortcut("S", modifiers: [.command])
            }
            if let deleteDocumentAction {
                AsyncButton("action-delete-document",
                            systemImage: "trash",
                            action: deleteDocumentAction)
            }
        }
    }
    
    /// Creates a new `EditorCommands` configuration.
    ///
    /// Use this initializer to provide:
    /// - Optional async actions for creating, opening, saving and deleting documents.
    ///
    /// - Parameters:
    ///   - newDocumentAction: Async closure executed when the user triggers the “New” command.
    ///   - openDocumentAction: Async closure executed when the user triggers the “Open” command.
    ///   - saveDocumentAction: Async closure executed when the user triggers the “Save” command.
    ///   - deleteDocumentAction: Async closure executed when the user triggers the “Delete” command.
    public init(
        newDocumentAction: (@Sendable () async throws -> Void)?,
        openDocumentAction: (@Sendable () async throws -> Void)?,
        saveDocumentAction: (@Sendable () async throws -> Void)?,
        deleteDocumentAction: (@Sendable () async throws -> Void)?
    ) {
        self.newDocumentAction = newDocumentAction
        self.openDocumentAction = openDocumentAction
        self.saveDocumentAction = saveDocumentAction
        self.deleteDocumentAction = deleteDocumentAction
    }
}

