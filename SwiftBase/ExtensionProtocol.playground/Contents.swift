import UIKit


protocol Flier {
}
extension Flier {
    func fly() {
        print("fly fly fly")
    }
}


struct Bird: Flier {
    
}

let b = Bird()
b.fly()



struct Insect: Flier {
    func fly() {
        print("Inset fly")
    }
}

let i = Insect()
i.fly()


// 使用者可以实现从协议继承下来的方法也可以重写这个方法
// 但是这种继承并不是多态的而仅仅是另一个实现而已

let flier: Flier = Insect()
flier.fly()


// 如果要实现多态继承需要在原始协议中将fly实现为必须要实现的方法
protocol Fliers {
    func fly()
}

extension Fliers {
    func fly() {
        print("Fliers fly")
    }
}

struct Insects: Fliers {
    func fly() {
        print("Insets fly")
    }
}


let fliers: Fliers = Insects()
fliers.fly()

// 这种差别的现实意义是协议使用者并不会引入也不能引入动态派发的开销因此编译器需要做出静态决定
// 如果方法在原始协议中声明为必须实现的方法那么就可以确保使用者一定会实现它因此可以调用也只能调用使用者的实现
// 如果方法只存在于协议扩展中那么决定使用者是否重新实现了它就需要运行期的动态分派
// 但这违背了协议的本质因此编译器会将消息发送给协议扩展




enum Fill: Int {
    case Empty = 1
    case Solid
    
    init?(_ what: Int) {
        self.init(rawValue: what)
    }
}

// 或者直接扩展
extension RawRepresentable {
    init?(_ what: RawValue) {
        self.init(rawValue: what)
    }
}

enum Color: Int {
    case Color1 = 1
    case Color2
}
let c1 = Color.init(1)





