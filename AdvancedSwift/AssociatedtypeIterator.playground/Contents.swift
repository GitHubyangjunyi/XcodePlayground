import UIKit

struct Stack<Element> {
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
    
}

//知道了类型/函数和方法都可以是泛型的你就自然会问:
//协议是不是也可以是泛型的?
//答案是不可以,不过协议支持类型的一个相关特性:关联类型
//可以做到协议中的方法类型泛化
protocol IteratorProtocol {
    associatedtype Element    // 表示适配成迭代器后迭代出来的类型是泛化的
    mutating func next() -> Element?
}
//IteratorProtocol只需要一个方法next()
//这个方法返回一个Element?,有了IteratorProtocol只要重复调用next()就可以不断产生新值
//在协议内部associatedtype Element表示符合这个协议的类型需要typealias定义Element具体代表的类型
struct StackIterator<T>: IteratorProtocol {
    typealias Element = T
    
    var stack: Stack<T>
    
    mutating func next() -> T? { // mutating func next() -> Element?
        return stack.pop()
    }
}

//通过类型推断简化定义
//struct StackIterator<T>: IteratorProtocol {
//    var stack: Stack<T>
//
//    mutating func next() -> T? {
//        return stack.pop()
//    }
//}

var myStack = Stack<Int> ()
myStack.push(10)
myStack.push(20)
myStack.push(30)

var myStackIterator = StackIterator(stack: myStack)
while let value = myStackIterator.next() {
    print("got \(value)")
}


// 接下来看IteratorProtocol
