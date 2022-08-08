//
//  ErrorModal.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

fileprivate enum Constants {
    static let delay: DispatchTime = DispatchTime.now() + 5
    static let titleFontSize: CGFloat = 20
    static let descriptionFontSize: CGFloat = 16
    static let errorViewHeight: CGFloat = 65
    static let xAxisTransition: CGFloat = 0
}

struct ErrorModal: ViewModifier {

    var customError: CustomError
    @Binding var isPresented: Bool

    // TODO: add error code, and change text accordingly
    init(isPresented: Binding<Bool>, customError: CustomError) {
        _isPresented = isPresented
        self.customError = customError
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
                        VStack {
                            Text("\(customError.errorCode): \(customError.errorType.rawValue)")
                                .font(Font.system(size: Constants.titleFontSize, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text(customError.errorDescription)
                                .font(Font.system(size: Constants.descriptionFontSize, weight: .regular, design: .rounded))
                                .foregroundColor(.white)
                        }
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
