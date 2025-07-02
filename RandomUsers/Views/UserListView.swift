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
                ForEach(viewModel.users, id: \.login.uuid) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        UserRowView(user: user)
                    }
                }
                .onDelete(perform: viewModel.deleteUser)
            }
            .navigationTitle("Users")
            .task {
                await viewModel.fetchUsers(count: 5)
            }
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
