//
//  Login.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 19.01.2024.
//

import Foundation
import SwiftUI

struct Login {
    let title: String
    let topDescription: String
    let textFieldTitles: [String]
    let suggestion: String
    let bottomDescription: [String]
    let icon: Image
}

extension Login {
    static let page = Login(title: "Login",
                            topDescription: "Enter your account credentials and start riding away",
                            textFieldTitles: ["Email Address", "Password"],
                            suggestion: "Forgot your password?",
                            bottomDescription: ["Don't have an account? You can ", "start with one here"],
                            icon: Image("MoveIcon"))
}
