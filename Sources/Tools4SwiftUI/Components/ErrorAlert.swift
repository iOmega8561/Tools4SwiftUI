//
//  ErrorAlert.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

/// A view modifier that displays an alert when an error is encountered.
///
/// Use `ErrorAlert` to present a SwiftUI alert whenever a bound `Error?` variable is non-`nil`.
/// The alert includes a dismiss button to clear the current error.
///
/// This modifier simplifies error handling and user feedback by binding an optional `Error`
/// to the alert's state.
///
/// ### Example Usage:
/// ```swift
/// struct ContentView: View {
///     @State private var error: Error?
///
///     var body: some View {
///         VStack {
///             Button("Trigger Error") {
///                 error = NSError(domain: "ExampleDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "An example error occurred."])
///             }
///         }
///         .modifier(ErrorAlert(currentError: $error))
///     }
/// }
/// ```
///
/// ### Features:
/// - Displays an alert with a localized error message whenever an error is bound to `currentError`.
/// - Provides a dismiss button to clear the error and dismiss the alert.
/// - Defaults to a generic error message if no localized description is available.
///
/// ### Parameters:
/// - `currentError`: A binding to an optional `Error`. When the value is non-`nil`, an alert is presented.
///
/// ### Behavior:
/// - The alert's title is defined as a localized string, `"alert-title-error"`.
/// - The dismiss button's label is a localized string, `"alert-button-dismiss"`.
/// - If the error does not have a localized description, a default message, `"alert-message-default"`, is shown.
///
/// ### Notes:
/// - This modifier is designed to work seamlessly with `@State` or `@Binding` variables holding optional `Error` values.
///
/// ### Supported Platforms:
/// - **iOS**
/// - **macOS**
/// - **tvOS**
/// - **watchOS**
///
/// ### See Also:
/// - `ViewModifier`
/// - `Binding`
/// - `Error`
public struct ErrorAlert: ViewModifier {
    
    /// A binding to the current error to be displayed in the alert.
    @Binding private var currentError: Error?
    
    public func body(content: Content) -> some View {
        content
            .alert(String.module("alert-title-error"),
                   isPresented: .constant(currentError != nil)) {
                
                Button(String.module("alert-button-dismiss")) {
                    currentError = nil
                }
            } message: {
                
                Text(currentError?.localizedDescription ??
                    .module("alert-message-default"))
            }
    }
    
    /// Initializes the `ErrorAlert` modifier with a binding to an error.
    ///
    /// - Parameter currentError: A binding to an optional `Error` variable that triggers the alert when non-`nil`.
    public init(currentError: Binding<Error?>) {
        _currentError = currentError
    }
}
