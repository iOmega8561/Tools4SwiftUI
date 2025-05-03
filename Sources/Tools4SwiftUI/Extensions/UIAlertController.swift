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
    
    /// Displays a critical error and immediately terminates the app.
    ///
    /// Presents an alert and exits the app after the user dismisses it.
    ///
    /// - Note: There's no `.critical` style in UIKit, so this uses a standard alert style.
    /// - Important: Will exit the app using `exit(EXIT_FAILURE)` after the alert is dismissed.
    ///
    /// - Parameters:
    ///   - error: The critical error to display.
    ///   - viewController: The view controller from which to present the alert.
    static func fatalError(_ error: Error, in viewController: UIViewController) -> Never {
        
        displayError(error, in: viewController); exit(EXIT_FAILURE)
    }
}
#endif
