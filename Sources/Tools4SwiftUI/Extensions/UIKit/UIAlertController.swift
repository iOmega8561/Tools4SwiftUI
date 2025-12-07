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
//  UIAlertController.swift
//  Tools4SwiftUI
//
//  Created by Giuseppe Rocco on 03/05/25.
//

#if canImport(UIKit)
import UIKit

public extension UIAlertController {
    
    /// Displays an error message to the user using a `UIAlertController`.
    ///
    /// Presents a modal alert with the localized description of the error and an "OK" button to dismiss it.
    ///
    /// - Parameters:
    ///   - error: The `Error` to present to the user.
    ///   - title: Optional title for the alert. Defaults to a localized "Error" string.
    ///   - viewController: The view controller from which to present the alert.
    static func displayError(_ error: Error, in viewController: UIViewController) {
        let alert = UIAlertController(
            title: .module("alert-title-error"),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(
            title: .module("alert-button-dismiss"),
            style: .default,
            handler: nil
        ))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
#endif
