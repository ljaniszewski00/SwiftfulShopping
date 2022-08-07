//
//  LoadingIndicatorModal.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

struct LoadingIndicatorModal: ViewModifier {

    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

    func body(content: Content) -> some View {
        content
            .disabled(isPresented)
            .overlay(popupContent())
    }

    @ViewBuilder private func popupContent() -> some View {
        if isPresented {
            ZStack {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
        }
    }
}
