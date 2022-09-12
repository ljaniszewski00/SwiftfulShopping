//
//  ImagesCarouselView.swift
//  SwiftfulShopping
//

import SwiftUI

struct ImagesCarouselView<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content

    @State private var currentIndex: Int = 0
    @State private var stopSliding: Bool = false
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                HStack(spacing: 0) {
                    self.content
                        .onTapGesture {
                            stopSliding.toggle()
                        }
                        .onSwiped { direction in
                            stopSliding = true
                            switch direction {
                            case .left:
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            case .right:
                                if currentIndex < numberOfImages - 1 {
                                    currentIndex += 1
                                }
                            default:
                                break
                            }
                        }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
                .animation(.spring())
                .onReceive(self.timer) { _ in
                    if !stopSliding {
                        if self.currentIndex == self.numberOfImages - 1 {
                            self.currentIndex = 0
                        } else {
                            self.currentIndex += 1
                        }
                    }
                }
                
                HStack(spacing: 7) {
                    ForEach(0..<self.numberOfImages, id: \.self) { index in
                        Circle()
                            .frame(width: index == self.currentIndex ? 10 : 8,
                                 height: index == self.currentIndex ? 10 : 8)
                            .foregroundColor(index == self.currentIndex ? Color.accentColor : .ssWhite)
                            .overlay(Circle().stroke(Color.accentColor, lineWidth: 1))
                            .animation(.spring())
                    }
                }
                .padding()
            }
        }
    }
}

struct ImagesCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ImagesCarouselView(numberOfImages: 3) {
                Image("product_placeholder_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("product_placeholder_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("product_placeholder_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
    }
}
