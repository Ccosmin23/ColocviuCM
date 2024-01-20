//
//  CurrentLocation.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 13.09.2021.
//
import Foundation
import MapKit
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    lazy var geocoder = CLGeocoder()
    @Published var locationString = ""
    @Published var invalid: Bool = false
    
    @Published var enableCurrentLocation = false
    @Published var openSettings: String?
    @Published var location: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var lastSeenLocation: CLLocation?
    @Published var currentPlacemark: CLPlacemark?
    
    let locationManager = CLLocationManager()
    static let DefaultLocation = CLLocationCoordinate2D(latitude: TapptitudeDefaults.latitude, longitude: TapptitudeDefaults.longitude)
    static let shared = LocationManager()
    
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
     static var currentLocation: CLLocationCoordinate2D {
        guard let location = shared.locationManager.location else {
            return DefaultLocation
        }
        return location.coordinate
    }
    
    enum ClujDefaults {
        static let latitude = 46.767003
        static let longitude = 23.595808
        static let zoom = 0.046661
    }
    
    enum TapptitudeDefaults {
        static let latitude = 46.75353699880865
        static let longitude = 23.584302097593888
        static let zoom = 0.013202
    }
    
    func getUserLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.last
        fetchCountryAndCity(for: locations.last)
    }
    
    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let lastPlacemark = placemarks?.last {
                if lastPlacemark != self.currentPlacemark {
                    self.currentPlacemark = lastPlacemark
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager changed the status: \(status)")
        self.authorizationStatus = status

        if CLLocationManager.locationServicesEnabled() {
            
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted:
                    self.locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    self.enableCurrentLocation = true
                    self.openSettings = "authorized"
                case .denied:
                    self.enableCurrentLocation = false
                    self.openSettings = "denied"
                    
                @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
}
