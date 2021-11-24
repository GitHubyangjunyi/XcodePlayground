import Foundation

// 数组JSON
//[
//"teddy bear",
//"TEDDY BEAR",
//"Teddy Bear"
//]


struct Toy: Codable {
    var name: String
}

struct Label: Encodable {
    var toy: Toy
    
    func encode(to encoder: Encoder) throws {
        // unkeyedContainer将值写入数组而不是字典
        var container = encoder.unkeyedContainer()
        try container.encode(toy.name.lowercased())
        try container.encode(toy.name.uppercased())
        try container.encode(toy.name)
    }
}

extension Label: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var name = ""
        while !container.isAtEnd {
            name = try container.decode(String.self)
        }
        toy = Toy.init(name: name)
        
    }
}


let encoder = JSONEncoder()
let decoder = JSONDecoder()
encoder.outputFormatting = .prettyPrinted

let toy = Toy(name: "Teddy Bear")
let label = Label(toy: toy)


let labelData = try encoder.encode(label)
let labelString = String(data: labelData, encoding: .utf8)!
print(labelString)

let sameLabel = try decoder.decode(Label.self, from: labelData)
print(sameLabel.toy.name)


