import UIKit

//枚举为一组相关的值定义了一个共同的类型
//枚举为一组相关的值定义了一个共同的类型
//枚举为一组相关的值定义了一个共同的类型

//枚举类型是一等first-class类型
//它们采用了很多在传统上只被类所支持的特性,例如计算属性用于提供枚举值的附加信息
//实例方法用于提供和枚举值相关联的功能
//枚举也可以定义构造函数来提供一个初始值
//可以在原始实现的基础上扩展它们的功能
//还可以遵循协议来提供标准的功能

enum CompassPoint {
    case north
    case south
    case east
    case west
}
//与C和Objective-C不同的是Swift的枚举成员在被创建时不会被赋予一个默认的整型值
//上面的例子中north/south/east和west不会被隐式地赋值为0,1,2,3
//相反这些枚举成员本身就是完备的值,这些值的类型是已经明确定义好的CompassPoint类型

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west
directionToHead = .south

switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
}

//枚举成员的遍历
//在一些情况下你需要得到一个包含枚举所有成员的集合
//令枚举遵循CaseIterable协议
//Swift会生成一个allCases属性用于表示一个包含枚举所有成员的集合
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

for beverage in Beverage.allCases {
    print(beverage)
}




//枚举成员的关联值
//定义一个名为Barcode的枚举
//它的一个成员值是具有(Int，Int，Int，Int)类型关联值的upc
//另一个成员值是具有String类型关联值的qrCode
//这个定义不提供任何Int或String类型的关联值而只是定义了当Barcode常量和变量等于Barcode.upc或Barcode.qrCode时可以存储的关联值的类型
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
//原始的Barcode.upc和其整数关联值被新的Barcode.qrCode和其字符串关联值所替代
//Barcode类型的常量和变量可以存储一个.upc或者一个.qrCode(连同它们的关联值,但是在同一时间只能存储这两个值中的一个


switch productBarcode {
    case .upc(let numberSystem, let manufacturer, let product, let check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .qrCode(let productCode):
        print("QR code: \(productCode).")
}

switch productBarcode {
    case let .upc(numberSystem, manufacturer, product, check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case let .qrCode(productCode):
        print("QR code: \(productCode).")
}


//作为关联值的替代选择枚举成员可以被默认值(称为原始值)预填充,这些原始值的类型必须相同\
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

//原始值是在定义枚举时被预先填充的值像上述三个ASCII码
//对于一个特定的枚举成员它的原始值始终不变
//关联值是创建一个基于枚举成员的常量或变量时才设置的值且关联值可以变化


//原始值的隐式赋值
enum PlanetI: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

//当使用字符串作为枚举类型的原始值时每个枚举成员的隐式原始值为该枚举成员的名称
enum CompassPointS: String {
    case north, south, east, west
}

let earthsOrder = PlanetI.earth.rawValue
let sunsetDirection = CompassPointS.west.rawValue


//如果在定义枚举类型的时候使用了原始值那么将会自动获得一个初始化方法
//这个方法接收一个叫做rawValue的参数,参数类型即为原始值类型,返回值则是枚举成员或nil
let possiblePlanet = PlanetI(rawValue: 7)

if let somePlanet = PlanetI(rawValue: 11) {
    switch somePlanet {
        case .earth:
            print("Mostly harmless")
        default:
            print("Not a safe place for humans")
        }
} else {
    print("没有对应的枚举")
}



enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    func simpleDescription() -> String {
        switch self {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}

let threeCase = Rank.three
let threeCaseRawValue = threeCase.rawValue + 2
threeCase.simpleDescription()


//扑克牌花色
enum Suit {
    case spades, hearts, diamonds, clubs
    
    func simpleDescription() -> String {
        switch self {
            case .spades:
                return "spades"
            case .hearts:
                return "hearts"
            case .diamonds:
                return "diamonds"
            case .clubs:
                return "clubs"
        }
    }
}

let hearts = Suit.hearts
let heartsDescription = hearts.simpleDescription()

struct Card {
    var rank: Rank
    var suit: Suit
    
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}

let threeOfSpades = Card(rank: .three, suit: .spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()


//枚举的关联值是实际值而不是原始值的另一种表达方法
//如果枚举成员的实例有原始值那么这些值是在声明的时候就已经决定了
//这意味着不同枚举实例的枚举成员总会有一个相同的原始值
//当然我们也可以为枚举成员设定关联值且关联值是在创建实例时决定的
//这意味着同一枚举成员不同实例的关联值可以不相同,你可以把关联值想象成枚举成员实例的存储属性
//例如从服务器获取日出和日落的时间的情况,服务器会返回正常结果或者错误信息
//没有关联值的枚举成员值默认是可哈希化的
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

switch success {
    case let .result(sunrise, sunset):
        print("Sunrise is at \(sunrise) and sunset is at \(sunset)")
    case let .failure(message):
        print("Failure...  \(message)")
}


//递归枚举
//它有一个或多个枚举成员使用该枚举类型的实例作为关联值
//使用递归枚举时编译器会插入一个间接层
//你可以在枚举成员前加上indirect来表示该成员可递归
//算术表达式
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

//也可以在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的
indirect enum ArithmeticExpressionIndirect {
    case number(Int)
    case addition(ArithmeticExpressionIndirect, ArithmeticExpressionIndirect)
    case multiplication(ArithmeticExpressionIndirect, ArithmeticExpressionIndirect)
}

//(5 + 4) * 2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
        case let .number(value):
            return value
        case let .addition(left, right):
            return evaluate(left) + evaluate(right)
        case let .multiplication(left, right):
            return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))




//indirect关键字告诉编译器􏱼􏱽􏱙􏱚把􏰷枚举􏰸的数据放到一个􏱤􏴃指针指向的地方
indirect enum FamilyTree {
         case noKnownParents
         case oneKnownParent(name: String, ancestors: FamilyTree)
         case twoKnownParents(fatherName: String, fatherAncestors: FamilyTree, motherName: String, motherAncestors: FamilyTree)
}
 
enum FamilyTreex {
    case noKnownParents
    indirect case oneKnownParent(name: String, ancestors: FamilyTree)
    indirect case twoKnownParents(fatherName: String, fatherAncestors: FamilyTree, motherName: String, motherAncestors: FamilyTree)
}

let fredAncestors = FamilyTree.twoKnownParents(fatherName: "Fred Sr.", fatherAncestors: .oneKnownParent(name: "Beth", ancestors: .noKnownParents), motherName: "Marsha", motherAncestors: .noKnownParents)





//枚举的可变方法
//结构体和枚举是值类型
//默认情况下值类型的属性不能在它的实例方法中被修改
//但是如果你确实需要在某个特定的方法中修改结构体或者枚举的属性你可以为这个方法选择可变mutating行为
//然后就可以从其方法内部改变它的属性并且这个方法做的任何改变都会在方法执行结束时写回到原始结构中
//方法还可以给它隐含的self属性赋予一个全新的实例,这个新实例在方法结束时会替换现存实例
enum Lightbulb {
    case on
    case off
    
    func surfaceTemperature(forAmbientTemperature ambient: Double) -> Double {
        switch self {
            case .on:
                return ambient + 150.0
            case .off:
                return ambient
        }
    }
    
    mutating func toggle() {
        switch self {
            case .on:
                self = .off
            case .off:
                self = .on
        }
    }
}

var bulb = Lightbulb.off
let ambientTemperature = 77.0
bulb.toggle()
var bulbTemperature = bulb.surfaceTemperature(forAmbientTemperature: ambientTemperature)
print("the bulb's temperature is \(bulbTemperature)")





//面向轨道编程
//比如对于即将输入的数字x我们希望输出4 / (2 / x - 1)的计算结果
//这里会有两处出错的可能一是(2 / x)时x为0
//另一个就是(2 / x - 1)为0
let errorStr = "输入错误我很抱歉"
func cal(value: Float) {
    if value == 0 {
        print(errorStr)
    } else {
        let value1 = 2 / value
        let value2 = value1 - 1
        if value2 == 0 {
            print(errorStr)
        } else {
            let value3 = 4 / value2
            print(value3)
        }
    }
}
cal(value: 2)    //输入错误我很抱歉
cal(value: 1)    //4.0
cal(value: 0)    //输入错误我很抱歉


final class Box<T> {
    let value: T
    init(value: T) {
        self.value = value
    }
}

enum Result<T> {
    case Success(Box<T>)
    case Failure(String)
}


func call(value: Float) {
    func cal1(value: Float) -> Result<Float> {
        if value == 0 {
            return .Failure(errorStr)
        } else {
            return .Success(Box(value: 2 / value))
        }
    }
    func cal2(value: Result<Float>) -> Result<Float> {
        switch value {
        case .Success(let v):
            return .Success(Box(value: v.value - 1))
        case .Failure(let str):
            return .Failure(str)
        }
    }
    func cal3(value: Result<Float>) -> Result<Float> {
        switch value {
        case .Success(let v):
            if v.value == 0 {
                return .Failure(errorStr)
            } else {
                return .Success(Box(value: 4 / v.value))
            }
        case .Failure(let str):
            return .Failure(str)
        }
    }

    let r = cal3(value: cal2(value: cal1(value: value)))
    switch r {
    case .Success(let v):
        print(v.value)
    case .Failure(let s):
        print(s)
    }
}
cal(value: 2)    //输入错误我很抱歉
cal(value: 1)    //4.0
cal(value: 0)    //输入错误我很抱歉


//上面的代码switch的操作重复而多余都在重复着把Success和Failure分开的逻辑
//实际上每个函数只需要处理Success的情况,我们在Result中加入funnel提前处理掉Failure的情况

enum Result<T> {
    case Success(Box<T>)
    case Failure(String)

    func funnel<U>(f:(T) -> Result<U>) -> Result<U> {
        switch self {
        case .Success(let value):
            return f(value.value)
        case .Failure(let errString):
            return Result<U>.Failure(errString)
        }
    }
}

//funnel帮我们把上次的结果进行分流只将Success的轨道对接到了下个业务上而将Failure引到了下一个Failure轨道上
//此时我们已经不再需要传入Result值了只需要传入value即可

    func cal(value: Float) {
        func cal1(v: Float) -> Result<Float> {
            if v == 0 {
                return .Failure(errorStr)
            } else {
                return .Success(Box(2 / v))
            }
        }

        func cal2(v: Float) -> Result<Float> {
            return .Success(Box(v - 1))
        }

        func cal3(v: Float) -> Result<Float> {
            if v == 0 {
                return .Failure(errorStr)
            } else {
                return .Success(Box(4 / v))
            }
        }

        let r = cal1(value).funnel(cal2).funnel(cal3)
        switch r {
        case .Success(let v):
            print(v.value)
        case .Failure(let s):
            print(s)
        }
    }
//看起来简洁了一些我们可以通过cal1(value).funnel(cal2).funnel(cal3)这样的链式调用来获取计算结果
