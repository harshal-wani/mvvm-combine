//
//  UIAlertController+WG.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

private var window: UIWindow!

extension UIAlertController {

    /// Create UIAlertController
    /// - Parameter title: Title
    /// - Parameter message: Message
    /// - Parameter cancelButton: Cancel button
    /// - Parameter otherButtons: Array of other buttons
    /// - Parameter tapHandler: Send tap handler
    class func showAlert(title: String,
                         message: String,
                         cancelButton: String?,
                         otherButtons: [String]? = nil,
                         tapHandler: ((String) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let title = cancelButton {
            alert.addAction(UIAlertAction(title: title, style: .cancel, handler: { _ in
                if let handler = tapHandler {
                    handler(title)
                }
            }))
        }

        for buttonTitle in otherButtons ?? [] {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                if let handler = tapHandler {
                    handler(buttonTitle)
                }
            }))
        }
        alert.present(animated: true, completion: nil)
    }

    /// Present UIAlertController on windowLevel
    /// - Parameter animated: Flag to show with animate
    /// - Parameter completion: Completion handler
    func present(animated: Bool,
                 completion: (() -> Void)?) {

        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: true, completion: nil)
        }
    }

}
