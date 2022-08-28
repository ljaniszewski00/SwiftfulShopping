//
//  MeasureViewSize.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 28/08/2022.
//

import SwiftUI

struct MeasureSizeModifier: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content.background(GeometryReader { geometry in
            Color.clear
                .onAppear {
                    size = geometry.size
                }
        })
    }
}

extension View {
    func measureSize(size: Binding<CGSize>) -> some View {
        self.modifier(MeasureSizeModifier(size: size))
    }
}
