import UIKit

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

let decoder = JSONDecoder.init()
let person = try decoder.decode(Person.self, from: jsonData.data(using: .utf8)!)

print(person.github)

































