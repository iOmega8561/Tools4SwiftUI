//
//  AsyncButton.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 12/05/24.
//

import SwiftUI

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
    
    /// The role of the button, defining its semantic meaning.
    ///
    /// This can be used to specify roles like `.destructive` or `.cancel`.
    private let role: ButtonRole?
    
    /// A Boolean value that determines whether the button should be disabled while the asynchronous task is running.
    ///
    /// When set to `true`, the button becomes unresponsive and visually indicates it is disabled.
    private let disableWhenRunning: Bool
    
    /// The asynchronous action to be executed when the button is tapped.
    ///
    /// This closure is executed with `.userInitiated` priority and handles potential errors by displaying them
    /// through `Tools4SwiftUI.displayError`.
    private let action: () async throws -> Void
    
    /// The content of the button, provided as a SwiftUI `View`.
    ///
    /// This closure defines the button's visual appearance, such as a text label or a custom view.
    @ViewBuilder private let label: () -> Label

    /// Tracks whether the button is currently disabled.
    ///
    /// This state variable is updated when the task starts and resets when it completes.
    @State private var isDisabled = false
    
    /// Tracks whether the progress view is visible.
    ///
    /// This state variable determines whether the progress indicator should be displayed while the task is running.
    @State private var showProgressView = false

    /// The body of the `AsyncButton`, defining its appearance and behavior.
    ///
    /// This view includes:
    /// - A button that triggers the asynchronous `action`.
    /// - Dynamic handling of the `disabled` state based on the progress of the task.
    /// - An overlay with a `ProgressView` to indicate task execution.
    public var body: some View {
        Button(role: role, action: buttonHandler) {
            label()
                .opacity(showProgressView ? 0 : 1)
                .overlay {
                    
                    ProgressView()
                    
                        .opacity(showProgressView ? 1 : 0)
                    
                        .scaleEffect(
                            CGSize(width: 0.5, height: 0.5),
                            anchor: .center
                        )
                }
        }
        .disabled(isDisabled)
    }
    
    /// Handles the button's action by managing its state and executing the asynchronous task.
    ///
    /// This method:
    /// - Disables the button if `disableWhenRunning` is `true`.
    /// - Displays a progress view while the task is running.
    /// - Resets the button's state after the task completes or fails.
    private func buttonHandler() {
        isDisabled = disableWhenRunning
    
        Task(priority: .userInitiated) { @MainActor in
            showProgressView = disableWhenRunning

            do {
                try await action()
                
            } catch { Tools4SwiftUI.displayError(error) }

            isDisabled = false; showProgressView = false
        }
    }
    
    /// AsyncButton initializer
    ///
    /// - Parameters:
    ///   - role: The role of the button.
    ///   - disableWhenRunning: A boolean that dictates is the button should be disabled while the async task is running.
    ///   - action: A closure to be executed asynchronously.
    ///   - label: A line of text that will be displayed as the button label.
    public init(
        role: ButtonRole? = nil ,
        disableWhenRunning: Bool = true,
        action: @escaping () async throws -> Void,
        label: @escaping () -> Label
    ) {
        self.role = role
        self.disableWhenRunning = disableWhenRunning
        self.action = action
        self.label = label
    }
}

extension AsyncButton where Label == Text {
    
    /// AsyncButton convenience initializer, Useful to create a new button using a simple string as label.
    ///
    /// - Parameters:
    ///   - label: A line of text that will be displayed as the button label.
    ///   - role: The role of the button.
    ///   - disableWhenRunning: A boolean that dictates is the button should be disabled while the async task is running.
    ///   - action: A closure to be executed asynchronously.
    public init(
        _ label: String,
        role: ButtonRole? = nil,
        disableWhenRunning: Bool = true,
        action: @escaping () async throws -> Void
    ) {
        
        self.init(
            role: role,
            disableWhenRunning: disableWhenRunning,
            action: action
        ) {
            Text(LocalizedStringKey(label))
        }
    }
}
