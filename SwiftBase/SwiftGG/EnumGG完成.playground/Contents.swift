import UIKit

//枚举类型是一等first-class类型
//计算属性用于提供枚举值的附加信息
//实例方法用于提供和枚举值相关联的功能
//枚举也可以定义构造函数来提供一个初始值
//可以在原始实现的基础上扩展它们的功能
//还可以遵循协议来提供标准的功能
//枚举可以拥有实例属性和静态属性,但是枚举实例属性不能是存储属性,如果相同的case的两个实例拥有不同的存储实例属性那么彼此之间就不相等,有悖于枚举的本质
//枚举不支持NSCopying协议(Swift设计模式P180)
// Objectvie-C不支持将字符串作为枚举内部的类型

//与C和Objective-C不同的是Swift的枚举成员在被创建时不会被赋予一个默认的整型值
//例子中north/south/east和west不会被隐式地赋值为0,1,2,3
//相反这些枚举成员本身就是完备的值,这些值的类型是已经明确定义好的CompassPoint类型
enum CompassPoint {
    case north
    case south
    case east
    case west
}

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}


//枚举成员的遍历
//在一些情况下你需要得到一个包含枚举所有成员的集合
//令枚举遵循CaseIterable协议
//Swift会生成一个allCases属性用于表示一个包含枚举所有成员的集合
enum Beverage: CaseIterable {
    case coffee, tea, juice
}

for beverage in Beverage.allCases {
    print(beverage)
}


//枚举成员的关联值
//没有关联值的枚举成员值默认是可哈希化的
//它的一个成员值是具有(Int，Int，Int，Int)类型关联值的upc
//另一个成员值是具有String类型关联值的qrCode
//这个定义不提供任何Int或String类型的关联值而只是定义了当Barcode常量和变量等于Barcode.upc或Barcode.qrCode时可以存储的关联值的类型
//Barcode类型的常量和变量可以存储一个.upc或者一个.qrCode(连同它们的关联值,但是在同一时间只能存储这两个值中的一个)
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
switch productBarcode {
    case .upc(let numberSystem, let manufacturer, let product, let check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .qrCode(let productCode):
        print("QR code: \(productCode).")
}

productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
switch productBarcode {
    case let .upc(numberSystem, manufacturer, product, check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case let .qrCode(productCode):
        print("QR code: \(productCode).")
}

//如果枚举具有原始值则这些值将作为声明的一部分确定这意味着特定枚举案例的每个实例始终具有相同的原始值
//枚举案例的另一种选择是具有与案例相关联的值——这些值是在您创建实例时确定的并且对于枚举案例的每个实例它们可以不同
//您可以将关联的值视为类似于枚举案例实例的存储属性
//例如考虑从服务器请求日出和日落时间的情况服务器要么以请求的信息进行响应要么以对出错的地方的描述进行响应
enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")

//声明了关联值的case其实是一个初始化函数
let initcase = ServerResponse.failure
let fail = initcase("Out")
switch fail {
    case let .result(sunrise, sunset):
        print("Sunrise is at \(sunrise) and sunset is at \(sunset)")
    case let .failure(message):
        print("Failure...  \(message)")
}


// 枚举的原始值
//使用字符串或者浮点数作为枚举的原始值或者说是隐式值
enum Rank: Int, CustomStringConvertible {
    var description: String {
        return String(self.rawValue)
    }
    
    case ace = 1//原始值使用rawValue进行访问
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
print("自动用来表示该实例的CustomStringConvertible协议\(threeCase)")
let threeCaseRawValue = threeCase.rawValue + 2
threeCase.simpleDescription()

if let convertedRank = Rank(rawValue: 3) {
    let threeDescription = convertedRank.simpleDescription()
    print("threeDescription \(threeDescription)")
}


//实际上如果没有比较有意义的原始值就不需要提供原始值
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


//递归枚举
//它有一个或多个枚举成员使用该枚举类型的实例作为关联值
//使用递归枚举时编译器会插入一个间接层
//你可以在枚举成员前加上indirect来表示该成员可递归
//indirect关键字告诉编译器枚举的数据放到一个指针指向的地方
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


//枚举的可变方法
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



