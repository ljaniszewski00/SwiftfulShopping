//
//  SupabaseDatabaseManager.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 24/09/2022.
//

import Foundation
import Supabase

class SupabaseDatabaseManager: ObservableObject {
    static var client: SupabaseDatabaseManager = {
        SupabaseDatabaseManager()
    }()
    
    private init() {}
    
    func getUsers() async throws {
        let query = SupabaseManager.client
            .database
            .from(DatabaseTable.users.rawValue)
            .select()
        
        guard
            let response = try? await query.execute(),
            let profiles = try? response.decoded(to: [Profile].self)
        else {
            ErrorManager.shared.generateCustomError(errorType: .databaseManagerFetchUsersError)
            return
        }
    }
    
    private func encode(encodable: Encodable) throws -> Any {
        guard
            let data = try? JSONEncoder().encode(encodable),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        else {
            ErrorManager.shared.generateCustomError(errorType: .databaseManagerEncodingError)
            throw NSError()
        }
        
        return dictionary
    }
}

extension SupabaseDatabaseManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
