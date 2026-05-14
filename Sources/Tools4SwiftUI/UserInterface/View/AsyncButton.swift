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
//  AsyncButton.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/05/24.
//

/// `AsyncButton` is a customizable button that executes an asynchronous task when tapped.
///
/// This view combines the functionality of a standard SwiftUI button with the ability to handle
/// asynchronous tasks. While the task is running, the button can optionally disable itself and
/// display a progress indicator. It provides a clean way to manage state during asynchronous operations.
///
/// - Note:
///   - The button supports customizing its label, role, and disabling behavior.
///   - It leverages structured concurrency with Swift's `Task` and `@MainActor` to ensure safe UI updates.
///   - If an error occurs during the asynchronous operation, it is displayed using `Tools4SwiftUI.displayError`.
///
/// - Generics:
///   - `Label`: The view type used for the button's label.
public struct AsyncButton<Label: View>: View {
    
    // MARK: - Properties
    
    /// The role of the button, defining its semantic meaning.
    ///
    /// This can be used to specify roles like `.destructive` or `.cancel`.
    private let role: ButtonRole?
    
    /// A Boolean value that determines whether the button should allow to cancel asynchronous task.
    ///
    /// When set to `false`, the button becomes unresponsive and visually indicates it is disabled.
    private let allowsCancel: Bool
    
    /// The asynchronous action to be executed when the button is tapped.
    ///
    /// This closure is executed with `.userInitiated` priority and handles potential errors by displaying them
    /// through `Tools4SwiftUI.displayError`.
    private let action: () async throws -> Void
    
    /// The content of the button, provided as a SwiftUI `View`.
    ///
    /// This closure defines the button's visual appearance, such as a text label or a custom view.
    @ViewBuilder private let label: () -> Label
    
    /// Tracks the async task
    ///
    /// This state variable determines whether the progress indicator should be displayed while the task is running.
    /// It is also used to determine whether to display the *stop.fill* symbol during execution
    @State private var currentTask: Task<Void, Error>? = nil

    #if !os(macOS)
    /// Tracks whether an error has been encountered
    ///
    /// This state variable determines whether the async task has encountered an error and stores it until dismission
    /// - Note: This is available only on platforms where `AppKit` is not available (everything but macOS)
    @State private var currentError: Error? = nil
    #endif
    
    // MARK: - Body
    
    /// The body of the `AsyncButton`, defining its appearance and behavior.
    ///
    /// This view includes:
    /// - A button that triggers the asynchronous `action`.
    /// - Dynamic handling of the `disabled` state based on the progress of the task.
    /// - An overlay with a `ProgressView` to indicate task execution.
    public var body: some View {
        Button(
            role: currentTask != nil && allowsCancel ? .cancel : role,
            action: buttonHandler
        ) {
            label()
                .opacity(currentTask != nil ? 0 : 1)
                .overlay {
                    ProgressView()
                        .opacity(currentTask != nil && !allowsCancel ? 1 : 0)
                        .scaleEffect(
                            CGSize(width: 0.5, height: 0.5),
                            anchor: .center
                        )
                    Image(systemName: "stop.fill")
                        .imageScale(.medium)
                        .opacity(currentTask != nil && allowsCancel ? 1 : 0)
                }
        }
        .disabled(currentTask != nil && !allowsCancel)
        #if !os(macOS)
        .errorAlert(currentError: $currentError)
        #endif
    }
    
    // MARK: - Button handler function
    
    /// Handles the button's action by managing its state and executing the asynchronous task.
    ///
    /// This method:
    /// - Disables the button if `disableWhenRunning` is `true`.
    /// - Displays a progress view while the task is running.
    /// - Resets the button's state after the task completes or fails.
    ///
    /// - Note: Where `AppKit` is not available (everything but macOS), instead of using `Tools4SwiftUI.displayError`,
    /// The state variable `currentError` is used since it allows to trigger a native SwiftUI alert on the async button.
    private func buttonHandler() {
        if let currentTask {
            return currentTask.cancel()
        }
        
        currentTask = Task(priority: .userInitiated) { @MainActor in
            defer {
                currentTask = nil
            }
            
            do {
                try await action()
                
            } catch {
                #if !os(macOS)
                currentError = error
                #else
                NSAlert.displayError(error)
                #endif
            }
        }
    }
    
    // MARK: - Initializers
    
    /// AsyncButton initializer
    ///
    /// - Parameters:
    ///   - role: The role of the button.
    ///   - allowsCancel: A boolean that dictates wether the button should allow cancelling the async task.
    ///   - action: A closure to be executed asynchronously.
    ///   - label: A line of text that will be displayed as the button label.
    public init(
        role: ButtonRole? = nil ,
        allowsCancel: Bool = false,
        action: @escaping () async throws -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.role = role
        self.allowsCancel = allowsCancel
        self.action = action
        self.label = label
    }
}

// MARK: - Convenience Initializers

extension AsyncButton where Label == Text {
    
    /// AsyncButton convenience initializer, Useful to create a new button using a simple `String` literal as label text.
    ///
    /// - Parameters:
    ///   - title: A `String` literal that will be displayed as the button label.
    ///   - role: The role of the button.
    ///   - allowsCancel: A boolean that dictates wether the button should allow cancelling the async task.
    ///   - action: A closure to be executed asynchronously.
    public init(
        verbatim title: String,
        role: ButtonRole? = nil,
        allowsCancel: Bool = false,
        action: @escaping () async throws -> Void
    ) {
        
        self.init(
            role: role,
            allowsCancel: allowsCancel,
            action: action
        ) {
            Text(verbatim: title)
        }
    }
    
    /// AsyncButton convenience initializer, Useful to create a new button using a `LocalizedStringKey`
    ///
    /// - Parameters:
    ///   - titleKey: A `LocalizedStringKey` that will allow to display a localized button label.
    ///   - role: The role of the button.
    ///   - allowsCancel: A boolean that dictates wether the button should allow cancelling the async task.
    ///   - action: A closure to be executed asynchronously.
    public init(
        _ titleKey: LocalizedStringKey,
        role: ButtonRole? = nil,
        allowsCancel: Bool = false,
        action: @escaping () async throws -> Void
    ) {
        
        self.init(
            role: role,
            allowsCancel: allowsCancel,
            action: action
        ) {
            Text(titleKey)
        }
    }
}

extension AsyncButton where Label == SwiftUI.Label<Text, Image> {
    
    /// AsyncButton convenience initializer, Useful to create a new button mimicing the native `Label` behaviour
    ///
    /// - Parameters:
    ///   - title: A `String` literal that will be displayed as the button label.
    ///   - systemImage: A `String` literal that represents the name of a SFSymbol (System Image),
    ///   - role: The role of the button.
    ///   - allowsCancel: A boolean that dictates wether the button should allow cancelling the async task.
    ///   - action: A closure to be executed asynchronously.
    public init(
        verbatim title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        allowsCancel: Bool = false,
        action: @escaping () async throws -> Void
    ) {
        
        self.init(
            role: role,
            allowsCancel: allowsCancel,
            action: action
        ) {
            Label(title, systemImage: systemImage)
        }
    }
    
    /// AsyncButton convenience initializer, Useful to create a new button mimicing the native `Label` behaviour
    ///
    /// - Parameters:
    ///   - titleKey: A `LocalizedStringKey` that will allow to display a localized button label.
    ///   - systemImage: A `String` that represents the name of a SFSymbol (System Image),
    ///   - role: The role of the button.
    ///   - allowsCancel: A boolean that dictates wether the button should allow cancelling the async task.
    ///   - action: A closure to be executed asynchronously.
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        role: ButtonRole? = nil,
        allowsCancel: Bool = false,
        action: @escaping () async throws -> Void
    ) {
        
        self.init(
            role: role,
            allowsCancel: allowsCancel,
            action: action
        ) {
            Label(titleKey, systemImage: systemImage)
        }
    }
}
