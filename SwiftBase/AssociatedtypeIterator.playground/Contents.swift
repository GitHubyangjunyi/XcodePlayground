import UIKit

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
struct StackIterator<T>: IteratorProtocol {
    typealias Element = T
    var stack: StackG<T>
    mutating func next() -> Element? {
        return stack.pop()
    }
}

var myStack = StackG<Int> ()
myStack.push(10)
myStack.push(20)
myStack.push(30)
var myStackIterator = StackIterator(stack: myStack)
while let value = myStackIterator.next() {
print("got \(value)") }



//protocol SequenceS {
//    associatedtype Iterator: IteratorProtocol
//    func makeIterator() -> Iterator
//}

//Sequence的关联􏰷类型名为Iterator: IteratorProtocol语法是关联类型的类型约束􏰔􏰕
//其含义􏱗􏱋和泛型􏰺的类型约束􏰔􏰕一样:对于一个符合Sequence的类型来说必须􏱉有一个符合IteratorProtocol􏰐协议的关联􏰷类型Iterator
//Sequence还要􏲽符合它的类型实现一个方法makeIterator()
//这个方法􏰮回一个关联􏰷类型IteratorProtocol的值,因为我们􏱾经有了适合􏰤栈的生成器􏰲所以把Stack改为符合Sequence
//
//struct StackS<Element>: SequenceS {
//    var items = [Element]()
//    mutating func push(_ newItem: Element) {
//        items.append(newItem)
//    }
//    mutating func pop() -> Element? {
//        guard !items.isEmpty else {
//            return nil
//        }
//        return items.removeLast()
//    }
//    func map<U>(_ f: (Element) -> U) -> StackS<U> {
//        var mappedItems = [U]()
//        for item in items {
//            mappedItems.append(f(item))
//        }
//        return StackS<U>(items: mappedItems)
//    }
//    func makeIterator() -> StackIterator<Element> {
//        return StackIterator(stack: self)
//    }
//}
//
//for value in myStack {
//    print("for-in loop: got \(value)")
//}
