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
        let filteredUsers = filterOutDuplicates(newUsers: users)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filteredUsers) {
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
    // This function will be used for ensuring there are no duplicate users in memory
    private func filterOutDuplicates(newUsers: [User]) -> [User] {
        let savedUsers = load()
        var seenIds = Set<String>()
        var uniqueUsers = [User]()

        if savedUsers.isEmpty {
            // If there are no saved users just remove duplicates from incoming users
            for user in newUsers {
                guard let id = user.id.value else { continue }
                if !seenIds.contains(id) {
                    uniqueUsers.append(user)
                    seenIds.insert(id)
                }
            }
        } else {
            // If there are saved users compare both list to find unique users
            let savedIds = Set(savedUsers.compactMap { $0.id.value })
            for user in newUsers {
                guard let id = user.id.value else { continue }
                if !savedIds.contains(id) && !seenIds.contains(id) {
                    uniqueUsers.append(user)
                    seenIds.insert(id)
                }
            }
        }
        return uniqueUsers
    }
}
