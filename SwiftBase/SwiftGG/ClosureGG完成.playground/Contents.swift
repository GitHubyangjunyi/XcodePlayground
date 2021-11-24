import UIKit

//没有明确定义返回类型的函数的返回一个Void类型特殊值
//该值为一个空元组写成()

//默认参数
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    //如果你在调用时候不传第二个参数parameterWithDefault会值为12传入到函数体中
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6)
someFunction(parameterWithoutDefault: 4)


//可变参数
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
//返回3.0是这5个数的平均数


//inout参数
//函数参数默认是常量
//试图在函数体中更改参数值将会导致编译错误这意味着你不能错误地更改参数值
//如果你想要一个函数可以修改参数的值并且想要这些修改在函数调用结束后仍然存在
//那么就应该在参数定义前加inout关键字
//一个输入输出参数有传入函数的值,这个值被函数修改然后被传出函数替换原来的值
//你只能传递变量给输入输出参数而不能传入常量或者字面量因为这些量是不能被修改的
//当传入的参数作为输入输出参数时需要在参数名前加&符表示这个值可以被函数修改
//输入输出参数不能有默认值而且可变参数不能用inout标记
func addd(num: inout Int) -> Int {
    num = num + 1
    return num
}

var num = 1
let saa = addd(num: &num)
print("saa = \(saa)")
print("num现在 = \(num)")

var err = "The request failed:"
func appendErrorCode(_ code: Int, toErrorString errorString: inout String) {
    if code == 400 {
        errorString += " bad request."
    }
}
appendErrorCode(400, toErrorString: &err)
print(err)


func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
//打印“someInt is now 107, and anotherInt is now 3”




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
reversedNames
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
        someFunctionWithEscapingClosure { [self] in x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
instance.x
completionHandlers.first?()
instance.x

struct SomeStruct {
    var x = 10
    mutating func doSomething() {
        someFunctionWithNonescapingClosure { x = 200 }  // Ok
        //someFunctionWithEscapingClosure { x = 100 }     // Error
    }
}

// 如果self是结构或枚举的实例则始终可以self隐式引用
// 但是闭包无法捕获对self,self是结构实例或枚举的可变引用,结构和枚举不允许共享的可变性
// someFunctionWithEscapingClosure上面示例中对函数的调用是错误的因为它在mutation方法内部因此self是可变的这违反了转义的闭包不能捕获self对结构的可变引用的规则


//自动闭包
//自动闭包用于包装传递给函数作为参数的表达式,这种闭包不接受任何参数
//当它被调用的时候会返回被包装在其中的表达式的值
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
customersInLine.count

let customerProvider = { customersInLine.remove(at: 0) }

func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
customersInLine.count


customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
customersInLine.count
//@autoclosure
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
customersInLine.count

customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
customersInLine.count

var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))
customersInLine.count
customerProviders.count
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
customersInLine.count



