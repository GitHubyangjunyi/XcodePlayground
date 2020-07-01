import UIKit

func add(_ a: Int, _ b: Int) -> Int {
    return a + b;
}
add(1, 2) // 3

func addc(_ a: Int) -> (Int) -> Int {
    return { a + $0 }
}
addc(1)(2) // 3

func addcc(_ a: Int) -> (Int) -> (Int) -> Int {
    return { b in { c in a + b + c } }
}
addcc(1)(2)(3) // 6


//通过变形使得函数可以更加灵活,不需要等待所有参数全部齐全才能调用函数
//很多时候两个Int加法的函数stdlib库里已经提供了(+)
//当每次需要一个现有函数的柯里化变形时,如果我们都需要像上面一样来实现那就太麻烦了
//我们可以用范型函数来将指定的函数进行柯里化,这样只需要传入想要柯里化的函数即可

public func curry<A, B, C, Result>(_ f: @escaping (A, B, C) -> Result) -> (A) -> (B) -> (C) -> Result {
    return { a in { b in { c in f(a, b, c) } } }
}
public func curryx<A, B, Result>(_ f: @escaping (A, B) -> Result) -> (A) -> (B) -> Result {
    return { a in { b in f(a, b) } }
}

//curry(+)(1)(2) // 3
//curryx(addcc)(1)(2)(3) // 6


func addOne(num: Int) -> Int {
    return num + 1
}


func addTo(_ adder: Int) -> (Int) -> Int {
    return { num in return num + adder }
}

let addTwo = addTo(2)    // addTwo: Int -> Int
let result = addTwo(6)   // result = 8
let resultx = addTo(1)(2)

func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { $0 > comparer }
}

let greaterThan10 = greaterThan(10);

greaterThan10(13)    // => true
greaterThan10(9)     // => false


func addTwoNumber(a: Int) -> (_ num: Int) -> Int {
    return { num in a + num }
}

let addToFour = addTwoNumber(a: 4)
addToFour(6)

//函数柯里化初步
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)
