//
//  Color.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 15/01/25.
//

public extension Color {
    
    #if os(macOS)
    /// A custom color that mimics the `systemGroupedBackground` color on macOS.
    ///
    /// This color is defined in the asset catalog under the namespace `macOS/systemGroupedBackground`.
    /// It is intended to provide a consistent background appearance across macOS applications, similar
    /// to the `systemGroupedBackground` color available on iOS.
    ///
    /// ### Features:
    /// - Fully supports **light mode** and **dark mode**, providing the appropriate color variant for each appearance.
    /// - Ensures visual consistency and compatibility with system themes on macOS.
    ///
    /// ### Usage:
    /// Add a color set in your asset catalog with the following path:
    /// `macOS/systemGroupedBackground`
    ///
    /// Configure the color set to include variants for light and dark mode to ensure proper appearance.
    ///
    /// Example:
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Hello, macOS!")
    ///             .padding()
    ///             .background(Color.systemGroupedBackground)
    ///     }
    /// }
    /// ```
    ///
    /// Ensure that the color set is included in the appropriate targets and configured correctly.
    static var systemGroupedBackground: Color {
        .init("macOS/systemGroupedBackground", bundle: .module)
    }
    #endif
}
