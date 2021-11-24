import Foundation

//JSON
//{
//"name" : "John Appleseed" ,
//"id" : 7 ,
//"favoriteToy" : {
//  "name" : "Teddy Bear"
//}
//}

struct Toy: Codable {
    var name: String
}

struct Employee: Codable {
    var name: String
    var id: Int
    var favoriteToy: Toy
}

var toy = Toy(name: "Teddy Bear")
var employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)


let encoder = JSONEncoder.init()
let decoder = JSONDecoder.init()


var data = try encoder.encode(employee)
var string = String.init(data: data, encoding: .utf8)
print("\n将员工编码成字符串 -> " + string!)


var sameEmployee = try decoder.decode(Employee.self, from: data)
print("\n从Data中解码出员工 -> \(sameEmployee.id)")


encoder.keyEncodingStrategy = .convertToSnakeCase
decoder.keyDecodingStrategy = .convertFromSnakeCase

data = try encoder.encode(employee)
string = String.init(data: data, encoding: .utf8)
print("\n编码为蛇形式" + string!)


sameEmployee = try decoder.decode(Employee.self, from: data)
print("\n从蛇形式Data中解码出员工 -> \(sameEmployee.id)")




let jsonData = """
{
    "name" : "Shai Mishali",
    "twitter" : "@freak4pc",
    "github": "https://github.com/freak4pc",
    "birthday": "October 4th, 1987"
}
"""


struct Person: Codable {
  let name: String
  let twitter: String
  let github: URL
  let birthday: Date
}

let person = try decoder.decode(Person.self, from: jsonData.data(using: .utf8)!)

print(person.github)
