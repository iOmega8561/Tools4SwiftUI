//
//  AsyncButton.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 12/05/24.
//

import SwiftUI

/// A simple Asynchronous button view
///
/// @brief
///    This button starts an asynchronous task and handles disabling itself.
///    It will also display a progress view during task execution
///
public struct AsyncButton<Label: View>: View {
    let role: ButtonRole?
    let disableWhenRunning: Bool
    let action: () async throws -> Void
    @ViewBuilder let label: () -> Label

    @State private var isDisabled = false
    @State private var showProgressView = false

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
    
    private func buttonHandler() {
        isDisabled = disableWhenRunning
    
        Task(priority: .userInitiated) { @MainActor in
            showProgressView = disableWhenRunning

            do {
                try await action()
                
            } catch { NSAlert.displayError(error) }

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
