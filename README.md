# Random User

An iOS app for browsing Random Users from (https://randomuser.me) API 
## 🛠 Installation
1. Clone the repository.
2. Open `RandomUsers.xcodeproj` in Xcode.
3. Make sure [RealmSwift](https://realm.io/docs/swift/latest/) is added via Swift Package Manager (SPM) and is set to "Embed & Sign" for all targets.
4. Build and run the app on a simulator or device.

### Design Decisions 
1. For persistence used Realm to save users. Due to the quantity of users being fetched and constant filtering avoided more simple solutions like plist or user defaults for eficiency.
2. Api calls are just made on first install(0 users saved) or when users scrolls to last user (infinite scroll)
3. Every time new users are going to be saved filter function deletes duplicates and users that have been deleted
4. Data goes from JSON -> UserModel -> UserObject(Persistence layer) -> UserModel(UI layer)
5. MVVM (Model-View-ViewModel) architecture
   
## Improvements 
1. Increment code coverage (more unit tests + ui tests)
2. Make adjustments for better loading performance (scroll speed,numbers of users per fetch,image loading)
3. Look to improve time complexity of filter function

