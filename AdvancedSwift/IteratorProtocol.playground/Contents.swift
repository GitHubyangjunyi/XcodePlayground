import UIKit

// 上接AssociatedtypeIterator
// 一个迭代器可以产生next值
protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}

// 一个序列可以产生一个迭代器
protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
}

struct StackIterator<T>: IteratorProtocol {
    typealias Element = T
    
    var stack: Stack<T>
    
    mutating func next() -> T? {
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
        guard !items.isEmpty else { return nil }
        return items.removeLast()
    }
    
    func map<NewElement>(_ f: (Element) -> NewElement) -> Stack<NewElement> {
        var mappedItems = [NewElement]()
        for item in items {
            mappedItems.append(f(item))
        }
        return Stack<NewElement>(items: mappedItems)
    }
    
    func makeIterator() -> StackIterator<Element> {
        return StackIterator(stack: self)
    }
}


var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
print(intStack.pop() as Any)
print(intStack.pop() as Any)
print(intStack.pop() as Any)


var myStack = Stack<Int> ()
myStack.push(10)
myStack.push(20)
myStack.push(30)
var myStackIterator = StackIterator(stack: myStack)
while let value = myStackIterator.next() {
    print("got \(value)")
}


// 斐波那契数列迭代器
struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

// "abc" 调用next依次得到 a ab abc
struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    
    mutating func next() -> Substring? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}

struct PrefixSequence: Sequence {
    let string: String
    
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}















