//
//  PageNavigationView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI

struct PageNavigationView: View {
    let numberOfPages: Int
    let currentIndex: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<self.numberOfPages) { index in
                if self.currentIndex == index {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(Color.russianViolet)
                        .frame(width: 16, height: 4)
                        .id(index)
                } else {
                    Circle()
                        .foregroundColor(Color.heliotropeGray)
                        .frame(width: 4, height: 4)
                        .id(index)
                }
            }
        }
        .frame(width: 80, height: 4)
    }
}

struct PageNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        PageNavigationView(numberOfPages: 5, currentIndex: 3)
    }
}
