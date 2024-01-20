//
//  MapView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = MapViewModel()
    
    @State var coordinateRegionToDisplay = MKCoordinateRegion.clujLocation
    @State var bookingFlowState: BookingFlowState = .idle
    
    @State var showPaymentAlert = false
    @State var alertTitle = Text("")
    @State var alertMessage = Text("")
    
    @State var showPaymentCompletedAlert = false
    @State var showPaymentFailedAlert = false
    @State var showPaymentCanceledAlert = false
    
    var onFinish: (Bool) -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            mapView()
                .alert(isPresented: showSettingsAlert) { () -> Alert in
                    settingsAlert()
                }
                .alert(isPresented: $showPaymentAlert, content: {
                    return Alert.init(title: alertTitle,
                                      message: alertMessage,
                                      dismissButton: .cancel(Text("OK")))
                })
            scooterOverlays()
        }
    }
    
    @ViewBuilder
    func scooterOverlays() -> some View {
        switch bookingFlowState {
        case .idle:
            Color.clear
        case .scooterPopUp:
            scooterPopUp()
        case .scooterPopUpExpanded:
            scooterSheet()
        }
    }
    
    @ViewBuilder
    func mapView() -> some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $coordinateRegionToDisplay,
                interactionModes: .all,
                showsUserLocation: false,
                userTrackingMode: .constant(.none),
                annotationItems: viewModel.annotations) { item in
                return MapAnnotation(coordinate: item.coordinates) {
                    item.image
                        .padding()
                        .onTapGesture {
                            DispatchQueue.main.async {
                                if case .scooter(let scooter) = item {
                                    viewModel.selectedScooter = scooter
                                    viewModel.getScooterAddress()
                                    self.bookingFlowState = .scooterPopUp
                                } else {
                                    self.bookingFlowState = .idle
                                }
                            }
                        }
                }
            }
                .onTapGesture(perform: {
                    viewModel.selectedScooter = nil
                    self.bookingFlowState = .idle
                })
                .ignoresSafeArea(.all)
            topButtons
        }
    }
    
    @ViewBuilder
    func scooterPopUp() -> some View {
        if case .scooterPopUp = self.bookingFlowState {
            if let scooter = viewModel.selectedScooter {
                withAnimation {
                    ScooterPopUpView(viewModel: ScooterPopUpViewModel(scooter: scooter,
                                                                      addressStreet: viewModel.addressStreet,
                                                                      addressNumber: viewModel.addressNumber,
                                                                      userLocation: viewModel._currentLocation),
                                     scooter: scooter) { result in
                        if case .scooter(_) = result {
                            self.bookingFlowState = .scooterPopUpExpanded
                        }
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func scooterSheet() -> some View {
        if case .scooterPopUpExpanded = self.bookingFlowState {
            if let scooter = viewModel.selectedScooter {
                withAnimation {
                    ScooterSheetView(viewModel: ScooterSheetViewModel(selectedScooter: scooter,
                                                                      code: scooter.code,
                                                                      battery: scooter.batteryLevel,
                                                                      userLocation: viewModel._currentLocation
                                                                     ),
                                     onFinish: { result in
                        
                    }
                    )
                }
            }
        }
    }
    
    func initAlert(paymentStatus: PaymentStatus) {
        switch paymentStatus {
        case .completed:
            self.alertTitle = Text("Your payment was successful")
            self.alertMessage = Text("You can find your receipt on your email")
        case .failed:
            self.alertTitle = Text("Your payment was unsuccessful")
            self.alertMessage = Text("Please try again")
        case .canceled:
            self.alertTitle = Text("Your payment was canceled")
            self.alertMessage = Text("Please try again")
        }
    }
    
    func settingsAlert() -> Alert {
        Alert.init(title: Text("Permission denied"),
                   message: Text("Please, go to Settings and allow permission"),
                   primaryButton: .cancel(),
                   secondaryButton: .destructive(Text("Settings"),
                                                 action: {
            print("go to settings")
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: ") // Prints true
                })
            }
        })
        )
    }
    
    var topButtons: some View {
        VStack {
            HStack {
                HStack {
                    Button(action: {
                        onFinish(true)
                    }, label: {
                        MapModel.page.menuIcon
                    })
                    Spacer()
                    Text(locationManager.currentPlacemark?.administrativeArea ?? "Allow location")
                        .foregroundColor(Color.russianViolet)
                        .font(Font.Primary.semibold.with(size: 17))
                    Spacer()
                    /// check which button must appear
                    if locationManager.enableCurrentLocation {
                        locationEnabledButton
                    } else {
                        locationDisabledButton
                    }
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .background(MapModel.page.topGradientImage)
            Spacer()
        }
    }
    
    var showSettingsAlert: Binding<Bool> {
        return .init {
            return self.locationManager.openSettings == "denied"
        } set: { present in
            if !present {
                self.locationManager.openSettings = nil
            }
        }
    }
    
    var locationEnabledButton: some View {
        withAnimation() {
            Button {
                self.coordinateRegionToDisplay = viewModel._currentLocation
            } label: {
                MapModel.page.currentLocationIcon[1]
            }
        }
    }
    
    var locationDisabledButton: some View {
        withAnimation() {
            Button {
                self.coordinateRegionToDisplay = viewModel._currentLocation
            } label: {
                MapModel.page.currentLocationIcon[0]
            }
        }
    }
    
    enum BookingFlowState {
        case idle
        case scooterPopUp
        case scooterPopUpExpanded
    }
    
    enum PaymentStatus {
        case completed
        case failed
        case canceled
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView() { result in
            
        }
    }
}
