//
//  LottieView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 08/08/2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var paused: Bool = false
    var shouldPlay: Bool = true
    
    var animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = Animation.named(name)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        if shouldPlay {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if shouldPlay {
            context.coordinator.parent.animationView.play { finished in
                if context.coordinator.parent.animationView.loopMode == .playOnce && finished {
                    context.coordinator.parent.animationView.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        context.coordinator.parent.animationView.pause()
                    }
                }
            }
        } else {
            context.coordinator.parent.animationView.pause()
        }
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

    class Coordinator: NSObject {
        var parent: LottieView

        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
}
