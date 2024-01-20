//
//  UserResponse.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 18.10.2021.
//

import Foundation

struct GetUserModel: Decodable {
    var status: String
    var user: UserModel
}

struct UserModel: Decodable {
    var totalRides: Int
    var _id: String
    var lastLoginAt: String
    var registeredAt: String
    var email: String
    var username: String
    var __v: Int
    var driverLicenseKey: String?
    var isLicenseValid: Bool?
}

struct UserLogoutResponse: Decodable {
    let status: String
    let code: String?
    let message: String?
    let relationId: String?
}
