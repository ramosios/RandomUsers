//
//  UserPersistenceManager.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//

import Foundation
import RealmSwift

class UserPersistenceManager {
    private let realm = try! Realm()
    
    func save(users: [User]) {
        // Before saving filter out duplicates
        let filteredUsers = filterOutExceptions(newUsers: users)
        let userObjects = filteredUsers.map { UserObject(from: $0) }
        try? realm.write {
            realm.add(userObjects, update: .modified)
        }
    }

    func load() -> [User] {
        let userObjects = realm.objects(UserObject.self)
        return userObjects.map { $0.toUser() }
    }

    func delete(user: User) {
        if let userObject = realm.object(ofType: UserObject.self, forPrimaryKey: user.login.uuid) {
                try? realm.write {
                    realm.delete(userObject)
                    // Save deleted user uuid to avoid adding it again in the future
                    let deletedUser = DeletedUserObject()
                    deletedUser.id = user.login.uuid
                    realm.add(deletedUser, update: .modified)
            }
        }
    }
    private func filterOutExceptions(newUsers: [User]) -> [User] {
        let savedIds = Set(load().map { $0.login.uuid })
        let deletedIds = Set(realm.objects(DeletedUserObject.self).map { $0.id })
        var seenIds = savedIds
        var uniqueUsers = [User]()

        for user in newUsers {
            let id = user.login.uuid
            if !deletedIds.contains(id) && !seenIds.contains(id) {
                uniqueUsers.append(user)
                seenIds.insert(id)
            }
        }
        return uniqueUsers
    }
}

enum UserPersistenceError: Error {
    case encodingFailed
    case decodingFailed
    case coreDataSaveFailed(Error)
    case coreDataFetchFailed(Error)
    case userNotFound
}
