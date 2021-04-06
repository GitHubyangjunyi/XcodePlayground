import UIKit


//集合Set
var letters = Set<Character>()

letters.insert("a")

var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]

var favoriteGenres1: Set = ["Rock", "Classical", "Hip hop"]

if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}

for genre in favoriteGenres.sorted() {
    print("\(genre)")
}
//Classical
//Hip hop
//Jazz

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

//合并
oddDigits.union(evenDigits).sorted()
//[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
//交集
oddDigits.intersection(evenDigits).sorted()
//[]
//减去
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
//[1, 9]
//不相交的值
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
//[1, 2, 9]


let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

//是不是子集
houseAnimals.isSubset(of: farmAnimals)
//true
//是不是父集
farmAnimals.isSuperset(of: houseAnimals)
//true
//是否没有交集
farmAnimals.isDisjoint(with: cityAnimals)
//true


//字典
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
for (_, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)



var namesOfIntegers = [Int: String]()
namesOfIntegers[16] = "sixteen"

var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
airports["LHR"] = "London Heathrow"

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}
// 输出“The old value for DUB was Dublin.”

if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
}
//打印“The removed airport's name is Dublin Airport.”


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

let airportCodes = [String](airports.keys)
//airportCodes是["YYZ", "LHR"]






