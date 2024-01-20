//
//  ScooterResponse.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 18.10.2021.
//

import Foundation
import MapKit

struct ScooterResponseModel: Decodable {
    let status: String
    var scooters: [ScooterResponse]
}

struct ScooterResponse: Decodable {
    let code: String
    let location: [Double]
    let batteryLevel: Int
    let isUnlocked: Bool
    let status: String
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location[0], longitude: location[1])
    }
}

struct PingModel: Encodable {
    var location: [Double] = []
    var code: String = ""
}

struct PingResponse: Decodable {
    var status: String
    var successful: Bool?
    var code: String?
    var message: String?
    var relationId: String?
}

struct ScooterLockResponse: Decodable {
    var status: String
    var details: ResponseDetails?
    var code: String?
    var message: String?
    var relationId: String?
}

/// Scooter head light
struct ScooterHeadLightModel: Encodable {
    var headlights: Bool
}

struct ScooterHeadLightResponse: Decodable {
    var status: String
    var details: ResponseDetails?
    var code: String?
    var message: String?
    var relationId: String?
}

struct ResponseDetails: Decodable {
    var target: IDResponse
    var value: String
    var property: String
    var children: [Int]
    var constraints: IsObjectIdStringConstraint
}

/// Scooter tail light
struct ScooterTailLightModel: Encodable {
    var taillights: Bool
}

struct ScooterTailLightResponse: Decodable {
    var status: String
    var details: ResponseDetails?
    var code: String?
    var message: String?
    var relationId: String?
}

struct IDResponse: Decodable {
    var id: String
}

struct IsObjectIdStringConstraint: Decodable {
    var IsObjectIdStringConstraint: String
}

struct LockScooterModel: Encodable {
    var lock: Bool
}

//struct UnlockModel: Decodable {
//    var status: String
//    var ride: RideModel?
//}
