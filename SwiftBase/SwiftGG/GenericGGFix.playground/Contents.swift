import UIKit

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)



func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)
makeArray(repeating: 1.3, numberOfTimes: 4)

//重新实现Swift标准库中的可选类型
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)
print(possibleInteger)



//非泛型版本的栈
struct IntStack {
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

//泛型版本的栈
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")

let fromTheTop = stackOfStrings.pop()


//泛型扩展
//当对泛型类型进行扩展时并不需要提供类型参数列表作为定义的一部分
//原始类型定义中声明的类型参数列表在扩展中可以直接使用并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}


//具有泛型Where子句的扩展
//只有当栈中的元素符合Equatable协议时扩展才会添加isTop(_:)方法
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
}


//如果尝试在其元素不符合Equatable协议的栈上调用isTop(_:)方法则会收到编译时错误
struct NotEquatable { }
var notEquatableStack = Stack<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
//notEquatableStack.isTop(notEquatableValue)  // 报错



//类型约束
//类型约束指定类型参数必须继承自指定类、遵循特定的协议或协议组合
//例如Swift的Dictionary类型对字典的键的类型做了些限制
//字典键的类型必须是可哈希的,也就是说必须有一种方法能够唯一地表示它
//这个要求通过Dictionary键类型上的类型约束实现,它指明了键必须遵循Swift标准库中定义的Hashable协议
//当自定义泛型类型时你可以定义你自己的类型约束,这些约束将提供更为强大的泛型编程能力
//像可哈希hashable这种抽象概念根据它们的概念特征来描述类型而不是它们的具体类型


//where限定
//比如限定类型实现某一个协议,限定两个类型是相同的或者限定某个类必须有一个特定的父类
func anyCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool where T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
anyCommonElements([1, 2, 3], [3])
anyCommonElements([1, 2, 3], [5])

//<T: Equatable>和<T> ... where T: Equatable>的写法是等价的
func anyCommonElementsWhere<T, U>(_ lhs: T, _ rhs: U) -> Bool where T: Sequence, U: Sequence, T.Element: Equatable, T.Element == U.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
anyCommonElementsWhere([1, 2, 3], [3])
anyCommonElementsWhere([1, 2, 3], [5])



//该函数的功能是在一个String数组中查找给定String值的索引
//若查找到匹配的字符串返回该字符串在数组中的索引值否则返回nil
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
