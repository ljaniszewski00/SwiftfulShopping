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

    init(label: String, horizontalPadding: CGFloat = 30, color: Color = .ssDarkGray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack(spacing: horizontalPadding) {
            line
            Text(label)
                .font(.ssCallout)
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

struct LabelledDivider_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone 13 Pro Max", "iPhone 8"], id: \.self) { deviceName in
                LabelledDivider(label: "or use:")
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName) portrait")
            }
        }
    }
}
