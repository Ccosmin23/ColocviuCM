//
//  LoginViewModel.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var hidePassword: Bool = true
    @Published var spinnerEnabled: Bool?
    @Published var scrollTarget: Int?

    func loginRequest(callback: @escaping (Bool) -> Void) {
        let loginModel = LoginModel(email: self.email, password: self.password)
        DispatchQueue.main.async {
            self.spinnerEnabled = true
        }
            API.login(requestParametest: loginModel) { [weak self] result in
                switch result {
                case .success(let loginResponse):
                    if loginResponse.status != "success" {
//                        ErrorDisplay.show(error: loginResponse.message ?? "no message")
                    } else {
                        if let token = loginResponse.token, let username = loginResponse.user?.username, let email = loginResponse.user?.email {
                            Session.saveSession(token: token)
                            Session.username = username
                            Session.email = email
                            self?.getUser() { result in
                                if case .success(let userModel) = result {
                                    if userModel.user.isLicenseValid ?? false {
                                        callback(true)
                                    } else {
                                        callback(false)
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.spinnerEnabled = false
            }
    }
    
    func getUser(callback: @escaping (Result<GetUserModel>) -> Void) {
        API.getUser() { result in
            switch result {
            case .success(let userModel):
                if userModel.status != "success" {
//                    ErrorDisplay.show(error: userModel.status)
                } else {
                    Session.username = userModel.user.username
                    callback(.success(userModel))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
        
    func checkScrollTarget(target: Int) {
        if target == target {
            scrollTarget = nil
        }
    }

}
