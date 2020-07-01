import UIKit

//Swift中结构体和类有很多共同点两者都可以
//定义属性用于存储值
//定义方法用于提供功能
//定义下标操作用于通过下标语法访问它们的值
//定义构造器用于设置初始值
//通过扩展以增加默认实现之外的功能
//遵循协议以提供某种标准功能

//与结构体相比类还有如下的附加功能
//继承允许一个类继承另一个类的特征
//类型转换允许在运行时检查和解释一个类实例的类型
//析构器允许一个类实例释放任何其所被分配的资源
//引用计数允许对一个类的多次引用

//与结构体不同的是类实例没有默认的成员逐一构造器

struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someResolution = Resolution()
let someVideoMode = VideoMode()

print("The width of someResolution is \(someResolution.width)")
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd

cinema.width = 2048
print("cinema is now  \(cinema.width) pixels wide")
print("hd is still \(hd.width) pixels wide")


//结构体和枚举是值类型
//默认情况下值类型的属性不能在它的实例方法中被修改
//但是如果你确实需要在某个特定的方法中修改结构体或者枚举的属性你可以为这个方法选择可变mutating行为
//然后就可以从其方法内部改变它的属性并且这个方法做的任何改变都会在方法执行结束时写回到原始结构中
//方法还可以给它隐含的self属性赋予一个全新的实例,这个新实例在方法结束时会替换现存实例



//枚举也遵循相同的行为准则
enum CompassPoint {
    case north, south, east, west
    
    mutating func turnNorth() {
        self = .north
    }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberedDirection)")



let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")

if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}



//需要注意的是tenEighty和alsoTenEighty被声明为常量而不是变量
//然而你依然可以改变tenEighty.frameRate和alsoTenEighty.frameRate
//这是因为tenEighty和alsoTenEighty这两个常量的值并未改变
//它们并不“存储”这个VideoMode实例而仅仅是对VideoMode实例的引用
//所以改变的是底层VideoMode实例的frameRate属性而不是指向VideoMode的常量引用的值


//值类型的构造器代理
//构造器代理的实现规则和形式在值类型和类类型中有所不同
//值类型不支持继承所以构造器代理的过程相对简单因为它们只能代理给自己的其它构造器
//类则不同它可以继承自其它类,这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化
//对于值类型你可以使用self.init在自定义的构造器中引用相同类型中的其它构造器,并且你只能在构造器内部调用self.init
//请注意如果你为某个值类型定义了一个自定义的构造器你将无法访问到默认构造器,如果是结构体还将无法访问逐一成员构造器
//这种限制避免了在一个更复杂的构造器中做了额外的重要设置,但有人不小心使用自动生成的构造器而导致错误的情况
//注意,假如你希望默认构造器、逐一成员构造器以及你自己的自定义构造器都能用来创建实例,可以将自定义的构造器写到扩展中而不是写在值类型的原始定义中


//结构体默认成员构造器

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}


struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}

    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}






