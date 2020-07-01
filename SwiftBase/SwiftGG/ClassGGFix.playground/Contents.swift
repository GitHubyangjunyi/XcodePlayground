import UIKit

class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        
        super.init(name: name)
        
        numberOfSides = 4
    }

    func area() ->  Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let test = Square(sideLength: 5, name: "my test square")
test.area()
test.simpleDescription()


let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square")
let sideLength = optionalSquare?.sideLength

//计算属性
class EquilateralTriangle: NamedShape {
    var sideLength: Double = 0.0

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        
        super.init(name: name)
        
        numberOfSides = 3
    }

    var perimeter: Double {
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }

    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
var triangle = EquilateralTriangle(sideLength: 3, name: "a triangle")
triangle.perimeter
triangle.perimeter = 9.9
triangle.sideLength

//构造器执行了三步：
//设置子类声明的属性值
//调用父类的构造器
//改变父类定义的属性值
//其他的工作比如调用方法、getters和setters也可以在这个阶段完成

//如果你不需要计算属性
//如果你不需要计算属性
//如果你不需要计算属性但是仍然需要在设置一个新值之前或者之后运行代码可以使用willSet和didSet
//写入的代码会在属性值发生改变时调用但不包含构造器中发生值改变的情况
//willSet和didSet
//确保三角形的边长总是和正方形的边长相同
class TriangleAndSquare {
    var triangle: EquilateralTriangle {
        willSet {
            square.sideLength = newValue.sideLength
        }
    }
    
    var square: Square {
        willSet {
            triangle.sideLength = newValue.sideLength
        }
    }
    
    init(size: Double, name: String) {
        square = Square(sideLength: size, name: name)
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape")
triangleAndSquare.square.sideLength
triangleAndSquare.triangle.sideLength
triangleAndSquare.square = Square(sideLength: 50, name: "larger square")
triangleAndSquare.square.sideLength
triangleAndSquare.triangle.sideLength



//继承
//在Swift中类可以调用和访问超类的方法、属性和下标,并且可以重写这些来优化或修改它们的行为
//可以为类中继承来的属性添加属性观察器,当属性值改变时类就会被通知到
//可以为任何属性添加属性观察器无论它原本被定义为存储型属性还是计算型属性

//重写
//在方法someMethod()的重写实现中可以通过super.someMethod()来调用超类版本的someMethod()方法
//在属性someProperty的getter或setter的重写实现中可以通过super.someProperty来访问超类版本的someProperty属性
//在下标的重写实现中可以通过super[someIndex]来访问超类版本中的相同下标

//重写方法
//在子类中你可以重写继承来的实例方法或类方法提供一个定制或替代的方法实现

//重写属性
//你可以重写继承来的实例属性或类型属性提供自己定制的getter和setter或添加属性观察器
//重写属性的Getters和Setters
//你可以提供定制的getter或setter来重写任何一个继承来的属性无论这个属性是存储型还是计算型属性
//子类并不知道继承来的属性是存储型的还是计算型的它只知道继承来的属性会有一个名字和类型
//你在重写一个属性时必须将它的名字和类型都写出来这样才能使编译器去检查你重写的属性是与超类中同名同类型的属性相匹配的

//你可以将一个继承来的只读属性重写为一个读写属性只需要在重写版本的属性里提供getter和setter即可
//但是你不可以将一个继承来的读写属性重写为一个只读属性
//如果你在重写属性中提供了setter那么你也一定要提供getter,如果你不想在重写版本中的getter里修改继承来的属性值可以直接通过 super.someProperty来返回继承来的值

//重写属性观察器
//你可以通过重写属性为一个继承来的属性添加属性观察器,这样一来无论被继承属性原本是如何实现的当其属性值发生改变时你就会被通知到
//你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器,这些属性的值是不可以被设置的
//所以为它们提供willSet或didSet实现也是不恰当
//此外还要注意不可以同时提供重写的setter和重写的属性观察器,如果你想观察属性值的变化并且你已经为那个属性提供了定制的setter那么你在setter中就可以观察到任何值变化了


//防止重写
//你可以通过把方法,属性或下标标记为final来防止它们被重写
//任何试图对带有final标记的方法、属性或下标进行重写的代码都会在编译时会报错
//在类扩展中的方法,属性或下标也可以在扩展的定义里标记为final
//可以通过在关键字class前添加final修饰符来将整个类标记为final,这样的类是不可被继承的试图继承这样的类会导致编译报错



//构造过程

//存储属性的初始赋值
//当你为存储型属性分配默认值或者在构造器中为设置初始值时它们的值是被直接设置的不会触发任何属性观察者


//
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double){
        temperatureInCelsius = celsius
    }
}

let bodyTemperature = Celsius(37.0)
bodyTemperature.temperatureInCelsius



//可选属性类型
//如果你自定义的类型有一个逻辑上允许值为空的存储型属性——无论是因为它无法在初始化时赋值还是因为它在之后某个时机可以赋值为空——都需要将它声明为可选类型
//可选类型的属性将自动初始化为nil表示这个属性是特意在构造过程设置为空

class SurveyQuestion {
    let text: String
    var response: String?
    
    init(text: String) {
        self.text = text
    }
    
    func ask() {
        print(text)
    }
}

let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese."



//构造过程中常量属性的赋值
//你可以在构造过程中的任意时间点给常量属性赋值只要在构造过程结束时它设置成确定的值
//一旦常量属性被赋值它将永远不可更。
//注意对于类的实例来说它的常量属性只能在定义它的类的构造过程中修改不能在子类中修改
//子类可以在构造过程修改继承来的变量属性但是不能修改继承来的常量属性


//默认构造器
//如果结构体或类为所有属性提供了默认值又没有提供任何自定义的构造器
//那么Swift会给这些结构体或类提供一个默认构造器,这个默认构造器将简单地创建一个所有属性值都设置为它们默认值的实例

class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()



//结构体默认成员构造器

struct Size {
    var width = 0.0, height = 0.0
}

let twoByTwo = Size(width: 2.0, height: 2.0)

let zeroByTwo = Size(height: 2.0)
print(zeroByTwo.width, zeroByTwo.height)

let zeroByZero = Size()
print(zeroByZero.width, zeroByZero.height)



//值类型的构造器代理
//构造器代理的实现规则和形式在值类型和类类型中有所不同
//值类型不支持继承所以构造器代理的过程相对简单因为它们只能代理给自己的其它构造器
//类则不同它可以继承自其它类,这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化
//对于值类型你可以使用self.init在自定义的构造器中引用相同类型中的其它构造器,并且你只能在构造器内部调用self.init
//请注意如果你为某个值类型定义了一个自定义的构造器你将无法访问到默认构造器,如果是结构体还将无法访问逐一成员构造器
//这种限制避免了在一个更复杂的构造器中做了额外的重要设置,但有人不小心使用自动生成的构造器而导致错误的情况
//注意,假如你希望默认构造器、逐一成员构造器以及你自己的自定义构造器都能用来创建实例,可以将自定义的构造器写到扩展中而不是写在值类型的原始定义中


struct Point {
    var x = 0.0, y = 0.0
}


struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}

    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}



//类的继承和构造过程
//Swift为类类型提供了两种构造器来确保实例中所有存储型属性都能获得初始值,称为指定构造器和便利构造器
//指定构造器是类中最主要的构造器,一个指定构造器将初始化类中提供的所有属性并调用合适的父类构造器让构造过程沿着父类链继续往上进行
//每一个类都必须至少拥有一个指定构造器,在某些情况下许多类通过继承了父类中的指定构造器而满足了这个条件,具体内容请参考后续章节构造器的自动继承
//便利构造器是类中比较次要的辅助型的构造器,你可以定义便利构造器来调用同一个类中的指定构造器并为部分形参提供默认值
//你也可以定义便利构造器来创建一个特殊用途或特定输入值的实例
//你应当只在必要的时候为类提供便利构造器,比方说某种情况下通过使用便利构造器来快捷调用某个指定构造器能够节省更多开发时间并让类的构造过程更清晰明了


//类类型的构造器代理
//为了简化指定构造器和便利构造器之间的调用关系Swift构造器之间的代理调用遵循以下三条规则
//规则1
//    指定构造器必须调用其直接父类的的指定构造器
//规则2
//    便利构造器必须调用同类中定义的其它构造器
//规则3
//    便利构造器最后必须调用指定构造器
//一个更方便记忆的方法是
//    指定构造器必须总是向上代理
//    便利构造器必须总是横向代理

//父类
//  Designate   <--Convenience   <--Convenience
//   /|\  /|\
//    |     \
//子类 |      \
//Designate   Designate    <--Convenience




//两段式构造过程
//第一个阶段类中的每个存储型属性赋一个初始值,当每个存储型属性的初始值被赋值后第二阶段开始,它给每个类一次机会在新实例准备使用之前进一步自定义它们的存储型属性
//两段式构造过程的使用让构造过程更安全同时在整个类层级结构中给予了每个类完全的灵活性
//两段式构造过程可以防止属性值在初始化之前被访问也可以防止属性被另外一个构造器意外地赋予不同的值
//Swift的两段式构造过程跟Objective-C中的构造过程类似,最主要的区别在于阶段1
//Objective-C给每一个属性赋值0或空值
//Swift的构造流程则更加灵活,它允许你设置定制的初始值并自如应对某些属性不能以0或nil作为合法默认值的情况
//Swift编译器将执行4种有效的安全检查以确保两段式构造过程不出错地完成
//安全检查1
//    指定构造器必须保证它所在类的所有属性都必须先初始化完成之后才能将其它构造任务向上代理给父类中的构造器
//如上所述一个对象的内存只有在其所有存储型属性确定之后才能完全初始化,为了满足这一规则指定构造器必须保证它所在类的属性在它往上代理之前先完成初始化
//安全检查2
//    指定构造器必须在为继承的属性设置新值之前向上代理调用父类构造器,如果没这么做指定构造器赋予的新值将被父类中的构造器所覆盖
//安全检查3
//    便利构造器必须为任意属性,包括所有同类中定义的属性赋新值之前代理调用其它构造器,如果没这么做便利构造器赋予的新值将被该类的指定构造器所覆盖
//安全检查4
//    构造器在第一阶段构造完成之前不能调用任何实例方法,不能读取任何实例属性的值,不能引用self作为一个值
//
//类的实例在第一阶段结束以前并不是完全有效的,只有第一阶段完成后类的实例才是有效的,才能访问属性和调用方法



//以下是基于上述安全检查的两段式构造过程展示
//阶段1
//  类的某个指定构造器或便利构造器被调用
//  完成类的新实例内存的分配但此时内存还没有被初始化
//  指定构造器确保其所在类引入的所有存储型属性都已赋初值,存储型属性所属的内存完成初始化
//  指定构造器切换到父类的构造器对其存储属性完成相同的任务
//  这个过程沿着类的继承链一直往上执行直到到达继承链的最顶部
//  当到达了继承链最顶部而且继承链的最后一个类已确保所有的存储型属性都已经赋值,这个实例的内存被认为已经完全初始化,此时阶段1完成
//阶段2
//  从继承链顶部往下继承链中每个类的指定构造器都有机会进一步自定义实例,构造器此时可以访问self,修改它的属性并调用实例方法等等
//  最终继承链中任意的便利构造器有机会自定义实例和使用self


//阶段1
//父类
//  Designate Safety Check 1    Convenience    Convenience
//                /|\
//                  \
//子类                \
//  Designate    Designate Safety Check 1    <--Convenience

//在这个例子中构造过程从对子类中一个便利构造器的调用开始,这个便利构造器此时还不能修改任何属性,它会代理到该类中的指定构造器
//如安全检查1所示指定构造器将确保所有子类的属性都有值然后它将调用父类的指定构造器并沿着继承链一直往上完成父类的构造过程
//父类中的指定构造器确保所有父类的属性都有值,由于没有更多的父类需要初始化也就无需继续向上代理
//一旦父类中所有属性都有了初始值,实例的内存被认为是完全初始化,阶段1完成

//以下展示了相同构造过程的阶段2
//父类
//  Designate Customize    Convenience    Convenience
//                 |
//                  \
//子类              \|/
//  Designate    Designate Customize -->  Convenience

//父类中的指定构造器现在有机会进一步自定义实例,尽管这不是必须的
//一旦父类中的指定构造器完成调用子类中的指定构造器可以执行更多的自定义操作,这也不是必须的
//最终一旦子类的指定构造器完成调用最开始被调用的便利构造器可以执行更多的自定义操作






//构造器的继承和重写
//跟Objective-C中的子类不同,Swift中的子类默认情况下不会继承父类的构造器
//Swift的这种机制可以防止一个父类的简单构造器被一个更精细的子类继承而在用来创建子类时的新实例时没有完全或错误被初始化
//注意父类的构造器仅会在安全和适当的某些情况下被继承,具体内容请参考后续章节构造器的自动继承
//假如你希望自定义的子类中能提供一个或多个跟父类相同的构造器，你可以在子类中提供这些构造器的自定义实现
//当你在编写一个和父类中指定构造器相匹配的子类构造器时你实际上是在重写父类的这个指定构造器,因此你必须在定义子类构造器时带上override修饰符
//即使你重写的是系统自动提供的默认构造器,也需要带上override修饰符
//注意当你重写一个父类的指定构造器时你总是需要写override修饰符,即使是为了实现子类的便利构造器
//相反的是如果你编写了一个和父类便利构造器相匹配的子类构造器,由于子类不能直接调用父类的便利构造器
//因此严格意义上来讲你的子类并未对一个父类构造器提供重写
//最后的结果就是你在子类中“重写”一个父类便利构造器时不需要加override修饰符

class Vehicle {
    var numberOfWheels = 0
    
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

//Vehicle类只为存储型属性提供默认值也没有提供自定义构造器
//因此它会自动获得一个默认构造器,默认构造器(如果有的话)总是类中的指定构造器

class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}

let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")



//如果子类的构造器没有在阶段2过程中做自定义操作并且父类有一个无参数的指定构造器,你可以在所有子类的存储属性赋值之后省略super.init()的调用
class Hoverboard: Vehicle {
    var color: String
    
    init(color: String) {
        self.color = color
        // super.init() 在这里被隐式调用
    }
    
    override var description: String {
        return "\(super.description) in a beautiful \(color)"
    }
}



//构造器的自动继承
//如上所述子类在默认情况下不会继承父类的构造器,但是如果满足特定条件父类构造器是可以被自动继承的
//事实上这意味着对于许多常见场景你不必重写父类的构造器并且可以在安全的情况下以最小的代价继承父类的构造器
//假设你为子类中引入的所有新属性都提供了默认值以下2个规则将适用
//规则1
//    如果子类没有定义任何指定构造器它将自动继承父类所有的指定构造器
//规则2
//    如果子类提供了所有父类指定构造器的实现——无论是通过规则1继承过来的还是提供了自定义实现——它将自动继承父类所有的便利构造器
//即使你在子类中添加了更多的便利构造器这两条规则仍然适用
//注意子类可以将父类的指定构造器实现为便利构造器来满足规则2


class Food {
    var name: String
    
    //指定构造器
    init(name: String) {
        self.name = name
    }

    //便利构造器
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()


//配方
class RecipeIngredient: Food {
    var quantity: Int
    
    //指定构造器
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    
    //便利构造器
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

//在这个例子中RecipeIngredient的父类是Food,它有一个便利构造器init()
//这个便利构造器会被RecipeIngredient继承,这个继承版本的init()在功能上跟Food提供的版本是一样的
//只是它会代理到RecipeIngredient版本的init(name: String)而不是Food提供的版本


let oneMysteryItem = RecipeIngredient()
oneMysteryItem.name
oneMysteryItem.quantity

let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)



class ShoppingListItems: RecipeIngredient {
    var purchased = false
    
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

//因为它为自己引入的所有属性都提供了默认值并且自己没有定义任何构造器所以ShoppingListItem将自动继承所有父类中的指定构造器和便利构造器

var breakfastList = [
    ShoppingListItems(),
    ShoppingListItems(name: "Bacon"),
    ShoppingListItems(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}



//可失败构造器
//为了妥善处理这种构造过程中可能会失败的情况,你可以在一个类,结构体或是枚举类型的定义中添加一个或多个可失败构造器,其语法为在init关键字后面添加问号init?
//注意可失败构造器的参数名和参数类型不能与其它非可失败构造器的参数名及其参数类型相同
//可失败构造器会创建一个类型为自身类型的可选类型的对象,通过return nil语句来表明可失败构造器在何种情况下应该失败
//严格来说构造器都不支持返回值,因为构造器本身的作用只是为了确保对象能被正确构造,因此你只是用return nil表明可失败构造器构造失败,而不要用关键字return来表明构造成功


//实现针对数字类型转换的可失败构造器,确保数字类型之间的转换能保持精确的值使用这个init(exactly:)构造器
//如果类型转换不能保持值不变则这个构造器构造失败
let wholeNumber: Double = 12345.0
let pi = 3.14159

if let valueMaintained = Int(exactly: wholeNumber) {
    print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
}

let valueChanged = Int(exactly: pi)

if valueChanged == nil {
    print("\(pi) conversion to Int does not maintain value")
}




//结构体可失败构造器

struct Animal {
    let species: String
    
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}


let someCreature = Animal(species: "Giraffe")
//someCreature的类型是Animal?而不是Animal
if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}


let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}



//枚举可失败构造器
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}

let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("成功")
}


let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("失败")
}



//带原始值的枚举类型的可失败构造器
//带原始值的枚举类型会自带一个可失败构造器init?(rawValue:)
enum TemperatureUnitX: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

let fahrenheitUnitX = TemperatureUnitX(rawValue: "F")
if fahrenheitUnitX != nil {
    print("成功")
}

let unknownUnitX = TemperatureUnitX(rawValue: "X")
if unknownUnitX == nil {
    print("失败")
}




//构造失败的传递
//类、结构体、枚举的可失败构造器可以横向代理到它们自己其他的可失败构造器,类似的子类的可失败构造器也能向上代理到父类的可失败构造器
//无论是向上代理还是横向代理,如果你代理到的其他可失败构造器触发构造失败整个构造过程将立即终止,接下来的任何构造代码不会再被执行
//注意可失败构造器也可以代理到其它的不可失败构造器,通过这种方式你可以增加一个可能的失败状态到现有的构造过程中

//下面这个例子定义了一个名为CartItem的Product类的子类,这个类建立了一个在线购物车中的物品的模型它有一个名为quantity的常量存储型属性并确保该属性的值至少为1
class Product {
    let name: String
    
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CartItem: Product {
    let quantity: Int
    
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}

if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}

if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("无法初始化0")
}




//重写一个可失败构造器
//如同其它的构造器一样,可以在子类中重写父类的可失败构造器
//或者你也可以用子类的非可失败构造器重写一个父类的可失败构造器,这使你可以定义一个不会构造失败的子类,即使父类的构造器允许构造失败
//注意当你用子类的非可失败构造器重写父类的可失败构造器时,向上代理到父类的可失败构造器的唯一方式是对父类的可失败构造器的返回值进行强制解包
//注意你可以用非可失败构造器重写可失败构造器,但反过来却不行


//这个类模拟一个文档并可以用name属性来构造,属性的值必须为一个非空字符串或nil但不能是一个空字符串
class Document {
    var name: String?
    
    //该构造器创建了一个name属性的值为nil的document实例
    init() {}
    
    //该构造器创建了一个name属性的值为非空字符串的document实例
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}


class AutomaticallyNamedDocument: Document {
    
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}
//AutomaticallyNamedDocument用一个不可失败构造器init(name:)重写了父类的可失败构造器init?(name:)
//因为子类用另一种方式处理了空字符串的情况所以不再需要一个可失败构造器,因此子类用一个不可失败构造器代替了父类的可失败构造器

class UntitledDocument: Document {
    
    override init() {
        super.init(name: "[Untitled]")! //强制解包
    }
}


//init!可失败构造器
//该可失败构造器将会构建一个对应类型的隐式解包可选类型的对象
//你可以在init?中代理到init!反之亦然
//你也可以用init?重写init!反之亦然
//你还可以用init代理到init!
//不过一旦 init!构造失败则会触发一个断言




//必要构造器
//在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器
//在子类重写父类的必要构造器时必须在子类的构造器前也添加required修饰符表明该构造器要求也应用于继承链后面的子类
//在重写父类中必要的指定构造器时不需要添加override修饰符
//如果子类继承的构造器能满足必要构造器的要求则无须在子类中显式提供必要构造器的实现


//通过闭包或函数设置属性的默认值
//如果某个存储型属性的默认值需要一些自定义或设置你可以使用闭包或全局函数为其提供定制的默认值
//每当某个属性所在类型的新实例被构造时对应的闭包或函数会被调用,而它们的返回值会当做默认值赋值给这个属性
//这种类型的闭包或函数通常会创建一个跟属性类型相同的临时变量然后修改它的值以满足预期的初始状态,最后返回这个临时变量作为属性的默认值


//注意闭包结尾的花括号后面接了一对空的小括号,这用来告诉Swift立即执行此闭包
//如果你忽略了这对括号相当于将闭包本身作为值赋值给了属性而不是将闭包的返回值赋值给属性
//注意如果你使用闭包来初始化属性,请记住在闭包执行时实例的其它部分都还没有初始化,这意味着你不能在闭包里访问其它属性,即使这些属性有默认值
//同样你也不能使用隐式的self属性或者调用任何实例方法

struct Chessboard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[(row * 8) + column]
    }
}

let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))
print(board.squareIsBlackAt(row: 7, column: 7))




