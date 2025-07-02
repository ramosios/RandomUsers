//
//  UserRowView.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 02/07/25.
//
import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: user.picture.large)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(user.phone)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
