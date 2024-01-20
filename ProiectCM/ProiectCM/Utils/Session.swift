//
//  Session.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import Alamofire


struct Session {
    
    public enum Session {
        @UserDefault(key: "authToken", defaultValue: nil)
        static var authToken: String?
        
        @UserDefault(key: "user", defaultValue: nil)
        static var user: String?
        
        @UserDefault(key: "didUploadLicense", defaultValue: false)
        static var didUploadLicense: Bool
        
    }
    
    static func saveSession(token: String) {
        UserDefaults.standard.setValue(token, forKey: "authToken")
        Session.authToken = token
    }
    
    static func getSession() -> String? {
        return Session.authToken
    }
    
    static var username: String {
        get {
            let value = UserDefaults.standard.value(forKey: "username")
            return value as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var email: String {
        get {
            let value = UserDefaults.standard.value(forKey: "email")
            return value as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
            UserDefaults.standard.synchronize()
        }
    }
}
