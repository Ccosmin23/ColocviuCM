//
//  MapAnnotations.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 18.10.2021.
//

import Foundation
import MapKit
import SwiftUI

enum _Annotation: Identifiable {
    case myUserLocation(MKCoordinateRegion)
    case scooter(ScooterResponse)
    
    var image: Image {
        switch self {
        case .scooter:
            return Image("scooterLocationIcon")
        case .myUserLocation:
            return Image("userCurrentLocationIcon")
        }
    }
    
    var coordinates: CLLocationCoordinate2D {
        switch self {
        case .scooter(let scooter):
            return scooter.locationCoordinate
        case .myUserLocation(let region):
            return region.center
        }
    }
    var id: String {
        switch self {
        case .scooter(let scooter):
            return scooter.code
        case .myUserLocation(let region):
            return "\(region.center.latitude)-\(region.center.longitude)"
        }
    }
}
