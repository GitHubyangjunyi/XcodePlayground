import UIKit


//Nest遵循了这个协议可以让我们在需要使用Nest类型的地方直接使用Int
struct Nest: ExpressibleByIntegerLiteral {
    var count: Int = 0
    init() { }
    init(integerLiteral value: IntegerLiteralType) {
        self.count = value
    }
}

func printCount(nest: Nest) {
    print("\(nest.count)")
}

printCount(nest: 4)

