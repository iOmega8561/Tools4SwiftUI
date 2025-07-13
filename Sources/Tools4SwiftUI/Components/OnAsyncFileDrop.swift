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
//  OnAsyncFileDrop.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 13/07/25.
//

import UniformTypeIdentifiers

/// A view modifier that handles drag-and-drop of file-based UTTypes and invokes an
/// async handler **off the main thread** whenever each file’s data has finished loading.
///
/// This modifier:
/// 1. Filters incoming drops to the specified `supportedContentTypes`.
/// 2. For each dropped provider, waits for the file representation to load (via `loadFileRepresentation`).
/// 3. Upon **completion of file loading**, dispatches your `handler()` inside a `Task(priority: .userInitiated)`
///    that is **detached from the MainActor** (annotated `@Sendable`) so heavy work does not block the UI.
/// 4. On error, reports via `NSAlert` on macOS or an `errorAlert` on other platforms.
///
/// - Note: Apple does *not* officially publish numeric drag-and-drop radii or scheduling details;
///   this modifier’s use of `Task(detached:)` ensures your handler runs on a background executor,
///   not on the MainActor.
public struct OnAsyncFileDrop: ViewModifier {
    
    /// The UTTypes this view will accept via drop.
    private let supportedContentTypes: [UTType]
    
    /// A binding that indicates when the drop target is active.
    @Binding private var isTargeted: Bool
    
    /// The asynchronous throwing closure to run **after** each file has been loaded.
    ///
    /// - Important: This closure is invoked inside a `Task(priority: .userInitiated)`
    ///   annotated `@Sendable` so that all of its work executes off the MainActor
    ///   and does *not* block the UI thread.
    private let handler: @Sendable (URL) async throws -> Void
    
    #if !os(macOS)
    /// Holds any error thrown by the handler, to be presented via `.errorAlert`.
    @State private var currentError: Error? = nil
    #endif
    
    public func body(content: Content) -> some View {
        content
            .onDrop(of: supportedContentTypes, isTargeted: $isTargeted) { providers in
                let didReceive = !providers.isEmpty
                
                for provider in providers {
                    // We know at least one type matches because of the `of:` filter.
                    guard let ut = provider.registeredContentTypes.first else {
                        continue
                    }
                    
                    // Load the file representation; call handler only when data is ready.
                    _ = provider.loadFileRepresentation(for: ut, openInPlace: true) { url, _, _ in
                        guard let fileURL = url else { return }
                        
                        // Fire-and-forget: handler runs asynchronously off MainActor.
                        Task(priority: .userInitiated) { @Sendable in
                            do {
                                try await handler(fileURL)
                            } catch {
                                #if !os(macOS)
                                await MainActor.run { currentError = error }
                                #else
                                await NSAlert.displayError(error)
                                #endif
                            }
                        }
                    }
                }
                
                return didReceive
            }
            #if !os(macOS)
            .errorAlert(currentError: $currentError)
            #endif
    }
    
    /// Creates the file-drop modifier.
    ///
    /// - Parameters:
    ///   - supportedContentTypes: The list of `UTType`s this view will accept via drag-and-drop.
    ///   - isTargeted: A `Binding<Bool>` that becomes `true` when a drag hovers over the view.
    ///                 Defaults to `.constant(false)` if not provided.
    ///   - handler: An `async throws` closure invoked **once per file** *after* its URL has been loaded.
    ///              It executes within a `Task` annotated `@Sendable` and detached from the MainActor,
    ///              ensuring that heavy processing does not block the UI.
    public init(
        of supportedContentTypes: [UTType],
        isTargeted: Binding<Bool> = .constant(false),
        handler: @Sendable @escaping (URL) async throws -> Void
    ) {
        self.supportedContentTypes = supportedContentTypes
        self._isTargeted = isTargeted
        self.handler = handler
    }
}
