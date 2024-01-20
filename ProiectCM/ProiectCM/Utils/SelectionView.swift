//
//  CustomView.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import SwiftUI

 struct SelectionView<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {
    var selectionValue: Binding<SelectionValue>?    
    
    init(selection: Binding<SelectionValue>?, @ViewBuilder content:  @escaping () -> Content) {
        self.selectionValue = selection
        self.content = content
    }
    
    @ViewBuilder var content:() -> Content
    var body: some View {
        return content()
    }
}
