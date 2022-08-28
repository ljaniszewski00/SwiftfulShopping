//
//  LabelledDivider.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 02/04/2022.
//

import SwiftUI

struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .ssGray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack {
            Divider().background(color)
        }
    }
}
