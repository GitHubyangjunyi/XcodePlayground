import UIKit

//switch支持任意类型的数据以及各种比较操作——不仅仅是整数以及测试相等
let vegetable = "red pepper"
switch vegetable {
    case "ra":
        print("Add.")
    case "cu", "water":
        print("That.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a \(x)?")
    default:
        print("Every.")
}


//区间匹配
let approximateCount = 62
let naturalCount: String
switch approximateCount {
    case 0:
        naturalCount = "no"
    case 1..<5:
        naturalCount = "a few"
    case 5..<12:
        naturalCount = "several"
    case 12..<100:
        naturalCount = "dozens of"
    case 100..<1000:
        naturalCount = "hundreds of"
    default:
        naturalCount = "many"
}
print("There are \(naturalCount).")
// 输出“There are dozens of.”

//元组匹配
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}
// 输出“(1, 1) is inside the box”

//值绑定
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
// 输出“on the x-axis with an x value of 2”



//where动态过滤器
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some point")
}
// 输出“(1, -1) is on the line x == -y”


//复合型case
let someCharacter: Character = "e"
switch someCharacter {
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter) is a consonant")
default:
    print("\(someCharacter) is not a vowel or a consonant")
}
// 输出“e is a vowel”

//复合匹配同样可以包含值绑定
//复合匹配里所有的匹配模式都必须包含相同的值绑定并且每一个绑定都必须获取到相同类型的值
//这保证了无论复合匹配中的哪个模式发生了匹配分支体内的代码都能获取到绑定的值且绑定的值都有一样的类型
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")
default:
    print("Not on an axis")
}
// 输出“On an axis, 9 from the origin”




// 高级
switch data {
case is Film:
  fetch(data.listItems, of: Starship.self)
default:
  print("未知类型", String(describing: type(of: data)))
}
