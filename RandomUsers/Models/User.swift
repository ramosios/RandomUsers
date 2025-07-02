//
//  User.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//
import Foundation

struct UserResponse: Codable, Equatable {
    let results: [User]
}

struct User: Codable, Equatable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: Dob
    let registered: Registered
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

struct Name: Codable, Equatable {
    let title: String
    let first: String
    let last: String
}

struct Location: Codable, Equatable {
    struct Street: Codable, Equatable {
        let number: Int
        let name: String
    }

    struct Coordinates: Codable, Equatable {
        let latitude: String
        let longitude: String
    }

    struct Timezone: Codable, Equatable {
        let offset: String
        let description: String
    }

    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

enum Postcode: Codable, Equatable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Postcode value cannot be decoded"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        }
    }
}

struct Login: Codable, Equatable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct Dob: Codable, Equatable {
    let date: String
    let age: Int
}

struct Registered: Codable, Equatable {
    let date: String
    let age: Int
}

struct ID: Codable, Equatable {
    let name: String
    let value: String?
}

struct Picture: Codable, Equatable {
    let large: String
    let medium: String
    let thumbnail: String
}
