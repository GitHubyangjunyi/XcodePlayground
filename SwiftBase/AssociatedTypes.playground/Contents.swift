import UIKit

struct Stack<Element> {
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
    func map<U>(_ f: (Element) -> U) -> Stack<U> {
        var mappedItems = [U]()
        for item in items {
            mappedItems.append(f(item))
        }
        return Stack<U>(items: mappedItems)
    }
}

//关联类型协议
//IteratorProtocol议只需要一个mutating方法next()
//这个方法返回一个Element?值
//有了IteratorProtocol只要重复调用next()就可以不断生新值
//如果代迭代器无法再产生新值了next()就会返回nil
//在协议内associatedtype Element表示符合这个协议的类型必须提供具体类型作为Element类型
//符合这个协议的类型应该在其定义内为Element提typealias定义
protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}

struct StackIterator<T>: IteratorProtocol {
    typealias Element = T
    var stack: Stack<T>
    mutating func next() -> Element? {
        return stack.pop()
    }
}

//通过类型推断简化定义
//struct StackIterator<T>: IteratorProtocol {
//    var stack: StackG<T>
//    mutating func next() -> T? {
//        return stack.pop()
//    }
//}

var myStack = Stack<Int> ()
myStack.push(10)
myStack.push(20)
myStack.push(30)
//获得迭代器
var myStackIterator = StackIterator(stack: myStack)
    while let value = myStackIterator.next() {
        print("got \(value)")
}

