//
//  ProductAvailabilityIndicator.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 13/11/2022.
//

import SwiftUI
import texterify_ios_sdk

struct ProductAvailabilityIndicator: View {
    var availability: Availability
    var font: Font = .ssCaption1
    var fontColor: Color = .ssDarkGray
    
    var body: some View {
        HStack(spacing: 10) {
            switch availability {
            case .large:
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 13)
                Text(TexterifyManager.localisedString(key: .availability(.large)))
                    .font(font)
                    .foregroundColor(fontColor)
            case .small:
                Circle()
                    .foregroundColor(.yellow)
                    .frame(width: 13)
                Text(TexterifyManager.localisedString(key: .availability(.small)))
                    .font(font)
                    .foregroundColor(fontColor)
            case .no:
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 13)
                Text(TexterifyManager.localisedString(key: .availability(.no)))
                    .font(font)
                    .foregroundColor(fontColor)
            }
        }
    }
}

struct ProductAvailabilityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProductAvailabilityIndicator(availability: .no)
    }
}
