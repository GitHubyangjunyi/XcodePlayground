import UIKit

protocol Food {}

struct Meat: Food {}
struct Grass: Food {}

protocol Animal {
    func eat(_ food: Food)
}

struct Tiger: Animal {
    func eat(_ food: Food) {
        //由于老虎不吃素所以需要一些特殊的转换
        if let meat = food as? Meat {
            print("eat \(meat)")
        } else {
            fatalError("老虎只吃肉")
        }
    }
}

let meat = Meat()
Tiger().eat(meat)

//这样的转换很多时候没有意义并且将责任扔给了运行时,如何在编译时就确保老虎不吃素呢
//错误代码如下
//struct TigerX: Animal {
//    func eat(_ food: Meat) {
//        print("eat \(food)")
//    }
//}


//在协议中除了可以定义属性和方法外还可以定义类型的占位符,让实现协议的类型来指定具体的类型
//使用associatedtype在协议中添加一个限定,让实现协议的类型来指定食物的具体类型

protocol AnimalA {
    associatedtype F
    func eat(_ food: F)
}

struct TigerA: AnimalA {
    typealias F = Meat
    func eat(_ food: Meat) {
        print("eat \(food)")
    }
}

Tiger().eat(meat)

//在Tiger通过typealias具体指定F为Meat之前,Animal协议并不关心F的具体类型,只需要满足协议的类型中的F和eat参数一致即可
//这样就可以避免在具体类型的eat方法中进行判断和转换,不过这里忽视了被吃的是Food这个前提
//在associatedtype声明中可以指定类型满足某个协议并且只要实现了正确类型的eat则F的类型可以被自动推断

protocol AnimalX {
    associatedtype F: Food
    func eat(_ food: F)
}

struct Cat: AnimalX {
    func eat(_ food: Meat) {
        print("eat \(food)")
    }
}

struct Sheep: AnimalX {
    func eat(_ food: Grass) {
        print("eat \(food)")
    }
}


//不过在添加关联类型后Animal协议就不能当做独立的类型使用了
//判断动物是否危险
//func isDangerous(animal: AnimalX) -> Bool {
//    if animal is Tiger {
//        return true
//    } else {
//        return false
//    }
//}

//这是因为Swift需要在编译时就确定所有类型,因为AnimalX包含了一个不确定的类型,所以随着Animal本身类型的变化,其中F的类型是无法确定的
//比如在isDangerous这个函数内部调用eat将无法指定eat参数的类型
//在一个协议加入关联类型或者self的约束后将只能被用为泛型约束,而不能作为独立类型的占位符使用,也失去了动态派发的特性
//在这种情况下需要改写函数为泛型

func isDangerous<T: AnimalX>(animal: T) -> Bool {
    //使用Tiger并不会报错
    //if animal is Tiger {
    if animal is Cat {
        return true
    } else {
        return false
    }
}


isDangerous(animal: Cat())
isDangerous(animal: Sheep())

