//
//  OTPTextField.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 21.09.2021.
//


import SwiftUI
import Introspect

/// OTPTextField is used for unlock scooter via code
struct OTPTextFieldView: View {
    var maxDigits: Int = 4
    @State var pin: String = ""
    @State var isDisabled = false
    var onFinish: (String?) -> Void
    
    public var body: some View {
        VStack(spacing: 20) {
            ZStack {
                pinDots
                backgroundField
            }
        }
    }
    
    private var pinDots: some View {
        HStack(spacing:14) {
            ForEach(0..<maxDigits) { index in
                ZStack {
                    Rectangle()
                        .font(Font.Primary.medium.with(size: 20))
                        .foregroundColor(self.getDigits(at: index).isEmpty ? Color.heliotropeGray : Color.white)
                        .frame(width: 52, height: 52)
                        .cornerRadius(15)
                    Text(self.getDigits(at: index))
                        .font(Font.Primary.medium.with(size: 20))
                        .foregroundColor(Color.russianViolet)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .introspectTextField { textField in
                textField.becomeFirstResponder()
            }
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .foregroundColor(.clear)
            .accentColor(.clear)
    }
    
    
    
    private func submitPin() {
        guard !pin.isEmpty else {
            return
        }
        if pin.count == maxDigits {
            onFinish(pin)
        }
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getDigits(at index: Int) -> String {
        if index >= self.pin.count {
            return ""
        }
        return self.pin.digits[index].numberString
    }
}

extension String {
    var digits: [Int] {
        var result = [Int]()
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
}

extension Int {
    var numberString: String {
        guard self < 10 else { return "0" }
        return String(self)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct OTPTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextFieldView { result in
        }
    }
}
