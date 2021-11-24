import Foundation

// JSON长这样
//{
//   "name" : "John Appleseed" ,
//   "id" : 7 ,
//   "gift" : {                    --> favoriteToy被替换成gift
//     "name" : "Teddy Bear"
//  }
//}


struct Toy: Codable {
    var name: String
}

struct Employee: Codable {
    var name: String
    var id: Int
    var favoriteToy: Toy
    
    enum CodingKeys: String, CodingKey {
        case name, id, favoriteToy = "gift"
    }
    
}

let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)

let encoder = JSONEncoder()
let decoder = JSONDecoder()

let data = try encoder.encode(employee)
let string = String(data: data, encoding: .utf8)!
print(string)
let sameEmployee = try decoder.decode(Employee.self, from: data)



