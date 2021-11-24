import Foundation

// 深层次JSON结构
//{
//"name" : "John Appleseed" ,
//"id" : 7 ,
//"gift" : {
//  "toy" : {                       -->多了一层toy
//    "name" : "Teddy Bear"
// }
//}
//}

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
    
    enum GiftKeys: CodingKey {
        case toy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        
        var giftContainer = container.nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)
        try giftContainer.encode(favoriteToy, forKey: .toy)
    }
}

extension Employee: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        
        let giftContainer = try container.nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)
        favoriteToy = try giftContainer.decode(Toy.self, forKey: .toy)
    }
}


let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let decoder = JSONDecoder()

let nestedData = try encoder.encode(employee)
let nestedString = String(data: nestedData, encoding: .utf8)!
print(nestedString)


let sameEmployee = try decoder.decode(Employee.self, from: nestedData)
print(sameEmployee.favoriteToy)

