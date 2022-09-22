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
    static let textTopPadding: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 40) + 20
    static let errorViewHeight: CGFloat = 80
    static let xAxisTransition: CGFloat = 0
    static let yAxisTransition: CGFloat = -UIScreen.main.bounds.height
}

struct ErrorModal: ViewModifier {

    var customError: CustomError
    @Binding var isPresented: Bool
    
    @State private var stopModalDisappear: Bool = false
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var secondsElapsed: Int = 0
    private let secondsToElapseToModalDisappear: Int = 4

    // TODO: add error code, and change text accordingly
    init(isPresented: Binding<Bool>, customError: CustomError) {
        _isPresented = isPresented
        self.customError = customError
    }

    func body(content: Content) -> some View {
        content
            .overlay(popupContent(), alignment: .top)
    }

    @ViewBuilder private func popupContent() -> some View {
        if isPresented {
            ZStack {
                Rectangle()
                    .foregroundColor(.errorModalInside)
                    .background {
                        Rectangle()
                            .stroke(lineWidth: 3)
                            .foregroundColor(.errorModalStroke)
                    }
                VStack(alignment: .center, spacing: 10) {
                    Text(customError.errorType.rawValue)
                        .font(Font.system(size: Constants.titleFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text(customError.errorDescription)
                        .font(Font.system(size: Constants.descriptionFontSize, weight: .regular, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.black)
                }
                .padding()
                .padding(.top, Constants.textTopPadding)
            }
            .animation(.easeInOut(duration: 0.5))
            .transition(.offset(x: Constants.xAxisTransition,
                                y: Constants.yAxisTransition))
            .frame(height: Constants.errorViewHeight)
            .onTapGesture {
                stopModalDisappear.toggle()
                secondsElapsed = 0
                if stopModalDisappear {
                    timer.upstream.connect().cancel()
                } else {
                    timer = timer.upstream.autoconnect()
                }
            }
            .onSwiped { direction in
                if direction == .up {
                    DispatchQueue.main.async {
                        withAnimation {
                            $isPresented.wrappedValue = false
                        }
                    }
                }
            }
            .onReceive(timer) { _ in
                secondsElapsed += 1
                if secondsElapsed == secondsToElapseToModalDisappear && !stopModalDisappear {
                    timer.upstream.connect().cancel()
                    DispatchQueue.main.async {
                        withAnimation {
                            $isPresented.wrappedValue = false
                        }
                    }
                }
            }
            .onDisappear {
                secondsElapsed = 0
                stopModalDisappear = false
            }
        }
    }
}
