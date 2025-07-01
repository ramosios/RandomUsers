//
//  User.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//
struct UserResponse: Decodable {
    let results: [User]
}

struct User: Decodable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: String
    let registered: String
    let phone: String
    let cell: String
    let id: ID
    let picture: Picture
    let nat: String
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Location: Decodable {
    struct Street: Decodable {
        let number: Int
        let name: String
    }
    let street: Street
    let city: String
    let state: String
    let postcode: Postcode
}
// Since postcode can be either an Int or a String, we use an enum to handle both cases.
enum Postcode: Decodable {
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
}

struct Login: Decodable {
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct ID: Decodable {
    let name: String
    let value: String?
}

struct Picture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
