//
//  RandomUsersApp.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//

import SwiftUI

@main
struct RandomUsersApp: App {
    @StateObject private var viewModel = UserListViewModel()
    var body: some Scene {
        WindowGroup {
            UserListView()
                .environmentObject(viewModel)
        }
    }
}
