import UIKit

//函数可以嵌套
//被嵌套的函数可以访问外侧函数的变量你可以使用嵌套函数来重构一个太长或者太复杂的函数
//重构一个太长或者太复杂的函数
//重构一个太长或者太复杂的函数
//重构一个太长或者太复杂的函数
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()



//没有明确定义返回类型的函数的返回一个Void类型特殊值
//该值为一个空元组写成()

//多重返回值
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}
//打印“min is -6 and max is 109”

//隐式返回
func greeting(for person: String) -> String {
    "Hello, " + person + "!"
}
print(greeting(for: "Dave"))
//打印 "Hello, Dave!"

func anotherGreeting(for person: String) -> String {
    return "Hello, " + person + "!"
}
print(anotherGreeting(for: "Dave"))
//打印 "Hello, Dave!"

//默认参数
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    //如果你在调用时候不传第二个参数parameterWithDefault会值为12传入到函数体中
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6)
//parameterWithDefault = 6
someFunction(parameterWithoutDefault: 4)
//parameterWithDefault = 12


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
arithmeticMean(3, 8.25, 18.75)
//返回10.0,是这3个数的平均数

//inout参数
//函数参数默认是常量
//试图在函数体中更改参数值将会导致编译错误
//这意味着你不能错误地更改参数值
//如果你想要一个函数可以修改参数的值并且想要这些修改在函数调用结束后仍然存在
//那么就应该在参数定义前加inout关键字
//一个输入输出参数有传入函数的值,这个值被函数修改然后被传出函数替换原来的值
//你只能传递变量给输入输出参数而不能传入常量或者字面量因为这些量是不能被修改的
//当传入的参数作为输入输出参数时需要在参数名前加&符表示这个值可以被函数修改
//输入输出参数不能有默认值而且可变参数不能用inout标记
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


//嵌套函数
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
//moveNearerToZero now refers to the nested stepForward()function
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
//-4...
//-3...
//-2...
//-1...
//zero!
