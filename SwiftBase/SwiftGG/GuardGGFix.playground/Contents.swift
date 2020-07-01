import UIKit

//在if条件语句中使用常量和变量来创建一个可选绑定仅在if语句的句中才能获取到值
//相反在guard语句中使用常量和变量来创建一个可选绑定仅在guard语句外且在语句后才能获取到值

func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)!")

    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
//输出“Hello John!”
//输出“I hope the weather is nice near you.”
greet(person: ["name": "Jane", "location": "Cupertino"])
//输出“Hello Jane!”
//输出“I hope the weather is nice in Cupertino.”


