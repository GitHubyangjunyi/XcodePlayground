import Foundation
// 平面JSON结构
//{
//"name" : "John Appleseed" ,
//"id" : 7 ,
//"gift" : "Teddy Bear"
//}

// 平面JSON与模型结构不匹配所有需要自定义编码逻辑描述如何对每个Employee和Toy存储的属性进行编码
struct Toy: Codable {
    var name: String
}

struct Employee: Encodable {
    var name: String
    var id: Int
    var favoriteToy: Toy
    
    enum CodingKeys: CodingKey {
        case name, id, gift
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(favoriteToy.name, forKey: .gift)
    }
}

// 在扩展中以保留成员初始化器
extension Employee: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    id = try container.decode(Int.self, forKey: .id)
    favoriteToy = Toy.init(name: try container.decode(String.self, forKey: .gift))
  }
}


let encoder = JSONEncoder()
let decoder = JSONDecoder()

let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)


let data = try encoder.encode(employee)
let string = String(data: data, encoding: .utf8)!
print(string)


let sameEmployee = try decoder.decode(Employee.self, from: data)
print(sameEmployee.favoriteToy.name)

