//
//  LoginView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State var enableSliding = false
    @State var success = false
    var onFinished: (OnFinishedType) -> Void
    
    var body: some View {
            ZStack {
                Image("usualBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.all)
                
                baseScrollView
            }
    }
    
    var baseScrollView: some View {
        ScrollView {
            ScrollViewReader { (value: ScrollViewProxy) in
                baseVStack
                    .padding(.top, 50)
                    .onChange(of: viewModel.scrollTarget) { target in
                        viewModel.checkScrollTarget(target: target ?? 0)
                        withAnimation(.easeInOut.speed(2.5)) {
                            value.scrollTo(target, anchor: .bottom)
                        }
                    }
            }
        }
    }
    
    var ifTextFieldsAreEmpty: Bool {
        viewModel.email.isEmpty || viewModel.password.isEmpty
    }
    
    var ifTextFieldsDoNotMatch: Bool {
        viewModel.isEmailValid(emailAddress: viewModel.email)
    }
    
    var baseVStack: some View {
        VStack(alignment: .leading) {
            Spacer()
            Login.page.icon
                .padding(.top, 50)
            titleAndDescription
            
            VStack(alignment: .leading) {
                TextFieldView(credentialName: $viewModel.email,
                              scrollTarget: viewModel.scrollTarget,
                              enableSliding: enableSliding,
                              title: Login.page.textFieldTitles[0])
                    .padding(.top)
                    .accentColor(.white)

                VStack(alignment: .leading, spacing: 0) {
                    Text(Login.page.textFieldTitles[1])
                        .font(Font.Primary.regular.with(size: 12))
                        .foregroundColor(Color.heliotropeGray)
                        .isHidden(viewModel.password.isEmpty ? true : false)
                    HStack {
                        ZStack(alignment: .leading) {
                            if viewModel.hidePassword {
                                if viewModel.password.isEmpty {
                                    Button(Login.page.textFieldTitles[1]) {
                                        self.enableSliding.toggle()
                                    }
                                    .font(Font.Primary.medium.with(size: 16))
                                    .foregroundColor(Color.heliotropeGray)
                                }
                                SecureField("", text: $viewModel.password)
                                    .accentColor(.white)
                                    .foregroundColor(.white)
                                    .frame(minHeight: 30)
                                    .onChange(of: enableSliding, perform: { value in
                                        viewModel.scrollTarget = 1
                                    })
                            }
                            else {
                                if viewModel.password.isEmpty {
                                    Text(Login.page.textFieldTitles[1])
                                        .font(Font.Primary.medium.with(size: 16))
                                        .foregroundColor(Color.heliotropeGray)
                                }
                                TextField("", text: $viewModel.password, onEditingChanged: { (isBegin) in
                                    if isBegin {
                                        viewModel.scrollTarget = 1
                                    }
                                })
                                .accentColor(.white)
                                .foregroundColor(.white)
                                .frame(minHeight: 30)
                            }
                        }
                        Button(action: {
                            viewModel.showAndHidePassword()
                        }, label: {
                            Image(systemName: viewModel.hidePassword ? "eye.slash" : "eye")
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                        })
                    }
                    HorizontalLine(color: Color.heliotropeGray)
                }
                .padding(.top)

                Button(action: {
//                    onFinished(OnFinishedType.goToForgotPasswordView)
                }, label: {
                    Text(Login.page.suggestion)
                        .font(Font.Primary.regular.with(size: 12))
                        .foregroundColor(Color.white)
                        .underline()
                        .padding(.top)
                })
                if ifTextFieldsAreEmpty || ifTextFieldsDoNotMatch {
                    loginButtonInactive
                        .padding(.top, 25)
                }
                else {
                    loginButtonActive
                        .padding(.top, 25)
                }
                haveAnAccountText
            }
            .padding(.horizontal, 5)
        }
        .padding(.horizontal, 20)
    }
    
    var haveAnAccountText: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(Login.page.bottomDescription[0])
            Button(action: {
                onFinished(OnFinishedType.goToAuthenticationView)
            }, label: {
                Text(Login.page.bottomDescription[1])
                    .bold()
                    .underline()
            })
            Spacer()
        }
        .font(Font.Primary.medium.with(size: 12))
        .foregroundColor(.white)
        .padding(.top)
    }
    
    var titleAndDescription: some View {
        VStack(alignment: .leading) {
            Text(Login.page.title)
                .font(Font.Primary.bold.with(size: 32))
                .foregroundColor(.white)
                .padding(.horizontal, 5)
            Text(Login.page.topDescription)
                .font(Font.Primary.medium.with(size: 20))
                .foregroundColor(Color.heliotropeGray)
                .frame(maxWidth: 300, minHeight: 50)
                .padding(.top)
        }
    }
    
    var loginButtonInactive: some View {
        Image("loginButtonInactive")
            .padding(.horizontal, 5)
            .id(1)
    }
    
    var loginButtonActive: some View {
        ZStack(alignment: .trailing) {
            Button(action: {
                viewModel.loginRequest { result in
                    /// if result is true that means the current user already uploaded a driving license
                    if result {
                        onFinished(OnFinishedType.goToMapView)
                    } else {
                        
                    }
                }
            }, label: {
                Image("loginButtonActive")
            })
            .padding(.horizontal, 5)
            .id(1)
            if let spinner = viewModel.spinnerEnabled {
                if spinner {
                    ProgressView()
                        .padding(.trailing, 80)
                }
            }
        }
    }
    
    enum OnFinishedType {
        case goToAuthenticationView
        case goToMapView
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView { result in
            
        }
    }
}
