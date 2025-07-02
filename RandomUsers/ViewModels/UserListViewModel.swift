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
    private let persistenceManager = UserPersistenceManager()
    func fetchUsers(count: Int) async {
        do {
            let fetchedUsers = try await RandomUserService().fetchRandomUsersGrouped(numberOfUsers: count)
            persistenceManager.save(users: fetchedUsers)
            users = persistenceManager.load()
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
