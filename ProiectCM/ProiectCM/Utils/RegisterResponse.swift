//
//  RegisterResponse.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 18.10.2021.
//

import Foundation

struct RegisterResponseModel: Encodable {
    let username: String
    let email: String
    let password: String
}

struct RegisterResponseDecoded: Decodable {
    var status: String
    var code: String?
    var message: String?
    var relationId: String?
    var user: UserRegistered?
    var token: String?
}

struct UserRegistered: Decodable {
    var totalRides: Int
    var _id: String
    var email: String
    var password: String
    var username: String
    var lastLoginAt: String
    var registeredAt: String
    var __v: Int
}
