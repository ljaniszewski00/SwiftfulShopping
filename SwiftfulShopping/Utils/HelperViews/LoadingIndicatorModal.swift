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
            .allowsHitTesting(!isPresented)
            .blur(radius: isPresented ? 3 : 0)
            .overlay(popupContent())
    }

    @ViewBuilder private func popupContent() -> some View {
        if isPresented {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                .scaleEffect(1.5)
                .transition(.move(edge: .bottom))
                .animation(.default.speed(1))
        }
    }
}
