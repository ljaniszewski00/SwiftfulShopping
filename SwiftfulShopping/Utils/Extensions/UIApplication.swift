//
//  UIApplication.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 14/08/2022.
//

import SwiftUI

extension UIApplication {
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: Constants.CFBundleShortVersionString) as! String
    }
  
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
  
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
      
        return version == build ? "App Version: \(version)" : "App Version: \(version) (\(build))"
    }
}
