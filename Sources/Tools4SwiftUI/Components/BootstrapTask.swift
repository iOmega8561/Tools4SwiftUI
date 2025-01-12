//
//  BootstrapTask.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 11/11/24.
//

import SwiftUI

/// `BootstrapTask` is a view modifier that runs an asynchronous task only once per view lifecycle.
///
/// This modifier provides a way to execute an asynchronous task when the view appears, ensuring
/// the task only runs once by tracking its completion state. This is useful for initialization
/// tasks that should only be performed once, such as loading data or setting up necessary resources.
///
/// - Note: This modifier leverages `@State` with an `Observable` object (`StateHolder`) to
/// track the task's completion state, ensuring it is only executed once.
public struct BootstrapTask: ViewModifier {
    
    /// A private class to hold the task’s completion state.
    ///
    /// `StateHolder` is a class that tracks whether the task has been completed.
    /// It doesn't need to be `Observable`, since SwiftUI will not update the view when the `isDone`
    /// property changes. In this context, it's primarily used to prevent re-execution.
    ///
    /// - Properties:
    ///   - `isDone`: A private(set) Boolean that tracks whether the task has been completed.
    private class StateManager {
        
        /// A Boolean indicating whether the task has already completed.
        ///
        /// Once `isDone` is set to `true`, the task will not run again in this view's lifecycle.
        private(set) var isDone: Bool = false
        
        /// Marks the task as completed by setting `isDone` to `true`.
        func setDone() { isDone = true }
    }
    
    /// The asynchronous task to be executed by the modifier.
    ///
    /// `handler` is an asynchronous throwing closure that will be executed when the view appears.
    /// If the task completes successfully, no further actions are taken. If an error occurs, it
    /// is handled by displaying an alert through `TesseractError`.
    private let handler: () async throws -> Void
    
    /// An instance of `StateManager` to track whether the task has already run.
    ///
    /// Using `@State` ensures that `stateManager` is unique to this view instance, and SwiftUI
    /// retains its state across re-renders. By tracking the task's completion state, `stateHolder`
    /// helps ensure the task only executes once.
    @State private var stateManager: StateManager = .init()
    
    #if !os(macOS)
    /// Tracks whether an error has been encountered
    ///
    /// This state variable determines whether the async task has encountered an error and stores it until dismission
    /// - Note: This is available only on platforms where `AppKit` is not available (everything but macOS)
    @State private var currentError: Error? = nil
    #endif
    
    /// The body of the view modifier, which applies the `task` modifier to execute the asynchronous handler.
    ///
    /// The `task` modifier initiates the asynchronous task with a `.userInitiated` priority. Inside the task,
    /// a check is performed to ensure that the task has not already completed by verifying `isDone` in `stateHolder`.
    /// If the task has not run yet:
    /// - `stateHolder.setDone()` is called to mark it as completed.
    /// - The task is then executed.
    /// - If an error occurs, it is displayed to the user via `TesseractError`.
    ///
    /// - Parameters:
    ///   - content: The view content to which this modifier is applied.
    /// - Returns: A view with the asynchronous task applied, which runs once upon view appearance.
    public func body(content: Content) -> some View {
        content
            .task(priority: .userInitiated) { @MainActor in
                
                guard !stateManager.isDone else { return }
                
                stateManager.setDone()
                
                do {
                    try await handler()
                    
                } catch {
                    #if !os(macOS)
                    currentError = error
                    #else
                    NSAlert.displayError(error)
                    #endif
                }
            }
        
            #if !os(macOS)
            .errorAlert(currentError: $currentError)
            #endif
    }
    
    public init(handler: @escaping () async throws -> Void) {
        self.handler = handler
    }
}
