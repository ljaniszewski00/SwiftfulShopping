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
    var unitsAvailable: Int?
    var font: Font = .ssCaption1
    var fontColor: Color = .ssDarkGray
    var showAvailableUnitsText: Bool = false
    
    var circleColor: Color {
        switch availability {
        case .large:
            return .green
        case .small:
            return .yellow
        case .no:
            return .red
        }
    }
    
    var availabilityText: String {
        switch availability {
        case .large:
            return TexterifyManager.localisedString(key: .availability(.large))
        case .small:
            return TexterifyManager.localisedString(key: .availability(.small))
        case .no:
            return TexterifyManager.localisedString(key: .availability(.no))
        }
    }
    
    var availableUnitsText: String {
        if let unitsAvailable = unitsAvailable {
            return "\(unitsAvailable) \(TexterifyManager.localisedString(key: .availabilityIndicator(.unitsAvailable)))"
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 10) {
                Circle()
                    .foregroundColor(circleColor)
                    .frame(width: 13)
                Text(availabilityText)
            }
            
            if showAvailableUnitsText {
                Text(availableUnitsText)
            }
        }
        .font(font)
        .foregroundColor(fontColor)
    }
}

struct ProductAvailabilityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProductAvailabilityIndicator(availability: .large,
                                     unitsAvailable: 50,
                                     font: .ssCallout,
                                     showAvailableUnitsText: true)
    }
}
