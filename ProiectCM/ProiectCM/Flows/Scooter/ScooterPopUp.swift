//
//  ScooterPopUp.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 12.10.2021.
//

import Foundation
import SwiftUI

struct ScooterPopUp {
    let title: String
    let scooterImage: Image
    let scooterBehindRectangle: Image
    let batteryLow: Image
    let batteryHigh: Image
    let bell: Image
    let locationArrow: Image
    let scooterLocationPin: Image
    let buttonText: String
}

extension ScooterPopUp {
    static let page = ScooterPopUp(title: "Scooter",
                                   scooterImage: Image("ScooterBitmap"),
                                   scooterBehindRectangle: Image("popUpRectangle"),
                                   batteryLow: Image("batteryLow"),
                                   batteryHigh: Image("batteryHigh"),
                                   bell: Image("bell"),
                                   locationArrow: Image("locationArrow"),
                                   scooterLocationPin: Image("locationScooterPin"),
                                   buttonText: "Unlock")
}
