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
    @Published var searchText: String = ""
    private var persistenceManager: UserPersistenceManager?
    private var isLoadingMore = false
    // Search results based on the search text
    var filteredUsers: [User] {
        guard !searchText.isEmpty else { return users }
        let lowercased = searchText.lowercased()
        return users.filter {
                $0.name.first.lowercased().contains(lowercased) ||
                $0.name.last.lowercased().contains(lowercased) ||
                $0.email.lowercased().contains(lowercased)
        }
    }
    
    init() {
        do {
            self.persistenceManager = try UserPersistenceManager()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    // Called on first install or when saved users are empty
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
    func deleteUser(at offsets: IndexSet) {
        guard let persistenceManager = persistenceManager else { return }
        for index in offsets {
            let user = users[index]
            do {
                try persistenceManager.delete(user: user)
                users.remove(at: index)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    // Called when the last user in the list is displayed
    func loadMoreUsersIfNeeded(currentUser: User) async {
         guard !isLoadingMore,
               let lastUser = filteredUsers.last,
               currentUser.login.uuid == lastUser.login.uuid else { return }
         isLoadingMore = true
         await fetchUsers(count: 10)
         isLoadingMore = false
     }
 
}
