import UIKit


//使用Self的范型协议
//在协议中使用Self会将协议转换成范型协议
protocol Flier {
    func flockTogetherWith(f: Self)
}



//使用空类型别名的范型协议
protocol FlierE {
    associatedtype Other
    func flockTogetherWith(f: Other)
    func mateWith(f: Other)
}


// 使用了Self或者拥有关联类型的协议只能用在泛型类型中并且作为类型限制
protocol FlierG {
    associatedtype Other
    func fly()
}

func flockTwoTogether<T1: FlierG, T2: FlierG>(f1: T1, f2: T2) {
    f1.fly()
    f2.fly()
}

// 两种形式的显式特化
// 1.typealias手工解析出关联类型
// 2.使用<L>解析出占位符类型

class Dog<T> {
    var name: T?
}

let dog = Dog<String>()

// 但是不能显式特化泛型函数
protocol FileX {
    init()
}

struct Bird: FileX {
    init() {}
}

struct FileXMaker<T: FileX> {
    static func makeFiler() -> T {
        return T()
    }
}

let f = FileXMaker<Bird>.makeFiler()

// 如果类是泛型的可以对其子类化但前提是可以解析出泛型
class Animal<T> {
    var name: T?
}

// 匹配
class Cat<T>: Animal<T> {
    
}

// 特指

class Human: Animal<String> {
    
}




// 关联类型链
// 如果具有关联类型的泛型协议使用了泛型占位符那么可以通过对占位符使用点符号将关联类型名连接起来指定类型
protocol Superfighter {
    associatedtype Weapon: Wieldable
}
protocol Fighter: Superfighter {
    associatedtype Enemy: Superfighter  // 对手
}


protocol Wieldable {}
struct Sword: Wieldable {}
struct Bow: Wieldable {}

struct Soldier: Fighter {
    typealias Weapon = Sword
    typealias Enemy = Archer    // 士兵的对手是弓箭手
}


struct Archer: Fighter {
    typealias Weapon = Bow
    typealias Enemy = Soldier   // 弓箭手的对手是士兵
}


// 每个战士都可以窃取别人的武器
extension Fighter {
    func stea(weapon: Self.Enemy.Weapon, from: Self.Enemy) {
    }
}




// 营地
struct Camp<T: Fighter> {
    var spy: T.Enemy?    // 营地里混入了间谍
}

var camp = Camp<Soldier>()
camp.spy = Archer()


// 关联类型中的类型约束

protocol G {
    associatedtype T: Fighter, Dog<Any>
}








