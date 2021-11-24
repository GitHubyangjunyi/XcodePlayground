import Foundation

// JSON对象数组
//{
//  "name" : "Teddy Bear",
//  "label" : [
//    "teddy bear",
//    "TEDDY BEAR",
//    "Teddy Bear"
//  ]
//}




struct Toy: Encodable {
    var name: String
    var label: String
  
    enum CodingKeys: CodingKey {
        case name, label
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var nestContainer = container.nestedUnkeyedContainer(forKey: .label)
        try nestContainer.encode(label.lowercased())
        try nestContainer.encode(label.uppercased())
        try nestContainer.encode(label)
    }
}

extension Toy: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        var nestContainer = try container.nestedUnkeyedContainer(forKey: .label)
        var labelName = ""
        while !nestContainer.isAtEnd {
            labelName = try nestContainer.decode(String.self)
        }
        label = labelName
    }
}


let encoder = JSONEncoder()
let decoder = JSONDecoder()
encoder.outputFormatting = .prettyPrinted



let toy = Toy(name: "Teddy Bear", label: "Teddy Bear Label")
let data = try encoder.encode(toy)
let string = String(data: data, encoding: .utf8)!
print(string)


let sameToy = try decoder.decode(Toy.self, from: data)

print(sameToy.name)
print(sameToy.label)




