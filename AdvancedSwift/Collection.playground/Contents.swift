import UIKit

let a = NSMutableArray(array: [1, 2, 3])
let b = a
a.insert(4, at: 3)
a
b//事实上被a的影响所改变

//正确的做法是先手动复制
let c = NSMutableArray(array: [5, 6, 7])
let d = c.copy() as! NSArray
c.insert(8, at: 3)
c
d


//Map的实现
//@inlinable
//public func map<T>(
//  _ transform: (Element) throws -> T
//) rethrows -> [T] {
//  let initialCapacity = underestimatedCount
//  var result = ContiguousArray<T>()
//  result.reserveCapacity(initialCapacity)
//
//
//  var iterator = self.makeIterator()
//
//
//  // Add elements up to the initial capacity without checking for regrowth.
//  for _ in 0..<initialCapacity {
//    result.append(try transform(iterator.next()!))
//  }
//  // Add remaining elements, if any.
//  while let element = iterator.next() {
//    result.append(try transform(element))
//  }
//  return Array(result)
//}






let name = ["Paul", "Elena", "Zoe"]

var lastNameEndingInA: String

for name in name.reversed() {
    print("\(name)")
}
print("\(name)")


for name in name.reversed() where name.hasSuffix("a") {
    print("\(name)")
}

extension Sequence {
    func last(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}

let match = name.last { $0.hasSuffix("a") }
match

extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
        
    }
}

[1, 2, 3, 4].accumulate(0, +)

[1, 2, 3, 4].filter { num in num % 2 == 0 }
let filterx = [1, 2, 3, 4].filter { $0 % 2 == 0 }
filterx


let reducex = [1, 2, 3, 4].reduce(0) { total, num in total + num }
reducex


let suits = ["♠️", "♥️", "♣️", "♦️"]
let ranks = ["J", "Q", "K", "A"]

let result = suits.flatMap{ suit in ranks.map{ rank in (suit, rank) } }
result

(2..<10).forEach { num in
    print(num)
    if num > 2 { return }
}

let fibs = [0, 1, 1, 2, 3, 5]
let slice = fibs[1..<fibs.endIndex]
type(of: slice)



enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

extension Dictionary {
    mutating func merge<S>(_ other: S) where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
        for (k, v) in other {
            self[k] = v
        }
    }
}

let defaultSettings: [String : Setting] = [
    "Airplane Mode": .bool(true),
    "Name" : .text("My iPhone"),
]
var settings = defaultSettings
let overriddenSettings: [String : Setting] = ["Name" : .text("Jane's iPhone")]
settings.merge(overriddenSettings)

extension Dictionary {
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequence)
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



