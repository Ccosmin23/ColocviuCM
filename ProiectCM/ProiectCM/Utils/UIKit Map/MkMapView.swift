//
//  MkMapView.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 24.09.2021.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct UIKitMap: UIViewRepresentable {
    
    let centerCoordinate: CLLocationCoordinate2D
    let locations: [[Double]]
    
    private var locationCoorinates: [CLLocationCoordinate2D] {
        var result: [CLLocationCoordinate2D] = []
        locations.forEach { location in
            result.append(CLLocationCoordinate2D(latitude: location[0], longitude: location[1]))
        }
        return result
    }
    
    func makeUIView(context: Context) -> some MKMapView {
        let mapView = MKMapView()
        let polyline = MKPolyline(coordinates: locationCoorinates, count: locations.count)
        
        let startAnnotation: MKPointAnnotation = MKPointAnnotation()
        startAnnotation.title = "Start"
        startAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations.first![0], longitude: locations.first![0])
//        startAnnotation.image = Image("startLocationIcon")
        
        let endAnnotation: MKPointAnnotation = MKPointAnnotation()
        endAnnotation.title = "End"
        endAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations.last![0], longitude: locations.last![0])

        mapView.setRegion(MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 900, longitudinalMeters: 900), animated: false)
        mapView.delegate = context.coordinator
        mapView.addOverlay(polyline)
        mapView.addAnnotations([startAnnotation, endAnnotation])
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UIKitMap
        
        init(_ parent: UIKitMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            
            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
            polylineRenderer.strokeColor = UIColor(Color.russianViolet)
            polylineRenderer.lineWidth = 3.5
            return polylineRenderer
        
        }
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
