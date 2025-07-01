//
//  RandomUserService.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//
import Foundation
struct RandomUserService {
    private let baseURL = "https://randomuser.me/api/"
    func fetchRandomUsersGrouped(numberOfUsers: Int) async throws -> [User] {
        let urlString = "\(baseURL)?results=\(numberOfUsers)"
        guard let url = URL(string: urlString) else {
            throw UserAPIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw UserAPIError.requestFailed
        }
        do {
            let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
            return userResponse.results
        }
        catch {
            throw UserAPIError.decodingFailed
        }
    }
        
    
}

enum UserAPIError: Error, LocalizedError, Equatable {
    case invalidURL
    case requestFailed
    case decodingFailed
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid User API URL."
        case .requestFailed: return "Request to User API failed."
        case .decodingFailed: return "Failed to decode User API response."
        case .serverError(let message): return "User API error: \(message)"
        }
    }
}
