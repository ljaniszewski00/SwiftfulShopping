//
//  TexterifyManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 30/10/2022.
//

import Foundation
import texterify_ios_sdk

extension TexterifyManager {
    static let bundleName = "TexterifyLocalization.bundle"
    static var customBundle = Bundle.main
    
    public static func localisedString(key: Localizable) -> String {
        if let localizationBundle = Bundle(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(bundleName)") {
            return NSLocalizedString(key.rawValue, tableName: nil, bundle: localizationBundle, value: "", comment: "")
        } else {
            return customBundle.localizedString(forKey: key.rawValue, value: "", table: nil)
        }
    }
}
