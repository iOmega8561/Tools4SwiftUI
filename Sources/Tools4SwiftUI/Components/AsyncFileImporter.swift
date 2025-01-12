//
//  AsyncFileImporter.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

import UniformTypeIdentifiers

/// A view modifier that enables asynchronous file importing in a SwiftUI view.
///
/// `AsyncFileImporter` provides a convenient way to present a file importer dialog, handle the selection of files, and execute an asynchronous task
/// upon file selection. The modifier supports both single and multiple file selection, allows specifying allowed content types, and handles
/// security-scoped resource access.
///
/// This component is compatible with all SwiftUI-supported platforms and includes error handling capabilities for non-macOS platforms.
///
/// ### Features:
/// - Presents a file importer dialog when bound to a `Bool` state.
/// - Supports asynchronous operations on selected files.
/// - Manages security-scoped resource access for sandboxed applications.
/// - Handles errors gracefully with built-in error alert support (on non-macOS platforms).
///
/// ### Example Usage:
/// ```swift
/// struct ContentView: View {
///     @State private var isFileImporterPresented = false
///
///     var body: some View {
///         VStack {
///             Button("Import Files") {
///                 isFileImporterPresented = true
///             }
///         }
///         .modifier(AsyncFileImporter(
///             isPresented: $isFileImporterPresented,
///             allowedContentType: .plainText,
///             allowsMultipleSelection: true
///         ) { files in
///             for file in files {
///                 print("Selected file: \(file.path)")
///             }
///         })
///     }
/// }
/// ```
///
/// ### Parameters:
/// - `isPresented`: A binding to a `Bool` that determines when the file importer is presented.
/// - `allowedContentTypes`: An array of `UTType` values that specify the file types the importer allows.
/// - `allowsMultipleSelection`: A Boolean value that determines whether multiple files can be selected. Defaults to `false`.
/// - `completionHandler`: An asynchronous closure that processes the selected files. The closure receives an array of `URL` objects representing the selected files.
///
/// ### Error Handling:
/// - On macOS, errors are displayed using `NSAlert`.
/// - On other platforms, errors are displayed using the `.errorAlert` modifier.
///
/// ### Platform Notes:
/// - On macOS, the `NSAlert` is used to present errors.
/// - On non-macOS platforms, the `currentError` state variable is used in conjunction with an `.errorAlert` modifier to handle errors.
///
/// ### Supported Platforms:
/// - **iOS**
/// - **macOS**
/// - **tvOS**
/// - **watchOS**
///
/// ### See Also:
/// - `fileImporter`
/// - `UTType`
/// - `ErrorAlert`
public struct AsyncFileImporter: ViewModifier {
    
    // MARK: - Properties

    /// The allowed content types for the file importer.
    private let allowedContentTypes: [UTType]
    
    /// The closure that handles the selected files asynchronously.
    private let completionHandler: ([URL]) async throws -> Void
    
    /// A Boolean value indicating whether multiple file selection is allowed.
    private let allowsMultipleSelection: Bool
    
    /// A binding that determines when the file importer is presented.
    @Binding private var isPresented: Bool
    
    /// A state that tracks whether the asynchronous task is executing.
    @State private var isExecuting: Bool = false
    
    #if !os(macOS)
    /// Tracks whether an error has been encountered (non-macOS platforms only).
    @State private var currentError: Error? = nil
    #endif

    // MARK: - Body

    /// Modifies the view to include a file importer and handle file selection asynchronously.
    ///
    /// - Parameter content: The content view to modify.
    /// - Returns: A modified view with file importer functionality.
    public func body(content: Content) -> some View {
        content
            .disabled(isExecuting)
            .fileImporter(
                isPresented: $isPresented,
                allowedContentTypes: allowedContentTypes,
                allowsMultipleSelection: allowsMultipleSelection
            ) { result in
                
                switch result {
                case .success(let files):
                    isExecuting = true
                    
                    Task(priority: .userInitiated) { @MainActor in
                        
                        files.forEach { file in
                            _ = file.startAccessingSecurityScopedResource()
                        }
                        
                        do {
                            try await completionHandler(files)
                        } catch {
                            #if !os(macOS)
                            currentError = error
                            #else
                            NSAlert.displayError(error)
                            #endif
                        }
                        
                        files.forEach { file in
                            file.stopAccessingSecurityScopedResource()
                        }
                        
                        isExecuting = false
                    }
                case .failure:
                    return
                }
            }
            #if !os(macOS)
            .errorAlert(currentError: $currentError)
            #endif
    }
    
    // MARK: - Initializers

    /// Initializes the file importer modifier with multiple allowed content types.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a `Bool` that determines when the file importer is presented.
    ///   - allowedContentTypes: An array of `UTType` values representing the allowed content types for selection.
    ///   - allowsMultipleSelection: A Boolean value indicating whether multiple file selection is allowed. Defaults to `false`.
    ///   - completionHandler: An asynchronous closure that processes the selected files.
    public init(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        allowsMultipleSelection: Bool = false,
        completionHandler: @escaping ([URL]) async throws -> Void
    ) {
        self.allowedContentTypes = allowedContentTypes
        self.completionHandler = completionHandler
        self.allowsMultipleSelection = allowsMultipleSelection
        _isPresented = isPresented
    }
}
