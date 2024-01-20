//
//  ScooterViewModel.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 17.09.2021.
//

import Foundation
import SwiftUI
import MapKit

class ScooterPopUpViewModel: ObservableObject {
    @Published var addressStreet: String
    @Published var addressNumber: String
    @Published var scooter: ScooterResponse
    @Published var userLocation: MKCoordinateRegion
    
    init(scooter: ScooterResponse, addressStreet: String, addressNumber: String, userLocation: MKCoordinateRegion) {
        self.scooter = scooter
        self.addressStreet = addressStreet
        self.addressNumber = addressNumber
        self.userLocation = userLocation
    }
}
