//
//  Constants.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/09/2022.
//

import Foundation

public struct AppConstants {
    static let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "Supabase key") as? String
    static let supabaseProjectKey = Bundle.main.object(forInfoDictionaryKey: "Supabase project key") as? String
}
