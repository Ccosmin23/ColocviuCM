//
//  HandlingMessages.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 03.09.2021.
//

import Foundation
import UIKit
import SwiftMessages


public var buttonTapHandler: ((_ button: UIButton) -> Void)?

class ErrorDisplay {
    
    static func show(error: String?) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: nil, body: error, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: buttonTapHandler)
        view.button?.backgroundColor = #colorLiteral(red: 0.9778422713, green: 0.2601780593, blue: 0.1852073371, alpha: 1)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(view: view)
    }
    
    static func errorDisplayStatus(dictionary: [String: Any?]?, message: String?) {
        if let status = dictionary?["status"] as? String {
            if status != "success" {
                if let message = message {
                    ErrorDisplay.show(error: message)
                } else {
                    ErrorDisplay.show(error: status)
                }
            }
        }
    }
}


