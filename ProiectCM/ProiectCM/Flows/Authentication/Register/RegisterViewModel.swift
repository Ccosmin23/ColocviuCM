//
//  RegisterViewModel.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var hidePassword: Bool = true
    @Published var spinnerEnabled: Bool?
    @Published var scrollTarget: Int?
    
    var ifTextFieldsAreEmpty: Bool {
        self.email.isEmpty || self.username.isEmpty || self.password.isEmpty
    }
    
    var ifTextFieldsDoNotMatch: Bool {
        self.isEmailValid(emailAddress: self.email)
    }
    
    func fromDictionaryToString(dictionary: [String: Any]?) -> String {
        let details = dictionary?["details"] as? [String: Any]
        let constaints = details?["constraints"] as? [String: Any]
        let matches =  constaints?["matches"] as? String
        return matches ?? ""
    }
    
    func registerRequest(callback: @escaping (Bool) -> Void) {
        let registerModel = RegisterModel(email: self.email, username: self.username, password: self.password)
        
        DispatchQueue.main.async {
            self.spinnerEnabled = true
        }
        
        API.register(requestParameters: registerModel) { [weak self] result in
            switch result {
            case .success(let registerResponse):
                if registerResponse.status != "success" {
//                    ErrorDisplay.show(error: registerResponse.message)
                } else {
                    guard let token = registerResponse.token, let username = registerResponse.user?.username, let email = registerResponse.user?.email else { return }
                    Session.saveSession(token: token)
                    Session.username = username
                    Session.email = email
                    callback(true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self?.spinnerEnabled = false
            callback(true)
        }
    }
    
    func showAndHidePassword() {
        switch hidePassword {
        case true:
            hidePassword = false
        case false:
            hidePassword = true
        }
    }
    
    func isEmailValid(emailAddress: String) -> Bool {
        let pattern = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = emailAddress as NSString
            let result = regex.matches(in: emailAddress, range: NSRange(location: 0, length: nsString.length))
            
            if result.count == 0 {
                return true
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return true
        }
        return false
    }
    
    func checkTarget(target: Int) {
        if self.scrollTarget == target {
            scrollTarget = nil
        }
    }
}
