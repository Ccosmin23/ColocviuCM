//
//  ScooterView.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 16.09.2021.
//

import SwiftUI
import MapKit

struct ScooterPopUpView: View {
    @ObservedObject var viewModel: ScooterPopUpViewModel
    @State var requestMapSheet = false
    var scooter: ScooterResponse
    var onUnlock: (OnFinishType) -> Void
    

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(25)
                .overlay(scooterBehindRectangle, alignment: .topLeading)
            VStack(spacing: 25) {
                topHStack
                bottomVStack
            }
            .padding(.bottom, 30)
        }
        .frame(width: 250, height: 310)
        .actionSheet(isPresented: $requestMapSheet) { () -> ActionSheet in
            self.chooseMapType()
        }
    }
    
    var scooterBehindRectangle: some View {
        HStack {
            ScooterPopUp.page.scooterBehindRectangle
        }
        .cornerRadius(25)
    }
    
    var topHStack: some View {
        HStack {
            ScooterPopUp.page.scooterImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
            Spacer()
            VStack(alignment: .trailing) {
                VStack {
                    Text(ScooterPopUp.page.title)
                        .font(Font.Primary.medium.with(size: 14))
                        .foregroundColor(Color.rhythm)
                    Text("#\(scooter.code)")
                        .font(Font.Primary.bold.with(size: 20))
                        .foregroundColor(Color.russianViolet)
                    HStack {
                        scooter.batteryLevel < 70 ? AnyView(ScooterPopUp.page.batteryLow) : AnyView(ScooterPopUp.page.batteryHigh)
                        Text("\(scooter.batteryLevel)%")
                            .font(Font.Primary.medium.with(size: 14))
                            .foregroundColor(Color.russianViolet)
                    }
                }
                HStack {
                    Button(action: {
//                        viewModel.pingScooter()
                    }, label: {
                        ScooterPopUp.page.bell
                    })
                    
                    Button(action: {
                        self.requestMapSheet = true
                    }, label: {
                        ScooterPopUp.page.locationArrow
                    })
                }
            }
            .padding(.trailing, 18)
        }
    }
    
    var bottomVStack: some View {
        VStack(alignment: .leading, spacing: 25)  {
            HStack(alignment: .top) {
                ScooterPopUp.page.scooterLocationPin
                VStack(alignment: .leading) {
                    Text("\(viewModel.addressStreet)")
                    Text("nr. \(viewModel.addressNumber)")
                }
                .font(Font.Primary.medium.with(size: 14))
                .foregroundColor(Color.russianViolet)
            }
            Button(action: {
                onUnlock(OnFinishType.scooter(scooter))
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cerise)
                    .frame(height: 50)
                    .overlay(Text(ScooterPopUp.page.buttonText)
                                .font(Font.Primary.bold.with(size: 16))
                                .foregroundColor(.white))
            })
        }
        .padding(.horizontal, 10)
    }
    
    func chooseMapType() -> ActionSheet {
        ActionSheet(title: Text("Choose prefered map to open"),
                    message: Text("Find this scooter with one of your apps."),
                    buttons: self.mapsButtons())
    }

    func mapsButtons() -> [ActionSheet.Button] {
        [ActionSheet.Button.default(Text("Google Maps").foregroundColor(.blue), action: {
            /// Apple maps
            let appleMapsURL = URL(string: "maps://?saddr=&daddr=\(self.scooter.locationCoordinate.latitude),\(self.scooter.locationCoordinate.longitude)")
            if UIApplication.shared.canOpenURL(appleMapsURL!) {
                UIApplication.shared.open(appleMapsURL!, options: [:], completionHandler: nil)
            }
        }),
        ActionSheet.Button.default(Text("Apple Maps").foregroundColor(.blue), action: {
            /// Google maps
            let googleMapsURL = URL(string: "comgooglemaps://?saddr=&daddr=\(self.scooter.locationCoordinate.latitude),\(self.scooter.locationCoordinate.longitude)&directionsmode=driving")
            if UIApplication.shared.canOpenURL(googleMapsURL!) {
                  UIApplication.shared.open(googleMapsURL!, options: [:], completionHandler: nil)
            }
            else{
                let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(self.scooter.locationCoordinate.latitude),\(self.scooter.locationCoordinate.longitude)&directionsmode=driving")
                            
                   UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
            }
        }),
        ActionSheet.Button.cancel()]
    }
    
    enum OnFinishType {
        case dismiss
        case scooter(ScooterResponse)
    }
}

struct ScooterPopUpView_Preview: PreviewProvider {
    static var previews: some View {
        ScooterPopUpView(viewModel: ScooterPopUpViewModel(scooter: ScooterResponse(code: "222", location: [2.2], batteryLevel: 2, isUnlocked: true, status: "good"),
                                                          addressStreet: "",
                                                          addressNumber: "",
                                                          userLocation: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 2, longitude: 2), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
                                                        ),
                        scooter: ScooterResponse(code: "",
                                                 location: [2.2],
                                                 batteryLevel: 2,
                                                 isUnlocked: true,
                                                 status: "")) { result in
                        }
    }
}
