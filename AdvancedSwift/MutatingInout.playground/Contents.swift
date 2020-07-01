import UIKit

var mutableArray = [1, 2, 3]
print("最初版本\(mutableArray)")

for _ in mutableArray {
    print(mutableArray)
    mutableArray.removeAll()
}

//迭代器持有数组的一个本地的独立的复制
//不论如何移除,迭代器的复制依然持有最开始的三个元素
print("迭代完成后的版本\(mutableArray)")


print("NS可变数组的问题")
let mutable: NSMutableArray = [1, 2, 3]
let otherArray = mutable
mutable.add(4)
print(mutable)
print(otherArray)


print("扫描器例子")
//类而不是结构体
class BinaryScancer {
    var position: Int   //可变
    let data: Data      //不可变
    init(data: Data) {
        self.position = 0
        self.data = data
    }
}

extension BinaryScancer {
    func scanByte() -> UInt8? {
        guard position < data.endIndex else {
            return nil
        }
        position += 1
        return data[position - 1]
    }
}

func scanRemainingBytes(scanner: BinaryScancer) {
    while let byte = scanner.scanByte() {
        print(byte)
    }
}


let scanner = BinaryScancer(data: "hi".data(using: .utf8)!)
scanRemainingBytes(scanner: scanner)

//竟态条件
//for _ in 0..<Int.max {
//    let newScanner = BinaryScancer(data: "hi".data(using: .utf8)!)
//    DispatchQueue.global().async {
//        scanRemainingBytes(scanner: newScanner)
//    }
//    scanRemainingBytes(scanner: newScanner)
//}

//换成结构体就不会出现上面的竞态条件





print("结构体let和var")
struct Point {
    var x: Int
    var y: Int
}

let origin = Point(x: 2, y: 4)
//origin.x = 10                 //使用let声明的不可变
var otherPoint = origin         //使用var声明可变
otherPoint.x = 10
print("origin: \(origin)")
print("otherPoint: \(otherPoint)")

extension Point {
    static let origin = Point(x: 0, y: 0)   //静态属性
}

print("Point.origin: \(Point.origin)")



print("属性观察者didSet测试")
struct Size {
    var width: Int
    var height: Int
}

struct Rectangle {
    var origin: Point
    var size: Size
}

extension Rectangle {
    init(x: Int = 0, y: Int = 0, width: Int, height: Int) {
        origin = Point(x: x, y: y)
        size = Size(width: width, height: height)
    }
}

var screen = Rectangle(width: 320, height: 480) {
    didSet {
        print("Screen Changed: \(screen)")
    }
}

screen.origin.x = 10
screen.origin.y = 10

var screens = [Rectangle(width: 320, height: 480)] {
    didSet {
        print("Array Changed: \(screens)")
    }
}
screens[0].origin.x += 100   //如果Rectangle是类那么不会触发didSet


func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

screen.origin + Point(x: 999, y: 999)
print("\(screen.origin)")


extension Rectangle {
    mutating func translate(by offset: Point) {
        origin = origin + offset
    }
}
print("使用mutating方法进行translate触发属性观察者")
screen.translate(by: Point(x: 1, y: 1))


//如果用let定义Rectangle则不能对它调用translate
let screenLet = Rectangle(width: 48, height: 32)
//screenLet.translate(by: Point(x: 1, y: 1))        //报错

//非mutating版本的translated
print("非mutating版本的translated")
extension Rectangle {
    func translated(by offset: Point) -> Rectangle {
        var copy = self
        copy.translate(by: offset)      //非mutating方法创建副本进行操作并返回副本
        return copy
    }
}

var screenLeted = screenLet.translated(by: Point(x: 20, y: 20))    //let声明的可以使用非mutating方法translated
print(screenLeted)


//要理解mutating的工作先看看inout的行为
print("要理解mutating的工作先看看inout的行为")
func translateByTenTen(rectangle: Rectangle) -> Rectangle {
    return rectangle.translated(by: Point(x: 10, y: 10))
}
print(screen)
screen = translateByTenTen(rectangle: screen)
print(screen)

//使用inout参数创建原地translateByTwentyTwenty
print("使用inout参数创建原地translateByTwentyTwenty")

func translateByTwentyTwenty(rectangle: inout Rectangle) {
    rectangle.translate(by: Point(x: 20, y: 20))
}
print(screen)
translateByTwentyTwenty(rectangle: &screen)
print(screen)


//可变运算符的定义
print("可变运算符的定义")
func +=(lhs: inout Point, rhs: Point) {
    lhs = lhs + rhs
}

var myPoint = Point.origin
myPoint += Point(x: 111, y: 111)
print(myPoint)

