//
//  Font + Extensions.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import SwiftUI

extension Font {
    static var regular_16: Font {
        .custom("BaiJamjuree-Medium", size: 16)
    }
    
    enum Primary {
        case medium
        case regular
        case bold
        case semibold
        
        func with(size: CGFloat) -> Font {
            switch self {
            case .medium :
                return Font.custom("BaiJamjuree-Medium", size: size)
            case .regular :
                return Font.custom("BaiJamjuree-Regular", size: size)
            case .bold :
                return Font.custom("BaiJamjuree-Bold", size: size)
            case .semibold :
                return Font.custom("BaiJamjuree-SemiBold", size: size)   
            }
        }
    }
    
}

