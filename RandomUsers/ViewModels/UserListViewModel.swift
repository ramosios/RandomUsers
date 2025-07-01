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

    func fetchUsers(count: Int) async {
        do {
            users = try await RandomUserService().fetchRandomUsersGrouped(numberOfUsers: count)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
