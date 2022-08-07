//
//  ErrorModal.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

fileprivate enum Constants {
    static let delay: DispatchTime = DispatchTime.now() + 5
    static let textFontSize: CGFloat = 20
    static let errorViewHeight: CGFloat = 65
    static let xAxisTransition: CGFloat = 0
}

struct ErrorModal<T: View>: ViewModifier {

    let textError: String
    @Binding var isPresented: Bool

    // TODO: add error code, and change text accordingly
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> T) {
        _isPresented = isPresented
        textError = "Unknown Error"
    }

    func body(content: Content) -> some View {
        content
            .overlay(popupContent())
    }

    func hideBarWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: Constants.delay) {
            $isPresented.wrappedValue = false
        }
    }

    @ViewBuilder private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented {
                Color.accentColor
                    .overlay(
                        Text(textError)
                            .font(Font.system(size: Constants.textFontSize, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    )
                    .animation(.easeInOut(duration: 0.5))
                    .transition(.offset(x: Constants.xAxisTransition, y: geometry.aboveScreenEdge))
                    .frame(width: geometry.size.width, height: Constants.errorViewHeight)
                    .onAppear(perform: hideBarWithDelay)
            }
        }
    }
}

private extension GeometryProxy {
    var aboveScreenEdge: CGFloat {
        -frame(in: .global).maxY
    }
}
