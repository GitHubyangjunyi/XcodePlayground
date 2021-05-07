import UIKit


let fibs = [0, 1, 1, 2, 3, 5]
let a = NSMutableArray(array: [1, 2, 3])
let b = a
a.insert(4, at: 3)
b//事实上被a的影响所改变

//正确的做法是先手动复制
let c = NSMutableArray(array: [5, 6, 7])
let d = c.copy() as! NSArray
c.insert(8, at: 3)
d


// 关于映射
extension Array {
    func map1<T>(_ transform: (Element) -> T) -> [T] { // T的具体类型由transform函数的返回值来决定
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

//Map的实现-Sequence协议的一个扩展
//@inlinable
//public func map<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
//  let initialCapacity = underestimatedCount
//  var result = ContiguousArray<T>()
//  result.reserveCapacity(initialCapacity)
//
//  var iterator = self.makeIterator()
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


// 关于拆分
let array: [Int] = [1, 2, 2, 2, 3, 4, 4]
// 将数组中的元素按照相邻且相等的方式拆分
var result: [[Int]] = array.isEmpty ? [] : [[array[0]]]
for (previous, current) in zip(array, array.dropFirst()) {
    if previous == current {
        result[result.endIndex - 1].append(current)
    } else {
        result.append([current])
    }
}
result

extension Array {
    // 提取出分割的条件
    func split1(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, self.dropFirst()) {
            if condition(previous, current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }
}
let parts = array.split1 { $0 != $1 }
parts
let parts2 = array.split1(where: ==)
parts2



extension Array {
    // 保留每一步的值建立一个数组
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return self.map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}
[1,2,3,4].accumulate(0, +)


// 关于过滤
extension Array {
    func filter1(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}
let mapFilter1 = (1..<10).map { $0 * $0 }.filter1 { $0 % 2 == 0 }
mapFilter1



// 关于合并
let reducex = [1, 2, 3, 4].reduce(0) { total, num in total + num }
reducex

let strFib = fibs.reduce("") { str, num in str + "\(num), " }
strFib


extension Array {
    func reduce1<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}

// 单纯使用reduce实现map和filter
extension Array {
    func map2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) { $0 + [transform($1)] }
    }
    
    func filter2(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]) { isIncluded($1) ? $0 + [$1] : $0 }
    }
}

let reduceImp = [1, 2, 3, 4, 5, 6, 7, 8, 9].map2 { $0 * $0 }.filter2 { $0 % 2 == 0 }
reduceImp

// 关于flatMap
extension Array {
    func flatMap1<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self { result.append(contentsOf: transform(x)) }
        return result
    }
}



let suits = ["♠️", "♥️", "♣️", "♦️"]
let ranks = ["J", "Q", "K", "A"]

let resultt = suits.flatMap1 { suit in ranks.map { rank in (suit, rank) } }
resultt



// 关于ForEach
(1..<10).forEach { number in
    print(number)
    if number > 2 { // 本意想让它在大于二之后就不再打印了
        return
    }
}
// 比如你正在实现一个ViewController然后想把一个数组中的视图都加到当前view上的话只需要写theViews.forEach(view.addSubview)就足够了


extension Array where Element: Equatable {
    func firstIndex1(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}

// 下面的代码是错误
//extension Array where Element: Equatable {
//    func firstIndex_foreach(of element: Element) -> Int? {
//        self.indices.filter { idx in
//            self[idx] == element
//        }.forEach { idx in
//            return idx
//            // 在forEach中的return 并不能让外部函数返回它仅仅只是让闭包本身返回
//            //在这种情况下编译器会发现return语句的参数没有被使用从而给出警告
//        }
//        return nil
//    }
//}


// 关于数组切片
// 切片类型只是数组的一种表示方式它背后的数据仍然是原来的数组只不过是用切片的方式来进行表示
// 因为数组的元素不会被复制所以创建一个切片的代价很小
let slice = fibs[1..<fibs.endIndex]
slice // [1, 1, 2, 3, 5]
type(of: slice)
let newArray = Array(slice)
type(of: newArray)
// 因为ArraySlice和Array都满足了相同的协议当中最重要的就是Collection协议
// 需要谨记的是切片和它背后的数组是使用相同的索引来引用元素的因此切片索引不需要从零开始
// 例如在上面我们用fibs[1...]创建的切片的第一个元素的索引是1因此错误地访问slice[0]元素会使我们的程序因越界而崩溃
// slice[0]
// 如果你操作切片的话我们建议你总是基于startIndex和endIndex属性做索引计算即使你正在处理的是一个这两个属性分别是0和count-1的普通数组





