//
//  ScooterSheetViewModel.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import MapKit

class ScooterSheetViewModel: ObservableObject {
    var code: String
    var battery: Int
    var userLocation: MKCoordinateRegion
    @Published var selectedScooter: ScooterResponse?
    
    init(selectedScooter: ScooterResponse, code: String, battery: Int,userLocation: MKCoordinateRegion) {
        self.selectedScooter = selectedScooter
        self.code = code
        self.battery = battery
        self.userLocation = userLocation
    }
}
