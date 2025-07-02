//
//  UserObjectRealm.swift
//  RandomUsers
//
//  Created by Jorge Ramos on 01/07/25.
//
import RealmSwift

class UserObject: Object {
    @Persisted(primaryKey: true) var id: String 
    @Persisted var gender: String
    @Persisted var title: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var streetName: String
    @Persisted var streetNumber: Int
    @Persisted var city: String
    @Persisted var state: String
    @Persisted var country: String
    @Persisted var postcode: String
    @Persisted var latitude: String
    @Persisted var longitude: String
    @Persisted var timezoneOffset: String
    @Persisted var timezoneDescription: String
    @Persisted var email: String
    @Persisted var username: String
    @Persisted var password: String
    @Persisted var salt: String
    @Persisted var md5: String
    @Persisted var sha1: String
    @Persisted var sha256: String
    @Persisted var dobDate: String
    @Persisted var dobAge: Int
    @Persisted var registeredDate: String
    @Persisted var registeredAge: Int
    @Persisted var phone: String
    @Persisted var cell: String
    @Persisted var idName: String
    @Persisted var idValue: String?
    @Persisted var pictureLarge: String
    @Persisted var pictureMedium: String
    @Persisted var pictureThumbnail: String
    @Persisted var nat: String
}

extension UserObject {
    convenience init(from user: User) {
        self.init()
        self.id = user.login.uuid
        self.gender = user.gender
        self.title = user.name.title
        self.firstName = user.name.first
        self.lastName = user.name.last
        self.streetName = user.location.street.name
        self.streetNumber = user.location.street.number
        self.city = user.location.city
        self.state = user.location.state
        self.country = user.location.country
        // Convert postcode to string for storage
        switch user.location.postcode {
        case .int(let intValue):
            self.postcode = String(intValue)
        case .string(let stringValue):
            self.postcode = stringValue
        }
        self.latitude = user.location.coordinates.latitude
        self.longitude = user.location.coordinates.longitude
        self.timezoneOffset = user.location.timezone.offset
        self.timezoneDescription = user.location.timezone.description
        self.email = user.email
        self.username = user.login.username
        self.password = user.login.password
        self.salt = user.login.salt
        self.md5 = user.login.md5
        self.sha1 = user.login.sha1
        self.sha256 = user.login.sha256
        self.dobDate = user.dob.date
        self.dobAge = user.dob.age
        self.registeredDate = user.registered.date
        self.registeredAge = user.registered.age
        self.phone = user.phone
        self.cell = user.cell
        self.idName = user.id.name
        self.idValue = user.id.value
        self.pictureLarge = user.picture.large
        self.pictureMedium = user.picture.medium
        self.pictureThumbnail = user.picture.thumbnail
        self.nat = user.nat
    }

    func toUser() -> User {
        return User(
            gender: self.gender,
            name: Name(title: self.title, first: self.firstName, last: self.lastName),
            location: Location(
                street: Location.Street(number: self.streetNumber, name: self.streetName),
                city: self.city,
                state: self.state,
                country: self.country,
                postcode: Postcode.string(self.postcode),
                coordinates: Location.Coordinates(latitude: self.latitude, longitude: self.longitude),
                timezone: Location.Timezone(offset: self.timezoneOffset, description: self.timezoneDescription)
            ),
            email: self.email,
            login: Login(
                uuid: self.id,
                username: self.username,
                password: self.password,
                salt: self.salt,
                md5: self.md5,
                sha1: self.sha1,
                sha256: self.sha256
            ),
            dob: Dob(date: self.dobDate, age: self.dobAge),
            registered: Registered(date: self.registeredDate, age: self.registeredAge),
            phone: self.phone,
            cell: self.cell,
            id: ID(name: self.idName, value: self.idValue),
            picture: Picture(large: self.pictureLarge, medium: self.pictureMedium, thumbnail: self.pictureThumbnail),
            nat: self.nat
        )
    }
}
class DeletedUserObject: Object {
    @Persisted(primaryKey: true) var id: String
}
