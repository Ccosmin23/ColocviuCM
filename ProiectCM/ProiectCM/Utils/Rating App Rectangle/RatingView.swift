//
//  RatingView.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 27.09.2021.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.white
    var onColor = Color.cerise

    var body: some View {
        Color.black
            .opacity(0)
            .overlay(
                ZStack(alignment: .center) {
                        Image("historyRectangle")
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 50)
                            .cornerRadius(15)
                        baseContent
                }
                .padding(.bottom), alignment: .bottom)
    }
    
    var baseContent: some View {
        HStack {
            if !self.label.isEmpty {
                Text(self.label)
            }
            ForEach(1..<maximumRating + 1) { number in
                self.image(number: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                        
                    }
            }
        }
    }
    
    func image(number: Int) -> Image {
        if number > self.rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(5))
    }
}
