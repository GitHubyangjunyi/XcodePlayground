import Foundation

//混合类型JSON
//[
//  {
//    "name" : "John Appleseed",
//    "id" : 7
//  },
//  {
//    "id" : 7,
//    "name" : "John Appleseed",
//    "birthday" : 580797832.94787002,
//    "toy" : {
//      "name" : "Teddy Bear"
//    }
//  }
//]


struct Toy: Codable {
    var name: String
}

enum AnyEmployee: Encodable {
    case defaultEmployee(String, Int)
    case customEmployee(String, Int, Date, Toy)
    case noEmployee
    
    enum CodingKeys: CodingKey {
        case name, id, birthday, toy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .defaultEmployee(let name, let id):
            print("编码到默认")
            try container.encode(name, forKey: .name)
            try container.encode(id, forKey: .id)
        case .customEmployee(let name, let id, let birthday, let toy):
            print("编码自定义")
            try container.encode(name, forKey: .name)
            try container.encode(id, forKey: .id)
            try container.encode(birthday, forKey: .birthday)
            try container.encode(toy, forKey: .toy)
        case .noEmployee:
            print("无效可编码")
            let context = EncodingError.Context.init(codingPath: encoder.codingPath, debugDescription: "无效")
            throw EncodingError.invalidValue(self, context)
        }
    }
}

extension AnyEmployee: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let containerKeys = Set.init(container.allKeys)
        let defaultKeys = Set<CodingKeys>.init([.name, .id])
        let customKeys = Set<CodingKeys>.init([.name, .id, .birthday, .toy])
        
        switch containerKeys {
        case defaultKeys:
            print("匹配到默认")
            let name = try container.decode(String.self, forKey: .name)
            let id = try container.decode(Int.self, forKey: .id)
            self = .defaultEmployee(name, id)
        case customKeys:
            print("匹配到自定义")
            let name = try container.decode(String.self, forKey: .name)
            let id = try container.decode(Int.self, forKey: .id)
            let birthday = try container.decode(Date.self, forKey: .birthday)
            let toy = try container.decode(Toy.self, forKey: .toy)
            self = .customEmployee(name, id, birthday, toy)
        default:
            print("匹配到空")
            self = .noEmployee
        }
    }
}


let encoder = JSONEncoder()
let decoder = JSONDecoder()
encoder.outputFormatting = .prettyPrinted


let toy = Toy(name: "Teddy Bear")
let employees = [AnyEmployee.defaultEmployee("John Apple", 7), AnyEmployee.noEmployee, AnyEmployee.customEmployee("Tim", 8, Date(), toy)]

var employeesData: Data?

do {
    employeesData = try encoder.encode(employees)
} catch let error {
    print(error.localizedDescription)
}

let employeesString = String.init(data: employeesData!, encoding: .utf8)!
print(employeesString)


let sameEmployees = try decoder.decode([AnyEmployee].self, from: employeesData!)
print(sameEmployees.count)
print(sameEmployees.first!)




