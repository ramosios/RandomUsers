//
//  UserPersistenceManager.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//

import Foundation

class UserPersistenceManager {
    private let usersKey = "savedUsers"
    
    func save(users: [User]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(users) {
            UserDefaults.standard.set(encoded, forKey: usersKey)
        }
    }
    
    func load() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([User].self, from: data)) ?? []
    }
    
    func delete(user: User) {
        var users = load()
        users.removeAll { $0 == user }
        save(users: users)
    }
    // O(n) algorithm to filter out duplicates based on user ID
    func filterOutDuplicates(newUsers: [User]) -> [User] {
        var seenIds = Set<String>()
        var uniqueUsers = [User]()
        for user in newUsers {
            if let id = user.id.value, !seenIds.contains(id) {
                uniqueUsers.append(user)
                seenIds.insert(id)
            }
        }
        return uniqueUsers
    }
}
