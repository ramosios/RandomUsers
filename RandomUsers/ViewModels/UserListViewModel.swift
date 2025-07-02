//
//  UserListViewModel.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//
import Foundation

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    private var persistenceManager: UserPersistenceManager?
    
    init() {
        do {
            self.persistenceManager = try UserPersistenceManager()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchUsers(count: Int) async {
        guard let persistenceManager = persistenceManager else {
            errorMessage = "Persistence manager not initialized."
            return
        }
        do {
            let fetchedUsers = try await RandomUserService().fetchRandomUsersGrouped(numberOfUsers: count)
            try persistenceManager.save(users: fetchedUsers)
            users = persistenceManager.load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
