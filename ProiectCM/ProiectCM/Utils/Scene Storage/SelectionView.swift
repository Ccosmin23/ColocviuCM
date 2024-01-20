//
//  CustomView.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 11.09.2021.
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
