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
//  AsyncFileButton.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

#if os(macOS)

import UniformTypeIdentifiers

/// A macOS-specific SwiftUI component for selecting a file using `NSOpenPanel` with seamless integration of security-scoped resources.
///
/// `AsyncFileButton` provides an alternative to `AsyncFileImporter` by leveraging the native behavior of `NSOpenPanel`.
/// It allows users to select a single file and ensures proper handling of security-scoped resources for sandboxed macOS applications.
///
/// This component integrates with `AsyncButton` to provide a declarative, reusable button that performs asynchronous tasks after a file is selected.
///
/// ### Features:
/// - Presents a file picker using `NSOpenPanel`.
/// - Supports asynchronous actions on the selected file.
/// - Ensures proper handling of security-scoped resource access.
/// - Provides customizable labels for the button.
///
/// ### Example Usage:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         AsyncFileButton(
///             "Select a File",
///             allowedContentType: .plainText
///         ) { fileURL in
///             print("Selected file: \(fileURL.path)")
///             // Perform asynchronous operations with the selected file.
///         }
///         .padding()
///     }
/// }
/// ```
///
/// ### Parameters:
/// #### Initializer with Custom Label:
/// - `allowedContentType`: The file type allowed for selection, specified as a `UTType`.
/// - `action`: An asynchronous closure that processes the selected file. The closure receives a `URL` representing the selected file.
/// - `label`: A view builder that provides a custom label for the button.
///
/// #### Convenience Initializer with Text Label:
/// - `label`: A `String` representing the button text.
/// - `allowedContentType`: The file type allowed for selection, specified as a `UTType`.
/// - `action`: An asynchronous closure that processes the selected file.
///
/// ### Notes:
/// - The component uses `NSOpenPanel.filePicker` for file selection, ensuring behavior consistent with native macOS applications.
/// - The file picker supports a single file selection and automatically handles security-scoped resource access.
/// - This component is macOS-specific and is not available on other platforms.
///
/// ### Platform Support:
/// - **macOS**
///
/// ### See Also:
/// - `NSOpenPanel`
/// - `AsyncButton`
/// - `UTType`
public struct AsyncFileButton<Label: View>: View {
    
    // MARK: - Properties
    
    /// The allowed content type for the file picker.
    private let allowedContentType: UTType
    
    /// The asynchronous action to perform with the selected file.
    private let action: (URL) async throws -> Void
    
    /// A view builder that provides the button label.
    @ViewBuilder private let label: () -> Label
    
    // MARK: - Body
    
    /// The body of the `AsyncFileButton`.
    ///
    /// - Returns: A button that triggers a file picker and performs the specified asynchronous action on the selected file.
    public var body: some View {
        AsyncButton(action: {
            let file = await NSOpenPanel.filePicker(
                allowedContentTypes: [allowedContentType]
            )
            
            guard let file else {
                return
            }
            
            try await action(file)
        }, label: label)
    }
    
    // MARK: - Initializers
    
    /// Creates an `AsyncFileButton` with a custom label.
    ///
    /// - Parameters:
    ///   - allowedContentType: The file type allowed for selection, specified as a `UTType`.
    ///   - action: An asynchronous closure that processes the selected file.
    ///   - label: A view builder that provides the custom label for the button.
    public init(
        allowedContentType: UTType,
        action: @escaping (URL) async throws -> Void,
        label: @escaping () -> Label
    ) {
        self.allowedContentType = allowedContentType
        self.action = action
        self.label = label
    }
}

// MARK: - Convenience Initializers

public extension AsyncFileButton where Label == Text {
    
    /// Creates an `AsyncFileButton` with a `String` literal text label.
    ///
    /// - Parameters:
    ///   - title: A `String` literal representing the button text.
    ///   - allowedContentType: The file type allowed for selection, specified as a `UTType`.
    ///   - action: An asynchronous closure that processes the selected file.
    init(
        verbatim title: String,
        allowedContentType: UTType,
        action: @escaping (URL) async throws -> Void
    ) {
        self.init(
            allowedContentType: allowedContentType,
            action: action
        ) {
            Text(verbatim: title)
        }
    }
    
    /// Creates an `AsyncFileButton` with a `LocalizedStringKey` text label.
    ///
    /// - Parameters:
    ///   - titleKey: A `LocalizedStringKey` that will allow to display a localized button label.
    ///   - allowedContentType: The file type allowed for selection, specified as a `UTType`.
    ///   - action: An asynchronous closure that processes the selected file.
    init(
        _ titleKey: LocalizedStringKey,
        allowedContentType: UTType,
        action: @escaping (URL) async throws -> Void
    ) {
        self.init(
            allowedContentType: allowedContentType,
            action: action
        ) {
            Text(titleKey)
        }
    }
}

public extension AsyncFileButton where Label == SwiftUI.Label<Text, Image> {
    
    /// Creates an `AsyncFileButton` with a SwifUI `Label` using a `String` literal as title.
    ///
    /// - Parameters:
    ///   - title: A `String` literal representing the button text.
    ///   - systemImage: A String that represents the name of a SFSymbol (System Image),
    ///   - allowedContentType: The file type allowed for selection, specified as a `UTType`.
    ///   - action: An asynchronous closure that processes the selected file.
    init(
        verbatim title: String,
        systemImage: String,
        allowedContentType: UTType,
        action: @escaping (URL) async throws -> Void
    ) {
        self.init(
            allowedContentType: allowedContentType,
            action: action
        ) {
            Label(title, systemImage: systemImage)
        }
    }
    
    /// Creates an `AsyncFileButton` with a SwifUI `Label` using a `LocalizedStringKey` as title.
    ///
    /// - Parameters:
    ///   - titleKey: A `LocalizedStringKey` that will allow to display a localized button label.
    ///   - systemImage: A String that represents the name of a SFSymbol (System Image),
    ///   - allowedContentType: The file type allowed for selection, specified as a `UTType`.
    ///   - action: An asynchronous closure that processes the selected file.
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        allowedContentType: UTType,
        action: @escaping (URL) async throws -> Void
    ) {
        self.init(
            allowedContentType: allowedContentType,
            action: action
        ) {
            Label(titleKey, systemImage: systemImage)
        }
    }
}
#endif
