//
//  SupabaseManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 18/09/2022.
//

import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static var client: SupabaseClient = {
        SupabaseClient(supabaseURL: URL(string: "https://gzznjjcbmjttcwrojlxo.supabase.co")!,
                                                           supabaseKey: AppConstants.supabaseKey!)
    }()
    
    private init() {}
}

extension SupabaseManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
