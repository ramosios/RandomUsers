//
//  ContentView.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserListViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await viewModel.fetchUsers(count: 5)
        }
        .onChange(of: viewModel.users) {
            for user in viewModel.users {
                print("\(user.name.first) \(user.name.last) - \(user.email)")
            }
        }
    }
}

#Preview {
    ContentView()
}
