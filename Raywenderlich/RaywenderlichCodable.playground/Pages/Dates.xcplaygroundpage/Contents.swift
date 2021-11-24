import Foundation

// JSON日期
//{
//“id”：7，
//“name”：“John Appleseed”，
//“生日”：“29-05-2019”，
//“toy”：{
//  “name”：“泰迪熊”
//}
//}


extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

struct Toy: Codable {
    var name: String
}

struct Employee: Codable {
    var name: String
    var id: Int
    var toy: Toy
    var birthday: Date
}


let encoder = JSONEncoder()
let decoder = JSONDecoder()

encoder.dateEncodingStrategy = .formatted(.dateFormatter)
decoder.dateDecodingStrategy = .formatted(.dateFormatter)


let toy = Toy(name: "Teddy Bear")
let employee = Employee(name: "John Appleseed", id: 7, toy: toy, birthday: Date())

let dateData = try encoder.encode(employee)
let dateString = String(data: dateData, encoding: .utf8)!
print(dateString)


let sameEmployee = try decoder.decode(Employee.self, from: dateData)
print(sameEmployee.birthday)




