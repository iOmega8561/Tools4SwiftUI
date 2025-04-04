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
//  InformativePopover.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 16/11/24.
//

/// `InformativePopover` is a reusable popover component that displays informational or warning messages.
///
/// This view provides a button that toggles a popover when tapped. The button dynamically adjusts its icon and style
/// based on whether a warning state is active. The popover displays a localized message, which varies depending on
/// the warning state.
///
/// - Note:
///   - The popover text is determined by the `warningIsShown` binding, allowing dynamic updates.
///   - The button icon changes between an informational icon (`info.circle`) and a warning icon (`exclamationmark.triangle`).
///
/// - Features:
///   - Dynamic content based on the warning state.
///   - Visual distinction between normal and warning states using color and icon changes.
///   - Localized messages for both states.
public struct InformativePopover: View {
    
    /// The text to display in the popover when there is no warning.
    ///
    /// This text is localized using `LocalizedStringKey` for compatibility with SwiftUI's localization system.
    private let textWhenNormal: String
    
    /// The text to display in the popover when a warning is active.
    ///
    /// This text is also localized and is shown when `warningIsShown` is `true`.
    private let textWhenWarning: String
    
    /// A boolean that determines whether the warning state is active.
    ///
    /// When `warningIsShown` is `true`, the button displays a warning icon, and the popover shows the warning text.
    private let warningIsShown: Bool
    
    /// A state variable that tracks whether the popover is currently shown.
    ///
    /// This variable toggles when the button is tapped, showing or hiding the popover.
    @State private var popoverIsShown: Bool = false
    
    /// The body of the `InformativePopover`, defining its layout and behavior.
    ///
    /// The view includes:
    /// - A button with a dynamic icon (`info.circle` or `exclamationmark.triangle`) and color styling based on `warningIsShown`.
    /// - A popover that displays a localized message when the button is tapped.
    public var body: some View {
        Button { popoverIsShown.toggle() } label: {
            
            Image(systemName: warningIsShown ? "exclamationmark.triangle":"info.circle")
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: 18.5, height: 18.5)
                .foregroundStyle(warningIsShown ? .yellow:.secondary)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $popoverIsShown) {
            
            Text(LocalizedStringKey(warningIsShown ? textWhenWarning:textWhenNormal))
                .multilineTextAlignment(.leading)
                .frame(width: 300)
                .padding()
        }
    }
    
    /// Initializes an `InformativePopover` with the given parameters. Two strings for Normal and Warning are
    /// required so that it's not necessary to build if statements or ternary operators in the parent view.
    ///
    /// - Parameters:
    ///   - textWhenNormal: The text to display in the popover when there is no warning.
    ///   - textWhenWarning: The text to display in the popover when a warning is active.
    ///   - warningIsShown: A binding that determines whether the warning state is active.
    public init(
        textWhenNormal: String,
        textWhenWarning: String,
        warningIsShown: Bool
    ) {
        self.textWhenNormal = textWhenNormal
        self.textWhenWarning = textWhenWarning
        self.warningIsShown = warningIsShown
    }
    
    /// A convenience initializer that requires only one text. Warning or Normal will be determined by the boolean.
    /// This init should be used when only one text is available or ternary operators are used to pass the correct string.
    ///
    /// - Parameters:
    ///   - text: The text to display in the popover when there is no warning.
    ///   - warningIsShown: A binding that determines whether the warning state is active.
    public init(
        text: String,
        warningIsShown: Bool
    ) {
        self.warningIsShown = warningIsShown
        
        if warningIsShown {
            textWhenWarning = text; textWhenNormal = ""
        
        } else { textWhenNormal = text; textWhenWarning = "" }
    }
}
