//
//  Font.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 28/08/2022.
//

import SwiftUI

extension Font {
    static let ssNavigationTitleFont = Font.system(.largeTitle, design: .rounded).bold()
    static let ssLargeTitle = Font.system(.largeTitle, design: .rounded)
    static let ssTitle1 = Font.system(.title, design: .rounded).bold()
    static let ssTitle2 = Font.system(size: 20, design: .rounded).bold()
    static let ssTitle3 = Font.system(size: 18, design: .rounded).weight(.semibold)
    static let ssCallout = Font.system(.callout, design: .rounded).weight(.semibold)
    
    static let ssHeadline = Font.system(.headline, design: .rounded)
    static let ssBody = Font.system(.body, design: .rounded)
    static let ssSubhead = Font.system(.subheadline, design: .rounded)
    static let ssFootnote = Font.system(.footnote, design: .rounded)
    static let ssCaption1 = Font.system(.caption, design: .rounded)
    static let ssCaption2 = Font.system(.caption2, design: .rounded)
    
    static let ssButton = Font.system(size: 16, weight: .bold, design: .rounded)
}
