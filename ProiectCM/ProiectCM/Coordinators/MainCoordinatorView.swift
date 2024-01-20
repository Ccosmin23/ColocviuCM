//
//  MainCoordinatorView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI
import NavigationStack

struct MainCoordinatorView: View {
    @SceneStorage("currentView") var selectedView: CurrentView = .onboarding
    var navigationStackViewModel = NavigationStackCompat()
    @StateObject var viewModel = MainCoordinatorViewModel()
    
    //MARK: - body
    var body: some View {
        NavigationStackView(navigationStack: navigationStackViewModel) {
            SelectionView(selection: $selectedView) {
                showCurrentFlowState()
            }
        }
    }
    
    @ViewBuilder
    func showCurrentFlowState() -> some View {
        switch viewModel.coordinatorFlowState {
        case .idle:
            onboardingView()
        case .arrivedAtAuthentication(let authenticationFlow):
            switch authenticationFlow {
            case .arrivedAtRegister:
                registerView
            case .arrivedAtLogin:
                loginView
            }
        case .arrivedAtMap:
            mapView
        }
    }
    
    //MARK: - onboarding
    @ViewBuilder
    func onboardingView() -> some View {
        OnboardingView() { result in
            if result {
                if case .arrivedAtMap = viewModel.coordinatorFlowState {
                    goToMapView()
                } else {
                    goToRegisterView()
                }
            }
        }
        .tag(CurrentView.onboarding)
    }
    
    //MARK: - authentication
    var loginView: some View {
        LoginView { result in
            viewModel.coordinatorFlowState = .arrivedAtAuthentication(.arrivedAtLogin)

            switch result {
            case .goToAuthenticationView:
                goToRegisterView()
            case .goToMapView:
                goToMapView()
            }
        }
        .tag(CurrentView.login)
    }
    
    var registerView: some View {
        RegisterView { result in
            
            viewModel.coordinatorFlowState = .arrivedAtAuthentication(.arrivedAtRegister)
           
            if result == false {
                goToLoginView()
            }
        }.tag(CurrentView.authentication)
    }
    
    //MARK: - mapView
    var mapView: some View {
        MapView() { result in
            viewModel.coordinatorFlowState = .arrivedAtMap
        }
        .tag(CurrentView.map)
    }
    
    
    //MARK: - navigationStack
    func goToOnboardingView() {
        navigationStackViewModel.push(onboardingView())
    }
    
    func goToRegisterView() {
        viewModel.coordinatorFlowState = .arrivedAtAuthentication(.arrivedAtRegister)
        navigationStackViewModel.push(registerView)
    }
    
    func goToLoginView() {
        viewModel.coordinatorFlowState = .arrivedAtAuthentication(.arrivedAtLogin)
        navigationStackViewModel.push(loginView)
    }
    
    func goToMapView() {
        viewModel.coordinatorFlowState = .arrivedAtMap
        navigationStackViewModel.push(mapView)
    }
    
    //MARK: - enums
    
    enum CurrentView: String {
        case onboarding
        case authentication
        case login
        case password
        case drivingVerification
        case drivingPending
        case drivingValidate
        case map
        case menu
        case account
        case changePassword
        case history
    }
    
}

//MARK: - preview
struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView()
    }
}
