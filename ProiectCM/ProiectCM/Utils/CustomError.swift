//
//  CustomError.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 25.10.2021.
//

import Foundation


struct CustomError: Error, Codable {
    let message: String
}

extension CustomError {
    static let error = CustomError(message: "Uups, something went wrong")
}
