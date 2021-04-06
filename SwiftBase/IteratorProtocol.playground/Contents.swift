import UIKit

protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}

//Sequence关联协议
//对于一个符合Sequence的类型来说必须􏱳􏱴有一个符合IteratorProtocol􏰝议的关联􏲒类型Iterator
//Sequence还要求􏱹符合它的类型实现一个方法makeIterator()
//这个方法返􏰹回一个关联􏲒类型IteratorProtocol的值
protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
}

struct StackIterator<T>: IteratorProtocol {
    typealias Element = T
    var stack: Stack<T>
    mutating func next() -> Element? {
        return stack.pop()
    }
}

struct Stack<Element>: Sequence {
    typealias Iterator = StackIterator<Element>
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
    func makeIterator() -> StackIterator<Element> {
        return StackIterator(stack: self)
    }
}



var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
var doubledStack = intStack.map { 2 * $0 }
print(intStack.pop() as Any)       // 打印Optional(2)
print(intStack.pop() as Any)       // 打印Optional(1)
print(intStack.pop() as Any)       // 打印nil
print(doubledStack.pop() as Any)   // 打印Optional(4)
print(doubledStack.pop() as Any)   // 打印Optional(2)


var myStack = Stack<Int> ()
myStack.push(10)
myStack.push(20)
myStack.push(30)
var myStackIterator = StackIterator(stack: myStack)
    while let value = myStackIterator.next() {
        print("got \(value)")
}


for value in myStack {
    print("for-in loop: got \(value)")
}





