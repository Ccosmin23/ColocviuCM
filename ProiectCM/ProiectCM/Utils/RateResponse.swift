//
//  RateModels.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 18.10.2021.
//

import Foundation

struct RateAppModel: Encodable {
    let platform: String
    let value: String
}

struct RateResponseModel: Decodable {
    let status: String
    let user: RateUserModel
    let totalRides: Int
    let _id: String
    let email: String
    let username: String
    let lastLoginAt: String
    let registeredAt: String
    let __v: Int
    let driverLicenseKey: String
    let isLicenseValid: Bool
}

struct RateUserModel: Decodable {
    let ios: String
}

struct Platform: Decodable {
    let ios: String
}
