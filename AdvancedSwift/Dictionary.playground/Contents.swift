import UIKit


enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}


let defaultSettings: [String : Setting] = [
    "Airplane Mode": .bool(true),
    "Name" : .text("My iPhone"),
]
var settings = defaultSettings
let overriddenSettings: [String : Setting] = ["Name" : .text("Jane's iPhone")]
settings.merge(overriddenSettings, uniquingKeysWith: { $1 })
settings

extension Dictionary {
    mutating func merge1<S>(_ other: S) where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
        for (k, v) in other {
            self[k] = v
        }
    }
}

extension Dictionary {
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge1(sequence)
    }
}

let defaultAlarms = (1..<5).map { (key: "Alarm \($0)", value: false) }
let alarmsDictionary = Dictionary(defaultAlarms)



extension Dictionary {
    func mapValue<NewValue>(transform: (Value) -> NewValue) -> [Key : NewValue] {
        return Dictionary<Key, NewValue>( map { (key, value) in
            return (key, transform(value))
        })
    }
}

settings
let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .text(let text):
        return text
    case .int(let number):
        return String(number)
    case .bool(let value):
    return String(value)
    }
}

settingsAsStrings



extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}
let frequencies = "hello".frequencies
frequencies.filter { $0.value > 1 } // ["l": 2]





extension Sequence {
    func last1(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}
let name = ["Paul", "Elena", "Zoe"]
let match = name.last1 { $0.hasSuffix("a") }
match





