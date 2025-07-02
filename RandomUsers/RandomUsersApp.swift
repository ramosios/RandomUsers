//
//  RandomUsersApp.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//

import SwiftUI

@main
struct RandomUsersApp: SwiftUI.App {
    @StateObject private var viewModel = UserListViewModel()
    private let persistenceManager = try? UserPersistenceManager()

    var body: some Scene {
        WindowGroup {
            UserListView()
                .environmentObject(viewModel)
                .task {
                    if let savedUsers = persistenceManager?.load(), savedUsers.isEmpty {
                        await viewModel.fetchUsers(count: 20)
                    } else if let savedUsers = persistenceManager?.load() {
                        viewModel.users = savedUsers
                    }
                }
        }
    }
}
