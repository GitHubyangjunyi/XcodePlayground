import UIKit

struct Stack {
    var items = [Int]()
    mutating func push(_ newItem: Int) {
        items.append(newItem)
    }
    mutating func pop() -> Int? {
        guard !items.isEmpty else {
            return nil
        }
        return items.removeLast()
    }
}

var intStack = Stack()
intStack.push(1)
intStack.push(2)
print(intStack.pop() ?? 13) // 打印Optional(2)
print(intStack.pop() ?? 13) // 打印Optional(1)
print(intStack.pop() ?? 13) // 打印nil


struct StackG<Element> {
    var items = [Element]()
    mutating func push(_ newItem: Element) {
        items.append(newItem)
    }
    mutating func pop() -> Element? {
        guard !items.isEmpty else {
            return nil
        }
        return items.removeLast()
    }
    func map<U>(_ f: (Element) -> U) -> StackG<U> {
        var mappedItems = [U]()
        for item in items {
            mappedItems.append(f(item))
        }
        return StackG<U>(items: mappedItems)
    }
}

var stringStack = StackG<String>()
stringStack.push("this is a string")
stringStack.push("another string")
print(stringStack.pop() ?? "xxx")

//范型函数和方法
func myMap<T,U>(_ items: [T], _ f: (T) -> (U)) -> [U] {
    var result = [U]()
    for item in items {
        result.append(f(item))
    }
    return result
}

let strings = ["one", "two", "three"]
let stringLengths = myMap(strings) { $0.count }
print(stringLengths) // 打印[3, 3, 5]


var intStackG = StackG<Int>()
intStackG.push(1)
intStackG.push(2)
var doubledStack = intStackG.map { 2 * $0 }
print(doubledStack.pop() ?? "nil") // 打印Optional(4)
print(doubledStack.pop() ?? "nil") // 打印Optional(2)


//范型约束
//1.必须是给定类的子类
//2.必需符合一个协议
func checkIfEqual<T: Equatable>(_ first: T, _ second: T) -> Bool {
    return first == second
}
print(checkIfEqual(1, 1))
print(checkIfEqual("a string", "a string"))
print(checkIfEqual("a string", "a different string"))


//T和U都􏱳􏱴是CustomStringConvertible的约束保证了first和second都有返􏰹回字符串的属􏰱性的description
func checkIfDescriptionsMatch<T: CustomStringConvertible, U: CustomStringConvertible>( _ first: T, _ second: U) -> Bool {
    return first.description == second.description
}
//两个约束使得即使两个参数类型不同还是可以比较它们的描述
print(checkIfDescriptionsMatch(Int(1), UInt(1)))
print(checkIfDescriptionsMatch(1, 1.0))
print(checkIfDescriptionsMatch(Float(1.0), Double(1.0)))


//知道了类型/函数和方法都可以是泛􏰺型的你就自然会问:
//协议是不是也可以是􏰺泛型的?
//答案是不可以,不过协议支持􏱦类型的一个相关特性:关联类型

protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}
//IteratorProtocol只需要一个mutating方法next()
//这个方法􏰮回一个Element?值,有了IteratorProtocol只要重复调用next()就可以不断产􏱆生新值
//如果迭代器无法再产生新的值,next()就会􏰮返回nil
//在协议内部associatedtype Element表示符合这个􏰐协议的类型􏱈提供􏱊􏰥􏰅类型作为Element类型
//符合这个􏰐协议的类型应该在其定􏱋内􏰞为Element提􏱊typealias定义􏱋
􏰷􏰒􏰓struct StackIterator<T>: IteratorProtocol {
    typealias Element = T
    var stack: StackG<T>
    mutating func next() -> Element? {
        return stack.pop()
    }
}


