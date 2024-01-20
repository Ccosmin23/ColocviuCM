//
//  RegisterView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI
import Combine

struct RegisterView: View {
    var onFinished: (Bool) -> Void
    @State var showSafari = false
    @State var enableSliding = false
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        ZStack {
            Register.page.background
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
                        viewModel.checkTarget(target: target ?? 0)
                        withAnimation(.easeInOut.speed(2.5)) {
                            value.scrollTo(target, anchor: .bottom)
                        }
                    }
            } // end of ScrollViewReader
        }
    }
    
    var baseVStack: some View {
        VStack(alignment: .leading) {
            Register.page.icon
                .padding(.top, 50)
            titleAndDescription
                .padding(.top)
            VStack(alignment: .leading) {
                textfields
                termsAndConditionsText
                    .padding(.top)
                HStack(alignment: .center) {
                    Spacer()
                    if viewModel.ifTextFieldsAreEmpty || viewModel.ifTextFieldsDoNotMatch {
                        buttonGetStartedInactive
                            .padding(.top, 25)
                    }
                    else {
                        buttonGetStartedActive
                            .padding(.top, 25)
                    }
                    Spacer()
                }
                
                haveAnAccountText
            }
        }
        .padding(.horizontal, 20)
        
    }
    
    var haveAnAccountText: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(Register.page.bottomDescription[0])
            Button(action: {
                DispatchQueue.main.async {
                    onFinished(false)
                }
            }, label: {
                Text(Register.page.bottomDescription[1])
                    .bold()
                    .underline()
            })
            Spacer()
        }
        .font(Font.Primary.medium.with(size: 12))
        .foregroundColor(.white)
        .padding(.top)
    }
    
    var buttonGetStartedInactive: some View {
        Button(action: {}, label: {
            Image("getStartedButtonInactive")
                .padding(.horizontal, 5)
        })
        .id(1)
        .disabled(true)
    }
    
    var buttonGetStartedActive: some View {
        ZStack(alignment: .trailing) {
            Button(action: {
                viewModel.registerRequest { result in
//                    if result {
                        onFinished(result)
//                    }
                }
            }, label: {
                Image("getStartedButtonActive")
                    .padding(.horizontal, 5)
            })
            .id(1)
            if let spinner = viewModel.spinnerEnabled {
                if spinner {
                    ProgressView()
                        .padding(.trailing, 80)
                }
            }
        }
    }
    
    var termsAndConditionsText: some View {
        VStack(alignment: .leading) {
            Text(Register.page.termsDescription[0])
            HStack(spacing: 0) {
                Button(action: {
                    self.showSafari.toggle()
                }, label: {
                    Text(Register.page.termsDescription[1])
                        .underline()
                        .bold()
                })
                .sheet(isPresented: $showSafari) {
                    //                    OrganizationPolicy(url: "https://tapptitude.com")
                }
                Text(Register.page.termsDescription[2])
                Button(action: {
                    self.showSafari.toggle()
                }, label: {
                    Text(Register.page.termsDescription[3])
                        .underline()
                        .bold()
                })
                .sheet(isPresented: $showSafari) {
                    //                    OrganizationPolicy(url: "https://tapptitude.com/privacy-policy/")
                }
            }
        }
        .font(Font.Primary.medium.with(size: 12))
        .foregroundColor(.white)
        .frame(alignment: .leading)
        .padding(.horizontal, 5)
    }
    
    /// Textfields and SecureField chunk for Email Address, Username and Password
    var textfields: some View {
        VStack(alignment: .leading) {
            TextFieldView(credentialName: $viewModel.email, scrollTarget: viewModel.scrollTarget, enableSliding: enableSliding, title: Register.page.credentials[0])
                .accentColor(.white)
            TextFieldView(credentialName: $viewModel.username, scrollTarget: viewModel.scrollTarget, enableSliding: enableSliding, title: Register.page.credentials[1])
                .accentColor(.white)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(Register.page.credentials[2])
                    .font(Font.Primary.regular.with(size: 12))
                    .foregroundColor(Color.heliotropeGray)
                    .isHidden(viewModel.password.isEmpty ? true : false)
                HStack {
                    ZStack(alignment: .leading) {
                        if viewModel.hidePassword {
                            if viewModel.password.isEmpty {
                                Button(Register.page.credentials[2]) {
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
                                Text(Register.page.credentials[2])
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
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
    }
    
    var titleAndDescription: some View {
        VStack(alignment: .leading) {
            Text(Register.page.title)
                .font(Font.Primary.bold.with(size: 32))
                .foregroundColor(.white)
                .padding(.horizontal, 5)
            Text(Register.page.topDescription)
                .font(Font.Primary.medium.with(size: 20))
                .foregroundColor(Color.heliotropeGray)
                .frame(maxWidth: 250, minHeight: 50)
                .padding(.vertical, 5)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView{ result in
            
        }
    }
}
