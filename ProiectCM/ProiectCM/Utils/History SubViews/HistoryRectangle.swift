//
//  HistoryRectangle.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 24.09.2021.
//

import SwiftUI

struct HistoryRectangle: View {
    var startAddress: String
    var endAddress: String
    var duration: Int
    var distance: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color.ghostWhite)
                .frame(width: 218, height: 160)
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.russianViolet, lineWidth: 1.5)
                .frame(width: 327, height: 160)
                .overlay(baseContent)
        }
    }
    
    var baseContent: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 35) {
                    VStack(alignment: .leading) {
                        Text("From")
                            .foregroundColor(Color.gray)
                            .font(Font.Primary.medium.with(size: 12))
                        VStack(alignment: .leading) {
                            Text("\(startAddress)")
                        }
                        .foregroundColor(Color.russianViolet)
                        .font(Font.Primary.bold.with(size: 14))
                    }
                    VStack(alignment: .leading) {
                        Text("To")
                            .foregroundColor(Color.gray)
                            .font(Font.Primary.medium.with(size: 12))
                        VStack(alignment: .leading) {
                            Text("\(endAddress)")
                        }
                        .foregroundColor(Color.russianViolet)
                        .font(Font.Primary.bold.with(size: 14))
                    }
                }
                .padding(.leading, 15)
                Spacer()
                VStack(alignment: .leading, spacing: 35) {
                    let seconds = duration / 1000
                    let minutes = duration / 60000
                    let hours = minutes / 60
                    VStack(alignment: .leading){
                        Text("Travel Time")
                            .foregroundColor(Color.gray)
                            .font(Font.Primary.medium.with(size: 12))
                        HStack(spacing: 0) {
                            Text(minutes > 59 ? hours > 9 ? "\(hours):" : "0\(hours):" : minutes > 9 ? "\(minutes):" : "0\(minutes):")
                            Text(seconds > 59 ? minutes > 9 ? "\(minutes) min" : "0\(minutes) min" : seconds > 9 ? "\(seconds) sec" : "0\(seconds) sec")
                        }
                        .foregroundColor(Color.russianViolet)
                        .font(Font.Primary.bold.with(size: 14))
                    }
                    VStack(alignment: .leading) {
                        Text("Distance")
                            .foregroundColor(Color.gray)
                            .font(Font.Primary.medium.with(size: 12))
                        let km = distance / 100
                        Text(distance > 1000 ? km > 9 ? "\(km / 10).\(km % 10) km" : "\0.\(km) km" : "\(distance) meters")
                            .foregroundColor(Color.russianViolet)
                            .font(Font.Primary.bold.with(size: 14))
                    }
                }
                .padding(.top, 2)
                .padding(.trailing, 15)
            }
            .padding(.horizontal, 10)
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRectangle(startAddress: "startAddress", endAddress: "endAddress", duration: 10, distance: 20)
    }
}
