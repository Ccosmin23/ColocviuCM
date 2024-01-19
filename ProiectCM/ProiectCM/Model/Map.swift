//
//  Map.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 19.01.2024.
//

import Foundation
import SwiftUI

struct MapModel {
    let topGradientImage: Image
    let menuIcon: Image
    let currentLocationIcon: [Image]
}

extension MapModel {
    static let page = MapModel(topGradientImage: Image("gradientImage"),
                               menuIcon: Image("menuButton"),
                               currentLocationIcon: [Image("currentLocationButtonDisabled"),
                                                     Image("currentLocationButtonEnabled")])
}
