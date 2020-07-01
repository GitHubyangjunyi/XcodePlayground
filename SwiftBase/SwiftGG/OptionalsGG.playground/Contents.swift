import UIKit

//在Swift中nil不是指针而是一个确定的值用来表示值缺失
//任何类型的可选状态都可以被设置为nil不只是对象类型

//nil不能用于非可选的常量和变量
//如果你的代码中有常量或者变量需要处理值缺失的情况请把它们声明成对应的可选类型

let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
}

//强制解析
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}


//可选绑定If-Let
//可选绑定可以用在if和while语句中
//在if条件语句中使用常量和变量来创建一个可选绑定仅在if语句的句中才能获取到值
//相反在guard语句中使用常量和变量来创建一个可选绑定仅在guard语句外且在语句后才能获取到值

if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}


if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}


//隐式解析可选类型
let possibleString: String? = "An optional string."
let forcedString: String = possibleString!

var assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString

if assumedString != nil {
    print(assumedString!)
    assumedString = nil
    print(assumedString ?? "nil")
}





