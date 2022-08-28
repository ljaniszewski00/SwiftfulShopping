//
//  ScrollView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 28/08/2022.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }

    typealias Value = CGPoint

}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGPoint

    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let minX = proxy.frame(in: .named(coordinateSpace)).minX
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self,
                                       value: CGPoint(x: minX * -1, y: minY * -1))
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

extension View {
    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGPoint>) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}
