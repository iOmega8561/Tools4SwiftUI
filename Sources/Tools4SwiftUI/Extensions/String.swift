//
//  String.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 12/01/25.
//

import Foundation

extension String {
    
    static func module(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
}
