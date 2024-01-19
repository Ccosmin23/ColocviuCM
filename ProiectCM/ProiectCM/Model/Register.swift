//
//  Register.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 19.01.2024.
//

import Foundation
import SwiftUI

struct Register {
    let background: Image
    let credentials: [String]
    let title: String
    let topDescription: String
    let termsDescription: [String]
    let bottomDescription: [String]
    let icon: Image
}

extension Register {
    static let page = Register(background: Image("usualBackground"),
                                     credentials: ["Email Address", "Username", "Password"],
                                     title: "Let's get started",
                                     topDescription: "Sign up or login and start riding right away",
                                     termsDescription: ["By continuing you agree to Move's", "Terms and Conditions", " and ", "Privacy Policy"],
                                     bottomDescription: ["You already have an account? You can ", "log in here"],
                                     icon: Image("MoveIcon"))
}
