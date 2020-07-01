import UIKit

//大多数迭代器拥有值语义
struct FibsIterator: IteratorProtocol {
    typealias Element = Int
    
    var state = (0, 1)
    mutating func next() -> FibsIterator.Element? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

var fibsIterator = FibsIterator()
fibsIterator.next()
fibsIterator.next()
fibsIterator.next()


//struct PrefixIterator: IteratorProtocol {
//    typealias Element = String
//
//    let string: String
//    var offset: String.Index
//
//    init(string: String) {
//        self.string = string
//        offset = string.startIndex
//    }
//    mutating func next() -> String? {
//        guard offset < string.endIndex else {
//            return nil
//        }
//        offset = string.index(after: offset)
//        return string[string.startIndex..<offset]
//    }
//}


let seq = stride(from: 0, to: 10, by: 1)
var i1 = seq.makeIterator()
i1.next()
i1.next()

var i2 = i1

i1.next()
i1.next()
i2.next()
i2.next()

var i3 = AnyIterator(i1)
var i4 = i3

i3.next()
i4.next()
i3.next()
i3.next()

i1.next()



func fibsIteratorx() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

let fibst = fibsIteratorx()
fibst.next()
fibst.next()

let fibsSequence = AnySequence(fibsIteratorx)

Array(fibsSequence.prefix(10))


var x = 7
let iterator: AnyIterator<Int> = AnyIterator {
    defer { x += 1 }
    return x < 15 ? x : nil
}
let a = Array(iterator)
// a == [7, 8, 9, 10, 11, 12, 13, 14]



let randomNumber = sequence(first: 100) { (previous: UInt32) in
    let newValue = arc4random_uniform(previous)
    guard newValue > 0 else {
        return nil
    }
    return newValue
}

Array(randomNumber)


let fibsSequence2 = sequence(state: (0, 1)) {
    //需要帮助编译器进行类型推断
    (state: inout (Int, Int)) -> Int? in
    let upcomingNumber = state.0
    state = (state.1, state.0 + state.1)
    return upcomingNumber
}

Array(fibsSequence2.prefix(10))



//不稳定序列
//let standarIn = AnySequence {
//    return AnyIterator {
//        readLine()
//    }
//}
//
//let numberStdIn = standarIn.enumerated()
//for (i, line) in numberStdIn {
//    print("\(i + 1): \(line)")
//}


//为队列设计协议
protocol Queue {
    associatedtype Element
    mutating func enqueue(_ newElement: Element)
    mutating func dequeue() -> Element?
}


struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }

    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    public subscript(position: Int) -> Element {
        precondition((0 ..< endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

var q = FIFOQueue<String>()
for x in ["1", "2", "foo", "3"] {
    q.enqueue(x)
}
for s in q {
    print(s, terminator: " ")
}


var aa = Array(q)
aa.append(contentsOf: q[2...3])

var qm = q.map { $0.uppercased() }
qm
var qc = q.compactMap { Int($0) }
qc
var qf = q.filter { $0.count > 1}
qf
var qs = q.sorted()
var qj = q.joined(separator: " ")
q.isEmpty
q.count
type(of: q.first)


