//
//  MapViewModel.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var _currentLocation = MKCoordinateRegion.clujLocation
    @Published var allScooters: [ScooterResponse] = []
    @Published var selectedScooter: ScooterResponse? = nil
    @Published var addressStreet = ""
    @Published var addressNumber = ""
    @Published var rideId = ""
    
    var locationManager = CLLocationManager()
    
    @Published var paymentURL = ""
    @Published var paymentStatus: PaymentStatus = .idle
    
    var annotations: [_Annotation] {
        var result = allScooters.map { scooter in
            return _Annotation.scooter(scooter)
        }
        result += [_Annotation.myUserLocation(_currentLocation)]
        return result
    }
    
    override init() {
        super.init()
        loadScooters()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func getScooterAddress() {
        if let scooter = self.selectedScooter {
            getAddress(latitude: scooter.locationCoordinate.latitude, longitude: scooter.locationCoordinate.longitude)
        }
    }
    
    func getNearbyScooters() {
        let userLocation = [self._currentLocation.center.latitude, self._currentLocation.center.longitude]
        //        API.getNearbyScooters(userLocation: userLocation) { [weak self] result in
        //            switch result {
        //            case .success(let scooterResponseModel):
        //                if scooterResponseModel.status != "success" {
        //                    ErrorDisplay.show(error: scooterResponseModel.status)
        //                }
        //                self?.allScooters = scooterResponseModel.scooters
        //            case .failure(let error):
        //                print(error.localizedDescription)
        //            }
        //        }
    }
    
    func loadScooters() {
        getNearbyScooters()
        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: {
            self.loadScooters()
        })
    }
    
    func getAddress(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) in
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
            }
            
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placemark = placemarks[0]
                    if let subThoroughfare = placemark.subThoroughfare {
                        self?.addressNumber = subThoroughfare
                    }
                    if let thoroughfare = placemark.thoroughfare {
                        self?.addressStreet = thoroughfare
                    }
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self._currentLocation = MKCoordinateRegion(center: lastLocation.coordinate,
                                                       span: MKCoordinateSpan(latitudeDelta: TapptitudeDefaults.zoom,
                                                                              longitudeDelta: TapptitudeDefaults.zoom))
        }
    }
    
    enum PaymentStatus {
        case idle
        case completed
        case failed
        case canceled
    }
    
    enum RideStage {
        case ongoing
        case startPayment
        case endPayment
    }
}

extension MKCoordinateRegion {
    static let clujLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: ClujDefaults.latitude,
                                                                                longitude: ClujDefaults.longitude),
                                                 span: MKCoordinateSpan(latitudeDelta: ClujDefaults.zoom,
                                                                        longitudeDelta: ClujDefaults.zoom))
    
    static let tapptitudeLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: TapptitudeDefaults.latitude,
                                                                                      longitude: TapptitudeDefaults.longitude),
                                                       span: MKCoordinateSpan(latitudeDelta: TapptitudeDefaults.zoom,
                                                                              longitudeDelta: TapptitudeDefaults.zoom))
}

enum ClujDefaults {
    static let latitude = 46.767003
    static let longitude = 23.595808
    static let zoom = 0.046661
}

enum TapptitudeDefaults {
    static let latitude = 46.753663
    static let longitude = 23.584261
    static let zoom = 0.013202
}
