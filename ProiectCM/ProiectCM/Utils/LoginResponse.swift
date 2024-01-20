//
//  LoginResponse.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 18.10.2021.
//

import Foundation

struct LoginUser: Decodable {
    let rating: RateUserModel?
    let totalRides: Int
    let _id: String
    let email: String
    let username: String
    let lastLoginAt: String
    let registeredAt: String
    let __v: Int
    let driversLicenseKey: String
    let isLicenseValid: Bool
    let forgotPasswordToken: String?
}

struct LoginResponseModel: Decodable {
    let status: String
    let code: String?
    let message: String?
    let relation: String?
    let user: LoginUser?
    let token: String?
}

struct LoginModel: Encodable {
    var email = ""
    var password = ""
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

struct RegisterModel: Encodable {
    var email = ""
    var username = ""
    var password = ""
    
    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
    }
}

