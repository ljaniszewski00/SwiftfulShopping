//
//  ConditionalViewModifiers.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 01/04/2022.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
