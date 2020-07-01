import UIKit

class Person {
    var name: String
    var friends: [Person] = []
    var bestFriend: Person? = nil
    
    init(name: String) {
        self.name = name
    }
}

var han = Person(name: "Han Solo")
var luke = Person(name: "Luke Skywalker")
luke.friends.append(han)

// create a key path and use it
let firstFriendsNameKeyPath = \Person.friends[0].name
let firstFriend = luke[keyPath: firstFriendsNameKeyPath] // "Han Solo"

// or equivalently, with type inferred from context
luke[keyPath: \.friends[0].name] // "Han Solo"
// The path must always begin with a dot, even if it starts with a
// subscript component
luke.friends[keyPath: \.[0].name] // "Han Solo"
luke.friends[keyPath: \[Person].[0].name] // "Han Solo"

// rename Luke's first friend
luke[keyPath: firstFriendsNameKeyPath] = "A Disreputable Smuggler"

// optional properties work too
let bestFriendsNameKeyPath = \Person.bestFriend?.name
let bestFriendsName = luke[keyPath: bestFriendsNameKeyPath]  // nil, if he is the last Jedi
