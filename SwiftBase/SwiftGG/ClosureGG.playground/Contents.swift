import UIKit

//自动闭包
//自动闭包用于包装传递给函数作为参数的表达式,这种闭包不接受任何参数
//当它被调用的时候会返回被包装在其中的表达式的值
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
customersInLine.count

let customerProvider = { customersInLine.remove(at: 0) }
customersInLine.count

print("Now serving \(customerProvider())!")
customersInLine.count


func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
customersInLine.count

//@autoclosure
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
customersInLine.count


var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))
customersInLine.count
print("Collected \(customerProviders.count) closures.")
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
customersInLine.count

//闭包表达式语法有如下的一般形式
//{ (parameters) -> return type in
//    statements
//}
//闭包表达式参数可以是in-out参数,但不能设定默认值
//如果你命名了可变参数也可以使用此可变参数
//元组也可以作为参数和返回值

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames 为 ["Ewa", "Daniella", "Chris", "Barry", "Alex"]

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )

//类型推断
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

//单表达式隐式返回
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

//参数名缩写
reversedNames = names.sorted(by: { $0 > $1 } )

//运算符方法
reversedNames = names.sorted(by: >)

//尾随闭包
reversedNames = names.sorted() { $0 > $1 }
reversedNames = names.sorted { $0 > $1 }


let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map {
    (number) -> String in
    var number = number     //闭包或者函数的参数总是常量
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}


//值捕获
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementByTen()
incrementByTen()
incrementByTen()
incrementBySeven()
incrementByTen()

let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
//incrementBySeven和 incrementByTen都是常量
//但是这些常量指向的闭包仍然可以增加其捕获的变量的值是因为函数和闭包都是引用类型
//指向闭包的引用是一个常量，而并非闭包内容本身
//为了优化
//如果一个值不会被闭包改变或者在闭包创建后不会改变
//Swift可能会改为捕获并保存一份对值的拷贝
//Swift也会负责被捕获变量的所有内存管理工作包括释放不再需要的变量
//如果你将闭包赋值给一个类实例的属性并且该闭包通过访问该实例或其成员而捕获了该实例
//你将在闭包和该实例间创建一个循环强引用,Swift使用捕获列表来打破这种循环强引用


//逃逸闭包
//将一个闭包标记为@escaping意味着你必须在闭包中显式地引用self
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

//非逃逸闭包意味着它可以隐式引用self
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
instance.x
completionHandlers.first?()
instance.x


func buildIncrementor() -> (Int) -> Int {
    return { $0 + 1 }
}

var incre = buildIncrementor()

incre(2)


