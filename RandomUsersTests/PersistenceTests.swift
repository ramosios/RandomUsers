import Foundation
import RealmSwift
import XCTest
@testable import RandomUsers

final class PersistenceTests: XCTestCase {
    var manager: UserPersistenceManager!
    var realm: Realm!

    override func setUpWithError() throws {
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        realm = try Realm(configuration: config)
        manager = try UserPersistenceManager()
    }

    override func tearDownWithError() throws {
        try realm.write { realm.deleteAll() }
        manager = nil
        realm = nil
    }

    func makeTestUser(id: String = UUID().uuidString, name: String = "Test") -> RandomUsers.User {
        return RandomUsers.User(
            gender: "male",
            name: RandomUsers.Name(title: "Mr", first: name, last: "User"),
            location: RandomUsers.Location(
                street: RandomUsers.Location.Street(number: 1, name: "Test St"),
                city: "Testville",
                state: "TS",
                country: "Testland",
                postcode: RandomUsers.Postcode.string("00000"),
                coordinates: RandomUsers.Location.Coordinates(latitude: "0", longitude: "0"),
                timezone: RandomUsers.Location.Timezone(offset: "+0:00", description: "Test")
            ),
            email: "test@example.com",
            login: RandomUsers.Login(uuid: id, username: "testuser", password: "password", salt: "salt", md5: "md5", sha1: "sha1", sha256: "sha256"),
            dob: RandomUsers.Dob(date: "2000-01-01T00:00:00Z", age: 20),
            registered: RandomUsers.Registered(date: "2020-01-01T00:00:00Z", age: 1),
            phone: "1234567890",
            cell: "0987654321",
            id: RandomUsers.ID(name: "ID", value: id),
            picture: RandomUsers.Picture(large: "", medium: "", thumbnail: ""),
            nat: "US"
        )
    }

    func testSaveAndLoadUsers() throws {
        let user = makeTestUser()
        try manager.save(users: [user])
        let loaded = manager.load()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.login.uuid, user.login.uuid)
    }

    func testDeleteUser() throws {
        let user = makeTestUser()
        try manager.save(users: [user])
        try manager.delete(user: user)
        let loaded = manager.load()
        XCTAssertTrue(loaded.isEmpty)
    }

    func testDeleteNonexistentUserThrows() throws {
        let user = makeTestUser()
        XCTAssertThrowsError(try manager.delete(user: user)) { error in
            guard let err = error as? UserPersistenceRealmError else { return XCTFail() }
            XCTAssertEqual(err, .userNotFound)
        }
    }

    func testSaveFiltersDeletedUsers() throws {
        let user = makeTestUser()
        try manager.save(users: [user])
        try manager.delete(user: user)
        try manager.save(users: [user])
        let loaded = manager.load()
        XCTAssertTrue(loaded.isEmpty)
    }
}
