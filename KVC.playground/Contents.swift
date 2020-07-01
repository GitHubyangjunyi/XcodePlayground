import UIKit

struct Person {
    var name: String
}
 
struct Book {
    var title: String
    var authors: [Person]
    var primaryAuthor: Person {
        return authors.first!
    }
}
 
let abelson = Person(name: "Haeold Abelson")
let sussman = Person(name: "Garald Jay Sussman")
var book = Book(title: "tructure and Interpretation of Computer Programs", authors: [abelson, sussman])


let title = book[keyPath: \Book.title]
print(title)
 
let name = book[keyPath: \Book.primaryAuthor.name]
print(name)

book[keyPath: \Book.title] = "KVC"
print(book[keyPath: \Book.title])


//先获取一个路径
let authorKeyPath = \Book.primaryAuthor
//拼接子路径
let nameKeyPath = authorKeyPath.appending(path: \.name)
let newName = book[keyPath: nameKeyPath]
print(newName)//Haeold Abelson











