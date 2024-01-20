//
//  OnboardingViewModel.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var selectedTab = Onboarding.page1
    @Published var pages = Onboarding.pages
    @Published var index = 0
    
    func changeToNextTab() {
        if self.selectedTab.index < 5 {
            self.selectedTab.index += 1
            self.selectedTab = Onboarding.pages[self.selectedTab.index]
        }
    }
}
