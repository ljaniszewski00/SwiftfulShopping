//
//  RectangleCustomTextField.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 26/06/2022.
//

import SwiftUI

struct RectangleCustomTextField: View {
    @State var isSecureField: Bool = false
    var textFieldProperty: String
    var textFieldKeyboardType: UIKeyboardType = .default
    var textFieldFooter: String = ""
    @Binding var text: String
    @Binding var isFocusedParentView: Bool
    @FocusState private var isFocused: Bool
    
    @State private var showPassword = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(textFieldProperty)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.accentColor)
            TextField("", text: $text)
                .keyboardType(textFieldKeyboardType)
                .onTapGesture {
                    withAnimation(.easeIn) {
                        isFocusedParentView = true
                        isFocused = true
                    }
                }
                .onSubmit {
                    withAnimation(.easeOut) {
                        isFocused = false
                        isFocusedParentView = false
                    }
                }
                .focused($isFocused)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: isFocused ? 2 : 1)
                        .foregroundColor(isFocused ? .accentColor : .ssDarkGray)
                }
            if !textFieldFooter.isEmpty {
                Text(textFieldFooter)
                    .font(.system(size: 15))
                    .foregroundColor(.ssGray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct RectangleCustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCustomTextField(textFieldProperty: "First Name", text: .constant(""), isFocusedParentView: .constant(true))
    }
}
