//
//  ScooterSheet.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import SwiftUI

struct ScooterSheet {
    let title: [String]
    let scooterImage: Image
    let scooterBehindRectangle: Image
    let batteryLow: Image
    let batteryHigh: Image
    let bell: Image
    let missingIcon: Image
    let textButtons: [String]
}

extension ScooterSheet {
    static let page = ScooterSheet(title: ["You can unlock this scooter", "through these methods:"],
                                   scooterImage: Image("ScooterBitmap2"),
                                   scooterBehindRectangle: Image("scooterExpandedRectangle"),
                                   batteryLow: Image("batteryLow"),
                                   batteryHigh: Image("batteryHigh"),
                                   bell: Image("bell"),
                                   missingIcon: Image("missingButton"),
                                   textButtons: ["NFC", "QR", "123"])
}
