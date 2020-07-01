import UIKit

var namesOfIntegers = [Int: String]()
namesOfIntegers[16] = "sixteen"
namesOfIntegers = [:]

var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
airports["LHR"] = "London"
airports["LHR"] = "London Heathrow"

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
// 输出“The old value for DUB was Dublin.”

if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}
//打印“The removed airport's name is Dublin Airport.”

airports["APL"] = "Apple Internation"
//“Apple Internation”不是真的APL机场删除它
airports["APL"] = nil
//APL现在被移除了

for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}
//YYZ: Toronto Pearson
//LHR: London Heathrow

for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}
//Airport code: YYZ
//Airport code: LHR

for airportName in airports.values {
    print("Airport name: \(airportName)")
}
//Airport name: Toronto Pearson
//Airport name: London Heathrow

for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}


let airportCodes = [String](airports.keys)
//airportCodes是["YYZ", "LHR"]

let airportNames = [String](airports.values)
//airportNames是["Toronto Pearson", "London Heathrow"]
