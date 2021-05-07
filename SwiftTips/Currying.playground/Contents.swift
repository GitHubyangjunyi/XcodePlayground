import UIKit


func addTo(_ adder: Int) -> (Int) -> Int {
    return { num in return num + adder }
}

let addTwo = addTo(2)
let result = addTwo(6)
let resultx = addTo(1)(2)

func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { $0 > comparer }
}

let greaterThan10 = greaterThan(10);
greaterThan10(13)
greaterThan10(9)


func addTwoNumber(_ a: Int) -> (_ num: Int) -> Int {
    return { num in a + num }
}

let addToFour = addTwoNumber(4)
let aa = addToFour(6)
aa

// 柯里化是一种量产相似方法的好办法可以通过柯里化一个方法模板来避免写出很多重复代码也方便了今后维护

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
//curryx(addcc)(1)(2) // 6




protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()

    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
    // ...
}

class Control {
    var actions = [ControlEvent: TargetAction]()

    func setTarget<T: AnyObject>(target: T, action: @escaping (T) -> () -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }

    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }

    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}


print("安全Target-Action")

