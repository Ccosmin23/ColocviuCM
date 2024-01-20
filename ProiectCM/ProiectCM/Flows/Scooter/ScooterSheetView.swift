//
//  ScooterSheetView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI
import MapKit

struct ScooterSheetView: View {
    @ObservedObject var viewModel: ScooterSheetViewModel
    var onFinish: (OnFinishType) -> Void
    
    var body: some View {
        Color.clear
            .overlay(baseSheet, alignment: .bottom)
            .ignoresSafeArea(.all)
    }
    
    var baseSheet: some View {
        RoundedRectangle(cornerRadius: 25)
            .overlay(Image("ceriseRectangle"), alignment: .top)
            .frame(height: 400)
            .foregroundColor(.white)
            .overlay(
                VStack {
                    Text(ScooterSheet.page.title[0])
                    Text(ScooterSheet.page.title[1])
                }
                .padding(.top)
                .font(Font.Primary.bold.with(size: 16))
                .foregroundColor(Color.russianViolet), alignment: .top)
            .overlay(baseVStack)
            .ignoresSafeArea(.all)
    }
    
    var baseVStack: some View {
        VStack {
            middleHStack
            bottomHStack
        }
    }
    
    var middleHStack: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Scooter")
                    .font(Font.Primary.medium.with(size: 16))
                    .foregroundColor(Color.rhythm)
                if let scooter = viewModel.selectedScooter {
                    Text("#\(scooter.code)")
                        .font(Font.Primary.bold.with(size: 32))
                        .foregroundColor(Color.russianViolet)
                        .padding(.top, 5)
                }
                HStack {
                    if let scooter = viewModel.selectedScooter {
                        scooter.batteryLevel > 70 ? AnyView(ScooterSheet.page.batteryHigh) : AnyView(ScooterSheet.page.batteryLow)
                        Text("\(scooter.batteryLevel)%")
                            .font(Font.Primary.medium.with(size: 14))
                            .foregroundColor(Color.russianViolet)
                    }
                }
                .padding(.top, 5)
                
                HStack {
                    Button(action: {
//                        viewModel.pingScooter()
                    }, label: {
                        HStack {
                            ScooterSheet.page.bell
                            Text("Ring")
                        }
                    })
                    .padding(.trailing)
                }
                .padding(.top, 25)
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        ScooterSheet.page.missingIcon
                        Text("Missing")
                            .font(Font.Primary.medium.with(size: 14))
                            .foregroundColor(Color.russianViolet)
                    })
                    .padding(.trailing)
                }
                .padding(.top, 25)
                
            }
            .padding(.leading, 30)
            Spacer()
            ZStack {
                ScooterSheet.page.scooterBehindRectangle
                ScooterSheet.page.scooterImage
            }
        }
        .padding(.top)
    }
    
    var bottomHStack: some View {
        HStack(spacing: 20) {
            Button(action: {
                onFinish(OnFinishType.NFC)
            }, label: {
//                CustomButton._NFC
            })
            
            Button(action: {
                onFinish(OnFinishType.QR)
            }, label: {
//                CustomButton._QR
            })
            
            Button(action: {
                onFinish(OnFinishType.SerialNumber)
            }, label: {
//                CustomButton._123
            })
        }
        .padding(.top)
    }
    
    enum OnFinishType {
        case NFC
        case QR
        case SerialNumber
    }
}

struct ScooterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ScooterSheetView(viewModel: ScooterSheetViewModel(selectedScooter: ScooterResponse(code: "",
                                                                                           location: [2.2],
                                                                                           batteryLevel: 20,
                                                                                           isUnlocked: true,
                                                                                           status: ""),
                                                          code: "", battery: 2, userLocation: MKCoordinateRegion.clujLocation)
        ) { result in
            
        }
    }
}
