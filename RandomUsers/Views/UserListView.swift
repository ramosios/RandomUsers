//
//  UserListView.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 02/07/25.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject private var viewModel: UserListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredUsers, id: \.login.uuid) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        UserRowView(user: user)
                    }
                    // checks if the user is the last in the list to load more users
                    .onAppear{
                        Task{
                            // Load more users when the last user appears
                            await viewModel.loadMoreUsersIfNeeded(currentUser: user)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteUser)
            }
            .navigationTitle("Users")
            .searchable(text: $viewModel.searchText, prompt: "Search by name or email")
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
