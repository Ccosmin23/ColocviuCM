//
//  Onboarding.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 19.01.2024.
//

import Foundation

struct Onboarding: Identifiable, Hashable {
    let id = UUID()
    var index: Int
    let image: String
    let title: String
    let description: String
}

extension Onboarding {
    static let page1 = Onboarding(index: 0,
                                  image: "Bitmap1",
                                  title: "Safety",
                                  description: "Please wear a helmet and protect yourself while riding.")
    
    static let page2 = Onboarding(index: 1,
                                  image: "Bitmap2",
                                  title: "Scan",
                                  description: "Scan the QR or NFC sticker on top of the scooter to unlock and ride.")
    
    static let page3 = Onboarding(index: 2,
                                  image: "Bitmap3",
                                  title: "Ride",
                                  description: "Step on scooter with one foot and kick off the ground. When the scooter starts to coast, push right throttle to accelerate.")
    
    static let page4 = Onboarding(index: 3,
                                  image: "Bitmap4",
                                  title: "Parking",
                                  description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.")
    
    static let page5 = Onboarding(index: 4,
                                  image: "Bitmap5",
                                  title: "Rules",
                                  description: "You must be 18 years or and older with a valid driving license to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws.")
    
    static let pages: [Onboarding] = [.page1, .page2, .page3, .page4, .page5]
}
