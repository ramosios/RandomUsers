//
//  UserDetailView.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 02/07/25.
//
import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user.picture.large)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 8)
                
                Text("\(user.name.first) \(user.name.last)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(user.gender.capitalized)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "envelope")
                        Text(user.email)
                    }
                    HStack {
                        Image(systemName: "location")
                        Text("\(user.location.street.name) \(user.location.street.number), \(user.location.city), \(user.location.state)")
                    }
                    HStack {
                        Image(systemName: "calendar")
                        Text("Registered: \(formattedDate(user.registered.date))")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
                Spacer()
            }
            .padding()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
