import UIKit

//当其他的实例有更短的生命周期时使用弱引用
//一个公寓在它的生命周期内会在某个时间段没有它的主人所以一个弱引用就加在公寓类里面
//当其他实例有相同的或者更长生命周期时请使用无主引用
//当ARC设置弱引用为nil时属性观察不会被触发

class Person {
    let name: String
    init(name: String) { self.name = name }
    
    lazy var apartment: Apartment? = Apartment.init(unit: "<#T##abc###>")
    
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    
    weak var tenant: Person?
    
    deinit { print("Apartment \(unit) is being deinitialized") }
}


var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john

john = nil


unit4A = nil


//在使用垃圾收集的系统里弱指针有时用来实现简单的缓冲机制
//因为没有强引用的对象只会在内存压力触发垃圾收集时才被销毁
//但是在ARC中一旦值的最后一个强引用被移除就会被立即销毁这导致弱引用并不适合上面的用途



//无主引用
//和弱引用类似,无主引用不会牢牢保持住引用的实例
//和弱引用不同的是无主引用在其他实例有相同或者更长的生命周期时使用
//你可以在声明属性或者变量时在前面加上关键字unowned表示这是一个无主引用
//无主引用通常都被期望拥有值,不过ARC无法在实例被销毁后将无主引用设为nil,因为非可选类型的变量不允许被赋值为nil
//重点
//使用无主引用你必须确保引用始终指向一个未销毁的实例
//如果你试图在实例被销毁后访问该实例的无主引用会触发运行时错误


class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}



var johnn: Customer?
johnn = Customer(name: "John Appleseed")
johnn!.card = CreditCard(number: 1234_5678_9012_3456, customer: johnn!)

john = nil
//打印“John Appleseed is being deinitialized”
//打印“Card #1234567890123456 is being deinitialized”

//上面的例子展示了如何使用安全的无主引用
//对于需要禁用运行时的安全检查的情况,例如出于性能方面的原因
//Swift还提供了不安全的无主引用,与所有不安全的操作一样你需要负责检查代码以确保其安全性
//你可以通过unowned(unsafe)来声明不安全无主引用
//如果你试图在实例被销毁后访问该实例的不安全无主引用,你的程序会尝试访问该实例之前所在的内存地址这是一个不安全的操作



//上面弱引用和无主引用的例子涵盖了两种常用的需要打破循环强引用的场景
//Person和Apartment的例子展示了两个属性的值都允许为nil并会潜在的产生循环强引用,这种场景最适合用弱引用来解决
//Customer和CreditCard的例子展示了一个属性的值允许为nil而另一个属性的值不允许为nil,这也可能会产生循环强引用,这种场景最适合通过无主引用来解决
//然而存在着第三种场景,两个属性都必须有值并且初始化完成后永远不会为nil,在这种场景中需要一个类使用无主属性而另外一个类使用隐式解包可选值属性
//这使两个属性在初始化完成后能被直接访问不需要可选展开,同时避免了循环引用

//每个国家必须有首都,每个城市必须属于一个国家
//为了实现这种关系Country类拥有一个capitalCity属性而City类有一个country属性
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
//Country的构造器调用了City的构造器,然而只有Country的实例完全初始化后Country的构造器才能把self传给City的构造器
//为了满足这种需求通过在类型结尾处加上感叹号的方式将Country的capitalCity属性声明为隐式解包可选值类型的属性,这意味着像其他可选类型一样capitalCity属性的默认值为nil
//但是不需要展开它的值就能访问它
//由于capitalCity默认值为nil一旦Country的实例在构造器中给name属性赋值后整个初始化过程就完成了
//这意味着一旦name属性被赋值后Country的构造器就能引用并传递隐式的self,Country的构造器在赋值capitalCity时就能将self作为参数传递给City的构造器
//上述的意义在于你可以通过一条语句同时创建Country和City的实例而不产生循环强引用,并且capitalCity的属性能被直接访问而不需要通过感叹号来展开它的可选值
var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
//打印“Canada's capital city is called Ottawa”


//闭包的循环强引用
//循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性并且这个闭包体中又使用了这个类实例时
//这个闭包体中可能访问了实例的某个属性例如self.someProperty或者闭包中调用了实例的某个方法例如self.someMethod()
//这两种情况都导致了闭包“捕获”self从而产生了循环强引用
//循环强引用的产生是因为闭包和类相似都是引用类型,当你把一个闭包赋值给某个属性时你是将这个闭包的引用赋值给了属性
//Swift提供了一种优雅的方法来解决这个问题称之为闭包捕获列表
//下面的例子为你展示了当一个闭包引用了self后是如何产生一个循环强引用的,例子中定义了一个叫HTMLElement的类用一种简单的模型表示HTML文档中的一个单独的元素
class HTMLElement {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}

//HTMLElement类定义了一个name属性来表示这个元素的名称,例如代表头部元素的"h1"代表段落的"p"或者代表换行的"br"
//HTMLElement还定义了一个可选属性text用来设置HTML元素呈现的文本
//除了上面的两个属性HTMLElement还定义了一个lazy属性asHTML,这个属性引用了一个将name和text组合成HTML字符串片段的闭包
//默认情况下闭包赋值给了asHTML属性,这个闭包返回一个代表HTML标签的字符串
//如果text值存在该标签就包含可选值text,如果text不存在该标签就不包含文本
//可以像实例方法那样去命名和使用asHTML属性
//然而由于asHTML是闭包而不是实例方法,如果你想改变特定HTML元素的处理方式的话可以用自定义的闭包来取代默认值
//例如可以将一个闭包赋值给asHTML属性,这个闭包能在text属性是nil时使用默认文本,这是为了避免返回一个空的HTML标签



let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())
//打印“<h1>some default text</h1>”

//asHTML声明为lazy属性因为只有当元素确实需要被处理为HTML输出的字符串时才需要使用asHTML
//也就是说在默认的闭包中可以使用self因为只有当初始化完成以及self确实存在后才能访问lazy属性

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
//打印“<p>hello, world</p>”

paragraph = nil
//虽然闭包多次使用了self它只捕获HTMLElement实例的一个强引用
//如果设置paragraph变量为nil打破它持有的HTMLElement实例的强引用
//HTMLElement实例和它的闭包都不会被销毁也是因为循环强引用




//解决闭包的循环强引用
//在定义闭包时同时定义捕获列表作为闭包的一部分,通过这种方式可以解决闭包和类实例之间的循环强引用
//捕获列表定义了闭包体内捕获一个或者多个引用类型的规则,跟解决两个类实例间的循环强引用一样声明每个捕获的引用为弱引用或无主引用而不是强引用
//注意Swift有如下要求
//只要在闭包内使用self的成员就要用self.someProperty或者self.someMethod()提醒你可能会一不小心就捕获了self
//定义捕获列表
//捕获列表中的每一项都由一对元素组成,一个元素是weak或unowned关键字,另一个元素是类实例的引用例如self或初始化过的变量如delegate = self.delegate,这些项在方括号中用逗号分开

//如果闭包有参数列表和返回类型把捕获列表放在它们前面
//lazy var someClosure = {
//    [unowned self, weak delegate = self.delegate]
//    (index: Int, stringToProcess: String) -> String in
//    //这里是闭包的函数体
//}

//如果闭包没有指明参数列表或者返回类型,它们会通过上下文推断,那么可以把捕获列表和关键字in放在闭包最开始的地方
//lazy var someClosure = {
//    [unowned self, weak delegate = self.delegate] in
//    // 这里是闭包的函数体
//}




//弱引用和无主引用
//在闭包和捕获的实例总是互相引用并且总是同时销毁时将闭包内的捕获定义为无主引用
//相反的在被捕获的引用可能会变为nil时将闭包内的捕获定义为弱引用
//弱引用总是可选类型并且当引用的实例被销毁后弱引用的值会自动置为nil,这使我们可以在闭包体内检查它们是否存在
//注意如果被捕获的引用绝对不会变为nil应该用无主引用而不是弱引用
//前面的HTMLElement例子中无主引用是正确的解决循环强引用的方法,这样编写HTMLElement类来避免循环强引用


class HTMLElementU {

    let name: String
    let text: String?

    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}

var paragraphU: HTMLElementU? = HTMLElementU(name: "p", text: "helloworld")
print(paragraphU!.asHTML())
//打印“<p>hello, world</p>”

paragraphU = nil
