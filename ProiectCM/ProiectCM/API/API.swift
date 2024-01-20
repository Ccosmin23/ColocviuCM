//
//  API.swift
//  Move
//
//  Created by Cosmin Cosan on 31.08.2021.
//
import Foundation
import Alamofire
import UIKit
import MapKit
import SwiftUI

typealias Result<Success> = Swift.Result<Success, Error>
typealias AFResult<Success> = Swift.Result<Success, AFError>

let baseURL = "https://tapp-move-api.herokuapp.com/api-v1/"

class API {
    static var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        
        if let token = Session.getSession() {
            headers.add(HTTPHeader.authorization(bearerToken: token))
        }
        return headers
    }
    
    static func register(requestParameters: RegisterModel, callback: @escaping (AFResult<RegisterResponseDecoded>) -> Void) {
        AF.request("\(baseURL)auth/register", method: .post, parameters: requestParameters, encoder: JSONParameterEncoder.default).responseDecodable(of: RegisterResponseDecoded.self) { response in
            callback(response.result)
        }
    }
    
    static func login(requestParametest: LoginModel, callback: @escaping (AFResult<LoginResponseModel>) -> Void) {
        AF.request("\(baseURL)auth/login", method: .post, parameters: requestParametest, encoder: JSONParameterEncoder.default, headers: self.headers).responseDecodable(of: LoginResponseModel.self) { response in
            callback(response.result)
        }
    }
    
    static func logout(callback: @escaping (AFResult<UserLogoutResponse>) -> Void) {
        AF.request("\(baseURL)auth/logout", method: .post, headers: self.headers).responseDecodable(of: UserLogoutResponse.self) { response in
            callback(response.result)
        }
    }
    
    static func getUser(callback: @escaping (AFResult<GetUserModel>) -> Void) {
        AF.request("\(baseURL)users/me", headers: self.headers).validate().responseDecodable(of: GetUserModel.self) { response in
            callback(response.result)
        }
    }
    
    static func getNearbyScooters(userLocation: [Double], callback: @escaping (AFResult<ScooterResponseModel>) -> Void) {
        AF.request("\(baseURL)scooters/near?location=\(userLocation[0]),\(userLocation[1])", headers: self.headers).validate().responseDecodable(of: ScooterResponseModel.self) { response in
            callback(response.result)
        }
    }
}
