//
//  ErrorModal.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 07/08/2022.
//

import SwiftUI

fileprivate enum Constants {
    static let delay: DispatchTime = DispatchTime.now() + 3
    static let titleFontSize: CGFloat = 20
    static let descriptionFontSize: CGFloat = 16
    static let errorViewHeight: CGFloat = 80
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

    @ViewBuilder private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.errorModalInside)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 3)
                                .foregroundColor(.errorModalStroke)
                        }
                    VStack {
                        Text("\(customError.errorCode): \(customError.errorType.rawValue)")
                            .font(Font.system(size: Constants.titleFontSize, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        Text(customError.errorDescription)
                            .font(Font.system(size: Constants.descriptionFontSize, weight: .regular, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                .animation(.easeInOut(duration: 0.5))
                .transition(.offset(x: Constants.xAxisTransition,
                                    y: geometry.aboveScreenEdge))
                .frame(height: Constants.errorViewHeight)
                .padding(.horizontal)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        $isPresented.wrappedValue = false
                    }
                }
            }
        }
    }
}

private extension GeometryProxy {
    var aboveScreenEdge: CGFloat {
        -frame(in: .global).maxY
    }
}
