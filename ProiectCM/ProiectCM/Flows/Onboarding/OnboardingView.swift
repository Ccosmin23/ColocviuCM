//
//  OnboardingView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    var onFinished: (Bool) -> Void

    var body: some View {
            ScrollView {
                TabView(selection: $viewModel.selectedTab) {
                    ForEach(Onboarding.pages, id: \.self) { page in
                        OnboardingCurrentView(page: page) { result in
                            onFinished(result)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .overlay(baseContent, alignment: .bottom)
            .ignoresSafeArea(.all)
    }
    
    var baseContent: some View {
        HStack {
            PageNavigationView(numberOfPages: 5, currentIndex: viewModel.selectedTab.index)
            Spacer()
            viewModel.selectedTab.index == Onboarding.pages.last?.index ? AnyView(getStartedButton) : AnyView(nextButton)
        }
        .padding(.bottom)
        .padding(.horizontal, 30)
    }
    
    var getStartedButton: some View {
        Button {
            DispatchQueue.main.async {
                onFinished(true)
            }
        } label: {
            CustomButton(width: 153,
                         height: 56,
                         text: "Get started",
                         icon: Image("forwardButtonWhite"),
                         textColor: Color.white,
                         background: Color.cerise,
                         strokeColor: Color.cerise)
        }
    }
    
    var nextButton: some View {
        Button {
            viewModel.changeToNextTab()
        } label: {
            CustomButton(width: 100,
                         height: 56,
                         text: "Next",
                         textColor: Color.white,
                         background: Color.cerise,
                         strokeColor: Color.cerise)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView { result in
            }
        }
    }
}


/// struct below is used for each page from Onboarding.pages list
struct OnboardingCurrentView: View {
    let page: Onboarding
    var onFinished: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            baseImage
            VStack(alignment: .leading, spacing: 0) {
                titleAndSkip
                description
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    var baseImage: some View {
        Image(page.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    var title: some View {
        Text(page.title)
            .font(Font.Primary.bold.with(size: 32))
            .foregroundColor(Color.russianViolet)
    }
    
    var description: some View {
        Text(page.description)
            .font(.Primary.regular.with(size: 16))
            .foregroundColor(Color.russianViolet)
            .padding(.top, 5)
    }
    
    var titleAndSkip: some View {
        HStack {
            title
            Spacer()
            skipButton
        }
    }
    
    var skipButton: some View {
        Button(action: {
            DispatchQueue.main.async {
                onFinished(true)
            }
        }, label: {
            Text("Skip")
                .font(Font.Primary.regular.with(size: 14))
                .foregroundColor(Color.heliotropeGray)
                .background(Color.white)
        })
    }
}


