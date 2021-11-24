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
settings.merge(overriddenSettings, uniquingKeysWith: { $1 }) // 合并时取第二个字典的值
settings

// 简单合并-取最新值
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

// 从序列构造出字典
let defaultAlarms = (1..<5).map { (key: "Alarm \($0)", value: false) }
let alarmsDictionary = Dictionary(defaultAlarms)


// 只变换其中的值
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


// 计算序列中某个元素出现的次数
extension Sequence where Element: Hashable {
    var frequencies: [Element:Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
        // 对每个元素进行映射和1对应起来然后从得到的(元素, 次数)的键值对序列中创建字典
        // 遇到相同的键下的两个值则将次数累加起来
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



// Hashable要求
// 标准库中的基本数据类型都遵守Hashable协议
// 另外像是属猪/集合/可选值这些类型如果他们的元素都是可哈希的那么他们自动成为可哈希
// 为了保证性能哈希表要求存储在其中的类型提供一个良好的哈希函数
// 对于结构体和枚举只要他们是由可哈希的类型组成的那么编译器就会自动合成Hashable协议的实现
// 结构体需要属性都是可哈希的
// 枚举需要关联值可哈希，没有关联值的枚举直接是实现Hashable协议
// 如果不能利用自动Hashable合成则首先需要让类型遵循Equatable协议并实现hash(into:)来遵循Hashable协议
// 这个方法接受一个Hasher类型的参数,Hasher封装了一个通用的哈希函数并在使用者向其提供数据时捕获哈希函数的状态
// 它有一个接受任何可哈希值的combine方法,你应该通过调用combine方法的方式将类型的所有基本组件逐个传递给hasher
// 基本组件是那些构成类型实质的属性你通常会想要排除那些可以被惰性重建的临时属性
// 你应该使用相同的基本组件来进行相等性检查，因为必须遵守以下的不变原则：
// 两个同样的实例(由你实现的 == 定义相同)必须拥有同样的哈希值不过反过来不必为真
// 当你使用不具有值语义的类型 作为字典的键时需要特别小心
// 如果你在将一个对象用作字典键后改变了它的内容它的哈希值和/或相等特性往往也会发生改变而你将无法再在字典中找到它
// 这时字典会在错误的位置存储对象这将导致字典内部存储的错误
