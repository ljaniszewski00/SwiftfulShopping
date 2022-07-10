//
//  CheckmarkToggleStyle.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 03/04/2022.
//

import SwiftUI

struct CheckMarkToggleStyle: ToggleStyle {
    var label = ""
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 22, height: 22)
        })
    }
}
