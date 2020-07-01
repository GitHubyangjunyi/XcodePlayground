import UIKit

var red, green, blue: Double

//下面两个浮点字面量都等于十进制的12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0 //3除以16等于0.1875

let sixTy = 0xFp2

let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1


//类型别名typealias
typealias AudioSample = UInt16

var maxAmplitudeFound = AudioSample.min

//空合运算符
let defaultColorName = "red"
var userDefinedColorName: String?

var colorNameToUse = userDefinedColorName ?? defaultColorName

//浮点数陷阱
let d1 = 1.1
let d2: Double = 1.1
let f1: Float = 100.3

if d1 == d2 {
    print("d1 and d2 are the same!")
}

print("d1 + 0.1 is \(d1 + 0.1)")
if d1 + 0.1 == 1.2 {
    print("d1 + 0.1 is equal to 1.2")//不会输出,因为浮点数不精确,不可比较
}




//求余运算符a % b是计算b的多少倍刚刚好可以容入a并返回多出来的那部分余数
//a = (b × 倍数) + 余数
9 % 4
-9 % 4
//在对负数b求余时b的符号会被忽略
//这意味着a % b和a % -b的结果是相同的



//算术运算符+-*/%等的结果会被检测并禁止值溢出以此来避免保存变量时由于变量大于或小于其类型所能承载的范围时导致的异常结果
//当然允许你使用溢出运算符来实现溢出
//溢出操作符
let y: Int8 = 120
var zx = y &+ 10
print("120 &+ 10 is \(zx)")

let yy: Int8 = -120
zx = yy &- 10
print("120 &+ 10 is \(zx)")



//in-out参数
var err = "The request failed:"

func appendErrorCode(_ code: Int, toErrorString errorString: inout String) {
    if code == 400 {
        errorString += " bad request."
    }
}
appendErrorCode(400, toErrorString: &err)
err


//嵌套函数和作用域
func areaOfTriangleWith(base: Double, height: Double) -> Double {
    let numerator = base * height
    
    func divide() -> Double {
        return numerator / 2
    }
    return divide()
}
areaOfTriangleWith(base: 3.0, height: 5.0)



//结构体
struct Town {
    var population = 5_422
    var numberOfStoplights = 4
    
    static func numberOfSides() -> Int {
        return 4
    }
    
    mutating func changePopulation(by amount: Int) {
       population += amount
    }
    
    func printDescription() {
        print("Population: \(population);number of stoplights: \(numberOfStoplights)")
    }
}

var myTown = Town()
myTown.changePopulation(by: 500)
print("Population: \(myTown.population),number of stoplights: \(myTown.numberOfStoplights)")


//类
class Monster {
    var town: Town?
    var name = "Monster"
    
    func terrorizeTown() {
        if town != nil {
            print("\(name) is terrorizing a town!") }
        else {
            print("\(name) hasn't found a town to terrorize yet...")
        }
    }
}

class Zombie: Monster {
    var walksWithLimp = true
    
    class func makeSpookyNoise() -> String {
        return "Brains..."
    }
    
    final override func terrorizeTown() {
        town?.changePopulation(by: -10)//可空链式调用并且防止值复制
        super.terrorizeTown()
    }
}

let fredTheZombie = Zombie()
fredTheZombie.town = myTown
fredTheZombie.terrorizeTown()
fredTheZombie.town?.printDescription()

myTown.printDescription()

//关键字static告诉编译器不要让子类重写类方法,也可以使用final class替换static

//mutating关键字
func greeting(forName name: String) -> (String) -> String {
    func greeting(_ greeting: String) -> String {
        return "\(greeting) \(name)"
    }
    return greeting
}

let greetMattWith = greeting(forName: "Matt")
let mattGreeting = greetMattWith("Hello,")
print(mattGreeting)

func greetingClosure(_ greeting: String) -> (String) -> String {
    return { (name: String) -> String in return "\(greeting) \(name)" }
}

let friendlyGreetingFor = greetingClosure("Hello,")
let mattGreetingc = friendlyGreetingFor("Matt")
print(mattGreeting)








//断言
//断言仅在调试环境运行
var age = -3
//assert(age >= 0, "年龄不能小于0")
age = 12
if age > 10 {
    print("age > 10")
} else if age > 0 {
    print("age > 0")
} else {
    assertionFailure("年龄不能小于0")
}


//先决条件则在调试环境和生产环境中运行
//当一个条件可能为假但是继续执行代码要求条件必须为真的时候需要使用先决条件
//强制执行先决条件
//例如使用先决条件来检查下标越界或者是否将一个正确的参数传给函数
//你可以使用全局precondition(_:_:file:line:)函数来写一个先决条件
//向这个函数传入一个结果为true或者false的表达式以及一条信息
//当表达式的结果为false的时候这条信息会被显示

//在一个下标的实现里...
//precondition(index > 0, "Index must be greater than zero.")


//你可以调用preconditionFailure(_:file:line:)方法来表明出现了一个错误
//例如switch进入了default分支但是所有的有效值应该被任意一个其他分支而非default分支处理

//如果你使用unchecked模式(-Ounchecked编译代码则先决条件将不会进行检查
//编译器假设所有的先决条件总是为true并将优化你的代码
//然而fatalError(_:file:line:)函数总是中断执行无论你怎么进行优化设定
//你能使用fatalError(_:file:line:)函数在设计原型和早期开发阶段,这个阶段只有方法的声明但是没有具体实现
//你可以在方法体中写上fatalError("Unimplemented")作为具体实现
//因为fatalError不会像断言和先决条件那样被优化掉所以你可以确保当代码执行到一个没有被实现的方法时程序会被中断

//assert(condition:message:file:line:)函数接受自动闭包作为它的condition参数和message参数
//它的condition参数仅会在debug模式下被求值,message参数仅当condition参数为false时被计算求值
