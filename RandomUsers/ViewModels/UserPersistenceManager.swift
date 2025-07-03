//
//  UserPersistenceManager.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//

import Foundation
import RealmSwift

class UserPersistenceManager {
    private let realm: Realm
    
    init() throws {
        do {
            self.realm = try Realm()
        } catch {
            throw UserPersistenceRealmError.realmInitFailed(error)
        }
    }
    
    func save(users: [User]) throws {
        let filteredUsers = filterOutExceptions(newUsers: users)
        let userObjects = filteredUsers.map { UserObject(from: $0) }
        do {
            try realm.write {
                realm.add(userObjects, update: .modified)
            }
        } catch {
            throw UserPersistenceRealmError.realmWriteFailed(error)
        }
    }

    func load() -> [User] {
        let userObjects = realm.objects(UserObject.self)
        return userObjects.map { $0.toUser() }
    }

    func delete(user: User) throws {
        if let userObject = realm.object(ofType: UserObject.self, forPrimaryKey: user.login.uuid) {
            do {
                try realm.write {
                    realm.delete(userObject)
                    let deletedUser = DeletedUserObject()
                    deletedUser.id = user.login.uuid
                    realm.add(deletedUser, update: .modified)
                }
            } catch {
                throw UserPersistenceRealmError.realmWriteFailed(error)
            }
        } else {
            throw UserPersistenceRealmError.userNotFound
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

enum UserPersistenceRealmError: Error, Equatable {
    case realmInitFailed(Error)
    case realmWriteFailed(Error)
    case userNotFound
    
    public static func == (lhs: UserPersistenceRealmError, rhs: UserPersistenceRealmError) -> Bool {
        switch (lhs, rhs) {
        case (.userNotFound, .userNotFound): return true
        case (.realmInitFailed, .realmInitFailed): return true
        case (.realmWriteFailed, .realmWriteFailed): return true
        default: return false
        }
    }
}
