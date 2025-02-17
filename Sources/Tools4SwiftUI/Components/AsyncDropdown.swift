//
//  AsyncDropdown.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 17/02/25.
//

/// A dropdown menu button that supports asynchronous primary actions.
///
/// `AsyncDropdown` provides a menu with additional options while also supporting a **primary action**
/// that runs asynchronously when the button is clicked. It also provides built-in handling for UI
/// updates, error management, and progress indicators.
///
/// This component supports both **macOS** and other platforms, with platform-specific error handling,
/// although it has been designed targeting macOS first.
public struct AsyncDropdown<Content: View>: View {
    
    // MARK: - Properties
    
    /// A Boolean value that determines whether the button should be disabled while the asynchronous task is running.
    ///
    /// When set to `true`, the button is temporarily disabled to prevent multiple executions
    /// while the asynchronous task is in progress.
    private let disableWhenRunning: Bool

    /// A closure that returns the button's title text.
    ///
    /// This allows flexible usage, supporting both localized strings and verbatim text.
    private let text: () -> Text

    /// A closure that returns the button's icon image.
    ///
    /// This supports both SF Symbols and custom images.
    private let image: () -> Image

    /// A closure that provides the content of the dropdown menu.
    ///
    /// This defines the additional options available when the dropdown menu is opened.
    private let content: () -> Content

    /// The primary asynchronous action executed when the button is clicked.
    ///
    /// This closure runs when the user clicks the button. It supports asynchronous execution and
    /// allows for error handling.
    private let action: () async throws -> Void

    /// Tracks whether the button is currently disabled.
    ///
    /// This state variable is updated when the task starts and resets when it completes.
    @State private var isDisabled = false

    /// Tracks whether the progress view (loading indicator) is visible.
    ///
    /// This determines whether a loading spinner should be displayed while the task is running.
    @State private var showProgressView = false

    #if !os(macOS)
    /// Tracks whether an error has been encountered during execution.
    ///
    /// On non-macOS platforms, this state variable temporarily stores an error until dismissed.
    @State private var currentError: Error? = nil
    #endif

    /// Tracks whether the button is currently being hovered over.
    ///
    /// This state is used to display a small dropdown indicator when the button is hovered.
    @State private var isHovered: Bool = false
    
    // MARK: - View Body
    
    public var body: some View {
        
       
        Menu(content: content) {
            
            ZStack(alignment: .bottomTrailing) {
                
                Label { text() } icon: {
                    image()
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .frame(idealWidth: 15, idealHeight: 15)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                
                if isHovered {
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 8, weight: .semibold))
                        .offset(x: -2, y: -2)
                }
            }
            .background(isHovered ? .gray.opacity(0.1) : .clear)
            .clipShape(.rect(cornerRadius: 7))
            .opacity(showProgressView ? 0 : 1)
            .overlay {
                ProgressView()
                    .opacity(showProgressView ? 1 : 0)
                    .scaleEffect(
                        CGSize(width: 0.5, height: 0.5),
                        anchor: .center
                    )
            }
            
        } primaryAction: { buttonHandler() }
        
            .menuStyle(.button)
            .buttonStyle(.plain)
            .onHover { isHovered = $0 }
            .disabled(isDisabled)
        
            #if !os(macOS)
            .errorAlert(currentError: $currentError)
            #endif
    }
    
    // MARK: - Private Methods
        
    /// Handles the primary button action by executing the provided asynchronous task.
    ///
    /// - The button is temporarily disabled if `disableWhenRunning` is enabled.
    /// - The progress view is displayed while the task is executing.
    /// - If an error occurs, it is handled appropriately depending on the platform.
    private func buttonHandler() {
        isDisabled = disableWhenRunning

        Task(priority: .userInitiated) { @MainActor in
            showProgressView = disableWhenRunning

            do {
                try await action()
            } catch {
                #if !os(macOS)
                currentError = error // Store error for alert display on non-macOS platforms
                #else
                NSAlert.displayError(error) // Use AppKit alert for macOS
                #endif
            }

            // Reset button state after task completes
            isDisabled = false
            showProgressView = false
        }
    }

    // MARK: - Initializers
    
    /// Creates an `AsyncDropdown` with a system image.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the button's title.
    ///   - systemImage: The name of the SF Symbol to use as an icon.
    ///   - disableWhenRunning: Whether to disable the button while executing the action.
    ///   - action: The asynchronous action to be executed.
    ///   - content: The content of the dropdown menu.
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        disableWhenRunning: Bool = true,
        action: @escaping () async throws -> Void,
        content: @escaping () -> Content
    ) {
        self.disableWhenRunning = disableWhenRunning
        self.text = { Text(titleKey) }
        self.image = { Image(systemName: systemImage) }
        self.content = content
        self.action = action
    }
    
    /// Creates an `AsyncDropdown` with a custom image.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the button's title.
    ///   - image: A custom `Image` to use as an icon.
    ///   - disableWhenRunning: Whether to disable the button while executing the action.
    ///   - action: The asynchronous action to be executed.
    ///   - content: The content of the dropdown menu.
    public init(
        _ titleKey: LocalizedStringKey,
        image: Image,
        disableWhenRunning: Bool = true,
        action: @escaping () async throws -> Void,
        content: @escaping () -> Content
    ) {
        self.disableWhenRunning = disableWhenRunning
        self.text = { Text(titleKey) }
        self.image = { image }
        self.content = content
        self.action = action
    }
    
    /// Creates an `AsyncDropdown` with a system image using a verbatim string for the title.
    ///
    /// - Parameters:
    ///   - verbatim: The title text for the button (non-localized).
    ///   - systemImage: The name of the SF Symbol to use as an icon.
    ///   - disableWhenRunning: Whether to disable the button while executing the action.
    ///   - action: The asynchronous action to be executed.
    ///   - content: The content of the dropdown menu.
    public init(
        verbatim: String,
        systemImage: String,
        disableWhenRunning: Bool = true,
        action: @escaping () async throws -> Void,
        content: @escaping () -> Content
    ) {
        self.disableWhenRunning = disableWhenRunning
        self.text = { Text(verbatim: verbatim) }
        self.image = { Image(systemName: systemImage) }
        self.content = content
        self.action = action
    }
    
    /// Creates an `AsyncDropdown` with a custom image using a verbatim string for the title.
    ///
    /// - Parameters:
    ///   - verbatim: The title text for the button (non-localized).
    ///   - image: A custom `Image` to use as an icon.
    ///   - disableWhenRunning: Whether to disable the button while executing the action.
    ///   - action: The asynchronous action to be executed.
    ///   - content: The content of the dropdown menu.
    public init(
        verbatim: String,
        image: Image,
        disableWhenRunning: Bool = true,
        action: @escaping () async throws -> Void,
        content: @escaping () -> Content
    ) {
        self.disableWhenRunning = disableWhenRunning
        self.text = { Text(verbatim: verbatim) }
        self.image = { image }
        self.content = content
        self.action = action
    }
}
