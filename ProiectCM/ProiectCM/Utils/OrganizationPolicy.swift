//
//  PrivacyAndPolicy.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 27.09.2021.
//

import SwiftUI
import SafariServices

struct OrganizationPolicy: UIViewControllerRepresentable {
    let url: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<OrganizationPolicy>) -> SFSafariViewController {
        let controller = SFSafariViewController(url: URL(string: self.url)!)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<OrganizationPolicy>) {
    }
}

struct OrganizationPolicy_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationPolicy(url: "https://tapptitude.com/privacy-policy/")
    }
}
