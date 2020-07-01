import UIKit

//扩展可以给一个现有的类,结构体,枚举还有协议添加新的功能
//它还拥有不需要访问被扩展类型源代码就能完成扩展的能力,即逆向建模
//扩展和Objective-C的分类很相似,但是与Objective-C分类不同的是Swift扩展是没有名字的
//Swift中的扩展可以：
//1.添加计算型实例属性和计算型类属性(扩展可以添加新的计算属性但是它们不能添加存储属性或向现有的属性添加属性观察者)
//2.定义实例方法和类方法
//3.提供新的构造器
//4.定义下标
//5.定义和使用新的嵌套类型
//6.使已经存在的类型遵循（conform）一个协议
//在Swift中你甚至可以扩展协议以提供其需要的实现或者添加额外功能给遵循的类型所使用
//注意扩展可以给一个类型添加新的功能但是不能重写已经存在的功能
//扩展可以使用在现有范型类型上就像扩展范型类型中描述的一样
//你还可以使用扩展给泛型类型有条件的添加功能就像扩展一个带有Where字句的范型中描述的一样


//构造器
//扩展可以给现有的类型添加新的构造器,它使你可以把自定义类型作为参数来供其他类型的构造器使用或者在类型的原始实现上添加额外的构造选项
//扩展可以给一个类添加新的便利构造器但是它们不能给类添加新的指定构造器或者析构器,指定构造器和析构器必须始终由类的原始实现提供
//如果你使用扩展给一个值类型添加构造器而这个值类型已经为所有存储属性提供默认值且没有定义任何自定义构造器,那么你可以在该值类型扩展的构造器中使用默认构造器和成员构造器
//如果你已经将构造器写在值类型的原始实现中则不适用于这种情况,如同值类型的构造器委托中所描述的那样
//如果你使用扩展给另一个模块中定义的结构体添加构造器那么新的构造器直到定义模块中使用一个构造器之前不能访问self
//如果你通过扩展提供一个新的构造器你有责任确保每个通过该构造器创建的实例都是初始化完整的

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))


//扩展方法
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions {
    print("Hello!")
}

extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()


//扩展下标实现
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
//返回5
746381295[1]
//返回9
746381295[9]
//如果操作的Int值没有足够的位数满足所请求的下标那么下标的现实将返回0将好像在数字的左边补上了0
0746381295[9]


//嵌套类型
//扩展可以给现有的类,结构体还有枚举添加新的嵌套类型
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
//打印+ + - 0 - 0 +

