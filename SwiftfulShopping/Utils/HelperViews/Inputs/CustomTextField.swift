//
//  CustomTextField.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct CustomTextField: View {
    @State var isSecureField: Bool = false
    var textFieldProperty: String
    var textFieldImageName: String = ""
    var textFieldKeyboardType: UIKeyboardType = .default
    var textFieldSignsLimit: Int = 0
    @Binding var text: String
    @Binding var isFocusedParentView: Bool
    @FocusState private var isFocused: Bool
    
    @State private var showPassword = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 15) {
                    Group {
                        if !textFieldImageName.isEmpty {
                            Image(systemName: textFieldImageName)
                                .foregroundColor(isFocused ? .accentColor : .ssDarkGray)
                        }
                        
                        if !isSecureField {
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
                                .onChange(of: text) { [text] newValue in
                                    if newValue.count > textFieldSignsLimit && textFieldSignsLimit != 0 {
                                        self.text = text
                                    }
                                }
                            
                            if showPassword == false {
                                Button(action: {
                                    showPassword.toggle()
                                    isSecureField.toggle()
                                }, label: {
                                    Image(systemName: "eye.slash")
                                        .foregroundColor(.ssDarkGray)
                                })
                            }
                        } else {
                            SecureField("", text: $text)
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
                            
                            Button(action: {
                                showPassword.toggle()
                                isSecureField.toggle()
                            }, label: {
                                Image(systemName: "eye")
                                    .foregroundColor(.ssGray)
                            })
                        }
                        
                        if textFieldSignsLimit != 0 {
                            Text("\(text.count)/\(textFieldSignsLimit)")
                                .font(.caption)
                                .foregroundColor(isFocused ? .accentColor : .ssGray)
                        }
                    }
                    .focused($isFocused)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                .background(
                    Text(textFieldProperty)
                        .padding(.leading, 30)
                        .scaleEffect(text.isEmpty ? (isFocused ? 0.8 : 1) : (isFocused ? 0.8 : 0.8))
                        .offset(x: text.isEmpty ? (isFocused ? -30 : (textFieldImageName.isEmpty ? -30 : 0)) : -30, y: text.isEmpty ? (isFocused ? -23 : 0) : -23)
                        .foregroundColor(isFocused ? .accentColor : .ssDarkGray)
                    
                    , alignment: .leading
                )
                .padding(.horizontal)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(isFocused ? Color.accentColor : Color.ssGray)
                    .opacity(isFocused ? 1 : 0.5)
                    .frame(height: 1)
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .background(Color.ssGray.opacity(0.25))
            .cornerRadius(5)
        }
    }
}
