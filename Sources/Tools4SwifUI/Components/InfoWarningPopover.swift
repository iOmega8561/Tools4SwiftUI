//
//  InfoWarningPopover.swift
//  Tools4SwifUI
//
//  Created by Giuseppe Rocco on 16/11/24.
//

import SwiftUI

public struct InfoWarningPopover: View {
    
    private let textWhenNormal: String
    
    private let textWhenWarning: String
    
    @Binding private var warningIsShown: Bool
    
    @State private var popoverIsShown: Bool = false
    
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
    
    public init(
        textWhenNormal: String,
        textWhenWarning: String,
        warningIsShown: Binding<Bool>
    ) {
        self.textWhenNormal = textWhenNormal
        self.textWhenWarning = textWhenWarning
        _warningIsShown = warningIsShown
    }
}
