//
//  LandscapeModifier.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

struct LandscapeModifier: ViewModifier {
    let height = UIScreen.main.bounds.width
    let width = UIScreen.main.bounds.height
    
    var isPad: Bool { // 1
        return height >= 768
    }

    var isRegularWidth: Bool { // 2
        return height >= 414
    }
    
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: width, height: height))
            .environment(\.horizontalSizeClass, isRegularWidth ? .regular: .compact) // 5
            .environment(\.verticalSizeClass, isPad ? .regular: .compact) // 6
    }
}
