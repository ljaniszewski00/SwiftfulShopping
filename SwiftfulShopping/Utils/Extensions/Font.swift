//
//  Font.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 28/08/2022.
//

import SwiftUI

extension Font {
    static let ssNavigationTitleFont = Font.system(.largeTitle, design: .rounded).bold()
    static let ssTitle1 = Font.system(.title, design: .rounded).bold()
    static let ssTitle2 = Font.system(.title2, design: .rounded).bold()
    static let ssTitle3 = Font.system(.title3, design: .rounded).weight(.semibold)
    static let ssHeadline = Font.system(.headline, design: .rounded)
    static let ssBody = Font.system(.body, design: .rounded)
    static let ssCallout = Font.system(.callout, design: .rounded).weight(.semibold)
    static let ssSubhead = Font.system(.subheadline, design: .rounded)
    static let ssFootnote = Font.system(.footnote, design: .rounded)
    static let ssCaption1 = Font.system(.caption, design: .rounded)
    static let ssCaption2 = Font.system(.caption2, design: .rounded)
}
