import UIKit

//类、枚举和结构体都可以遵循协议
//协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性
//协议不指定属性是存储属性还是计算属性它只指定属性的名称和类型
//如果协议要求属性是可读可写的那么该属性不能是常量属性或只读的计算型属性
//如果协议只要求属性是可读的那么该属性不仅可以是可读的,如果代码需要的话还可以是可写的


protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

//协议可以要求遵循协议的类型实现某些指定的实例方法或类方法,这些方法作为协议的一部分像普通方法一样放在协议的定义中但是不需要大括号和方法体
//可以在协议中定义具有可变参数的方法,和普通方法的定义方式相同,但是不支持为协议中的方法提供默认参数


//协议可以要求遵循协议的类型实现指定的构造器
//你可以像编写普通构造器那样在协议的定义里写下构造器的声明但不需要写花括号和构造器的实体
//无论是作为指定构造器还是作为便利构造器都必须为构造器实现标上required修饰符确保所有子类也必须提供此构造器实现从而也能遵循协议
//如果类已经被标记为final那么不需要在协议构造器的实现中使用required修饰符因为final类不能有子类
//如果一个子类重写了父类的指定构造器并且该构造器满足了某个协议的要求那么该构造器的实现需要同时标注required和override修饰符
//协议还可以为遵循协议的类型定义可失败构造器要求
//遵循协议的类型可以通过可失败构造器init?或非可失败构造器init来满足协议中定义的可失败构造器要求
//协议中定义的非可失败构造器要求可以通过非可失败构造器init或隐式解包可失败构造器init!来满足
protocol SomeInitProtocol {
    init(someParameter: Int)
}

class SomeClass: SomeInitProtocol {
    required init(someParameter: Int) {
        //这里是构造器的实现部分
    }
}


//协议作为类型
//尽管协议本身并未实现任何功能但是协议可以被当做一个功能完备的类型来使用
//协议作为类型使用有时被称作「存在类型」「存在着一个类型T,该类型遵循协议T



//在扩展里添加协议遵循
//即便无法修改源代码依然可以通过扩展令已有类型遵循并符合协议
//扩展可以为已有类型添加属性/方法/下标以及构造器,因此可以符合协议中的相应要求
//注意通过扩展令已有类型遵循并符合协议时该类型的所有实例也会随之获得协议中定义的各项功能

//通过扩展遵循并采纳协议和在原始定义中遵循并符合协议的效果完全相同

protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Int: TextRepresentable {
    var textualDescription: String {
        return "\(self)"
    }
}

2.textualDescription


//有条件地遵循协议
//泛型类型可能只在某些情况下满足一个协议的要求,比如当类型的泛型形式参数遵循对应协议时
//你可以通过在扩展类型时列出限制让泛型类型有条件地遵循某协议,在你采纳协议的名字后面写泛型where分句

extension Array: TextRepresentable where Element: TextRepresentable {
    internal var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let arr = [3, 2]
print(arr.textualDescription)



//在扩展里声明采纳协议
//当一个类型已经遵循了某个协议中的所有要求却还没有声明采纳该协议时可以通过空的扩展来让它采纳该协议
//因为即使满足了协议的所有要求类型也不会自动遵循协议而必须显式地遵循协议

struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)


//协议的继承
//协议能够继承一个或多个其他协议,可以在继承的协议的基础上增加新的要求

protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
}

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}



//类专属协议
//通过添加AnyObject关键字到协议的继承列表就可以限制协议只能被类类型采纳
protocol SomeClassOnlyProtocol: AnyObject, InheritingProtocol {
}



//协议合成
//要求一个类型同时遵循多个协议是很有用的,你可以使用协议组合来复合多个协议到一个要求里
//协议组合行为就和你定义的临时局部协议一样拥有构成中所有协议的需求
//协议组合不定义任何新的协议类型

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)


class Location {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}

//任何Location的子类并且遵循Named协议
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)



//检查协议一致性
//你可以使用类型转换中描述的is和as操作符来检查协议一致性并且可以转换到指定的协议类型
protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}

class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}

//objects数组中的元素的类型并不会因为强转而丢失类型信息它们仍然是Circle,Country,Animal类型
//然而当它们被赋值给objectWithArea常量时只被视为HasArea类型,因此只有area属性能够被访问



//可选的协议要求
//在协议中使用optional关键字作为前缀来定义可选要求,遵循协议的类型可以选择是否实现这些要求
//可选要求用在你需要和Objective-C打交道的代码中,协议和可选要求都必须带上@objc属性
//标记@objc特性的协议只能被继承自Objective-C类的类或者@objc类遵循,其他类以及结构体和枚举均不能遵循这种协议
//使用可选要求时它们的类型会自动变成可选的
//比如一个类型为(Int) -> String的方法会变成((Int) -> String)?,需要注意的是整个函数类型是可选的而不是函数的返回值
//协议中的可选要求可通过可选链式调用来使用,因为遵循协议的类型可能没有实现这些可选要求
//类似someOptionalMethod?(someArgument)这样,你可以在可选方法名称后加上?来调用可选方法
//下面的例子定义了一个名为Counter的用于整数计数的类它使用外部的数据源来提供每次的增量
//数据源由CounterDataSource协议定义,它包含两个可选要求
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}




//协议扩展
//协议可以通过扩展来为遵循协议的类型提供属性,方法以及下标的实现
//通过这种方式你可以基于协议本身来实现这些功能而无需在每个遵循协议的类型中都重复同样的实现也无需使用全局函数
//通过协议扩展所有遵循协议的类型都能自动获得这个扩展所增加的方法实现而无需任何额外修改
//协议扩展可以为遵循协议的类型增加实现但不能声明该协议继承自另一个协议,协议的继承只能在协议声明处进行指定

extension TextRepresentable {
    func graterThanTen() -> Bool {
        return false
    }
}

2.graterThanTen()



//提供默认实现
//可以通过协议扩展来为协议要求的方法,计算属性提供默认的实现
//如果遵循协议的类型为这些要求提供了自己的实现那么这些自定义实现将会替代扩展中的默认实现被使用
//注意通过协议扩展为协议要求提供的默认实现和可选的协议要求不同
//虽然在这两种情况下遵循协议的类型都无需自己实现这些要求,但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用



//为协议扩展添加限制条件
//在扩展协议的时候可以指定一些限制条件,只有遵循协议的类型满足这些限制条件时才能获得协议扩展提供的默认实现
//这些限制条件写在协议名之后使用where子句来描述
//例如可以扩展Collection协议适用于集合中的元素遵循了Equatable协议的情况,通过限制集合元素遵循Equatable协议
//作为标准库的一部分你可以使用==和!=操作符来检查两个元素的等价性和非等价性
//如果一个遵循的类型满足了为同一方法或属性提供实现的多个限制型扩展的要求则Swift会使用最匹配限制的实现

extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]

print(equalNumbers.allEqual())
print(differentNumbers.allEqual())


