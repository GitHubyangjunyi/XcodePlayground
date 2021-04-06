import UIKit

//计算属性可以用于类/结构体和枚举,而存储属性只能用于类和结构体
//不能用于枚举类型是因为这样会导致两个同选项的枚举如果带有不同的存储属性将会失去同一性
//枚举可以拥有实例属性和静态属性,但是枚举实例属性不能是存储属性,如果相同的case的两个实例拥有不同的存储实例属性那么彼此之间就不相等,有悖于枚举的本质
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
//该区间表示整数0，1，2
rangeOfThreeItems.firstValue = 6
//该区间现在表示整数6，7，8


//常量结构体实例的存储属性
//如果创建了一个结构体实例并将其赋值给一个常量则无法修改该实例的任何属性,即使被声明为可变属性也不行
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
//该区间表示整数0，1，2，3
//rangeOfFourItems.firstValue = 6
//尽管firstValue是个可变属性但这里还是会报错
//这种行为是由于结构体属于值类型而值类型的实例被声明为常量的时候它的所有属性也就成了常量


//延时加载存储属性
//延时加载存储属性是指当第一次被调用的时候才会计算其初始值的属性
//如果一个被标记为lazy的实例属性在没有初始化时就同时被多个线程访问则无法保证该属性只会被初始化一次
//存储型类型属性是延迟初始化的它们只有在第一次被访问的时候才会被初始化
//即使它们被多个线程同时访问系统也保证只会对其进行一次初始化并且不需要对其使用lazy修饰符
//DataImporter是一个负责将外部文件中的数据导入的类,这个类的初始化会消耗不少时间
class DataImporter {
    var fileName = "data.txt"
    //这里会提供数据导入功能
}

class DataManager {
    lazy var importer = DataImporter()//初始化这个类时消耗时间
    var data = [String]()
    //这里会提供数据管理功能
}
//DataManager管理数据时也可能不从文件中导入数据所以当DataManager的实例被创建时没必要创建一个DataImporter实例
//更明智的做法是第一次用到DataImporter的时候才去创建它
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
//DataImporter实例的importer属性还没有被创建
print(manager.importer.fileName)
//DataImporter实例的importer属性现在被创建了输出“data.txt”


//存储属性和实例变量
//Objective-C为类实例存储值和引用提供两种方法
//除了属性之外还可以使用实例变量作为一个备份存储将变量值赋值给属性
//Swift编程语言中把这些理论统一用属性来实现
//Swift中的属性没有对应的实例变量,属性的备份存储也无法直接访问,这就避免了不同场景下访问方式的困扰


//只读计算属性
//必须使用var关键字定义计算属性,包括只读计算属性,因为它们的值不是固定的
//只读计算属性的声明可以去掉get关键字和花括号


//属性观察器
//可以为除了延时加载存储属性之外的其他存储属性添加属性观察器,也可以在子类中通过重写属性的方式为继承的属性,包括存储属性和计算属性添加属性观察器
//你不必为非重写的计算属性添加属性观察器,因为你可以直接通过它的setter监控和响应值的变化

//willSet在新的值被设置之前调用
//didSet在新的值被设置之后调用
//willSet观察器会将新的属性值作为常量参数传入,在willSet的实现代码中可以为这个参数指定一个名称如果不指定则参数仍然可用,这时使用默认名称newValue
//同样didSet观察器会将旧的属性值作为参数传入,可以为该参数指定一个名称或者使用默认参数名oldValue,如果在didSet方法中再次对该属性赋值那么新值会覆盖旧的值
//注意在父类初始化方法调用之后,在子类构造器中给父类的属性赋值时会调用父类属性的willSet和didSet观察器
//而在父类初始化方法调用之前给子类的属性赋值时不会调用子类属性的观察器
//有关构造器代理的更多信息请参考值类型的构造器代理和类的构造器代理
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}

let stepCounter = StepCounter()

stepCounter.totalSteps = 200
stepCounter.totalSteps = 360

//如果将带有观察器的属性通过in-out方式传入函数
//willSet和didSet也会调用,这是因为in-out参数采用了拷入拷出内存模式：即在函数内部使用的是参数的copy，函数结束后又对参数重新赋值


//全局变量和局部变量
//计算属性和观察属性所描述的功能也可以用于全局变量和局部变量
//全局变量是在函数、方法、闭包或任何类型之外定义的变量
//局部变量是在函数、方法或闭包内部定义的变量
//另外在全局或局部范围都可以定义计算型变量和为存储型变量定义观察器
//计算型变量跟计算属性一样返回一个计算结果而不是存储值声明格式也完全一样
//注意全局的常量或变量都是延迟计算的，跟延时加载存储属性相似,不同的地方在于全局的常量或变量不需要标记lazy修饰符
//局部范围的常量和变量从不延迟计算


//类型属性
//  存储型类型属性可以是变量或常量
//  计算型类型属性跟实例的计算型属性一样只能定义成变量属性


//使用关键字static来定义类型属性
//在为类定义计算型类型属性时可以改用关键字class来支持子类对父类的实现进行重写
//class类型属性只能是计算属性
struct SomeStructureP {
    static var storedTypeProperty = "Some value."
    
    static var computedTypeProperty: Int {
        return 1
    }
}

enum SomeEnumerationP {
    static var storedTypeProperty = "Some value."
    
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value."
    
    static var computedTypeProperty: Int {
        return 27
    }
    
    //支持子类重写
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}


struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                //将当前音量限制在阈值之内
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                //存储当前音量作为新的最大输入音量
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}


var leftChannel = AudioChannel()
var rightChannel = AudioChannel()

leftChannel.currentLevel = 7
AudioChannel.maxInputLevelForAllChannels


rightChannel.currentLevel = 11
rightChannel.currentLevel
AudioChannel.maxInputLevelForAllChannels
leftChannel.currentLevel
//在第一个检查过程中didSet属性观察器将currentLevel设置成了不同的值但这不会造成属性观察器被再次调用



//属性包装器
//用来复用多个属性的getter和setter中的代码
//@propertyWrapper
//struct Name<Type> {
//    var wrappedValue: Type {
//        get {}
//        set {}
//    }
//    
//    init(wrappedValue: Type) {
//        self.wrappedValue = wrappedValue
//    }
//}
//属性包装器在管理属性如何存储和定义属性的代码之间添加了一个分隔层
//举例来说如果你的属性需要线程安全性检查或者需要在数据库中存储它们的基本数据那么必须给每个属性添加同样的逻辑代码
//当使用属性包装器时你只需在定义属性包装器时编写一次管理代码然后应用到多个属性上来进行复用
//定义一个属性包装器需要创建一个定义wrappedValue属性的结构体、枚举或者类
//在下面的代码中TwelveOrLess结构体确保它包装的值始终是小于等于12的数字,如果要求它存储一个更大的数字它则会存储12这个数字
@propertyWrapper
struct TwelveOrLess {
    private var number: Int
    
    init() { self.number = 0 }
    
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

//height和width属性从TwelveOrLess的定义中获取它们的初始值
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
rectangle.height

rectangle.height = 10
rectangle.height

rectangle.height = 24
rectangle.height


//当你把一个包装器应用到一个属性上时编译器将合成提供包装器存储空间和通过包装器访问属性的代码
//因为属性包装器只负责存储被包装值所以没有合成这些代码
//不利用这个特性语法的情况下你可以写出使用属性包装器行为的代码
//举例来说这是先前代码清单中的SmallRectangle的另一个版本,这个版本将其属性明确地包装在TwelveOrLess结构体中而不是把@TwelveOrLess作为特性写下来
struct SmallRectangleBad {
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    
    var height: Int {
        get {
            return _height.wrappedValue
        }
        set {
            _height.wrappedValue = newValue
        }
    }
    
    var width: Int {
        get {
            return _width.wrappedValue
        }
        set {
            _width.wrappedValue = newValue
        }
    }
}


//设置被包装属性的初始值
//上面例子中的代码通过在TwelveOrLess的定义中赋予number一个初始值来设置被包装属性的初始值
//使用这个属性包装器的代码无法为被TwelveOrLess包装的属性指定其他初始值
//举例来说SmallRectangle的定义没法给height或者width一个初始值
//为了支持设定一个初始值或者其他自定义操作属性包装器需要添加一个构造器
//这是TwelveOrLess的扩展版本称为SmallNumber
//SmallNumber定义了能设置被包装值和最大值的构造器
@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }

    //默认包装12以下且初始值为0
    init() {
        maximum = 12
        number = 0
    }
    
    //默认包装12以下且自定义初始值
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    
    //自定义最大值包装值和初始值
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}


//当你把包装器应用于属性且没有设定初始值时Swift使用init()构造器来设置包装器
struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}

var zeroRectangle = ZeroRectangle()
zeroRectangle.height
zeroRectangle.width

//当你为属性指定初始值时Swift使用init(wrappedValue:)构造器来设置包装器
//当你对一个被包装的属性写下= 1时这被转换为调用init(wrappedValue:)构造器
//调用SmallNumber(wrappedValue: 1)来创建包装height和width的SmallNumber的实例
//构造器使用此处指定的被包装值且使用的默认最大值为12
struct UnitRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}

var unitRectangle = UnitRectangle()
unitRectangle.height
unitRectangle.width


//当你在自定义特性后面把实参写在括号里时Swift使用接受这些实参的构造器来设置包装器
//举例来说如果你提供初始值和最大值Swift使用init(wrappedValue:maximum:)构造器
struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}

var narrowRectangle = NarrowRectangle()
narrowRectangle.height
narrowRectangle.width

narrowRectangle.height = 100
narrowRectangle.width = 100
narrowRectangle.height
narrowRectangle.width

//通过将实参包含到属性包装器中你可以设置包装器的初始状态或者在创建包装器时传递其他的选项
//这种语法是使用属性包装器最通用的方法,你可以为这个属性提供任何所需的实参且它们将被传递给构造器
//当包含属性包装器实参时你也可以使用赋值来指定初始值
//Swift将赋值视为wrappedValue参数且使用接受被包含的实参的构造器,举个例子
struct MixedRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber(maximum: 9) var width: Int = 2
}

var mixedRectangle = MixedRectangle()
mixedRectangle.height
mixedRectangle.width

mixedRectangle.width = 20
mixedRectangle.width


//从属性包装器中呈现一个值
//除了被包装值外属性包装器可以通过定义被呈现值暴露出其他功能
//举个例子,管理对数据库的访问的属性包装器可以在它的被呈现值上暴露出flushDatabaseConnection()方法
//除了以货币符号$开头,被呈现值的名称和被包装值是一样的
//因为你的代码不能够定义以$开头的属性所以被呈现值永远不会与你定义的属性有冲突
//在之前SmallNumber的例子中如果你尝试把这个属性设置为一个很大的数值属性包装器会在存储这个数值之前调整这个数值
//以下的代码把被呈现值添加到SmallNumber结构体中来追踪在存储新值之前属性包装器是否为这个属性调整了新值
@propertyWrapper
struct SmallNumberDisplay {
    private var number: Int
    var projectedValue: Bool
    
    init() {
        number = 0
        projectedValue = false
    }
    
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
}



struct SomeStructure {
    @SmallNumberDisplay var someNumber: Int
}
var someStructure = SomeStructure()
someStructure.someNumber = 4
print(someStructure.$someNumber)

someStructure.someNumber = 55
print(someStructure.$someNumber)

//写下someStructure.$someNumber即可访问包装器的被呈现值
//在存储一个比较小的数值4时,someStructure.$someNumber的值为false
//但是在尝试存储一个较大的数值5时,被呈现值变为true
//属性包装器可以返回任何类型的值作为它的被呈现值
//在这个例子里属性包装器要暴露的信息是：那个数值是否被调整过,所以它暴露出布尔型值来作为它的被呈现值
//需要暴露出更多信息的包装器可以返回其他数据类型的实例或者可以返回自身来暴露出包装器的实例并把其作为它的被呈现值
//当从类型的一部分代码中访问被呈现值,例如属性getter或实例方法
//你可以在属性名称之前省略self.就像访问其他属性一样
//以下示例中的代码用$height和$width引用包装器height和width的被呈现值
enum SizeW {
    case small, large
}

struct SizedRectangle {
    @SmallNumberDisplay var height: Int
    @SmallNumberDisplay var width: Int

    mutating func resize(to size: SizeW) -> Bool {
        switch size {
            case .small:
                height = 1
                width = 2
            case .large:
                height = 100
                width = 100
        }
        return $height || $width
    }
}

//因为属性包装器语法只是具有getter和setter的属性的语法糖所以访问height和width的行为与访问任何其他属性的行为相同
//举个例子resize(to:)中的代码使用它们的属性包装器来访问height和width
//如果调用resize(to: .large)
//.large的switch case分支语句把矩形的高度和宽度设置为100
//属性包装器防止这些属性的值大于12且把被呈现值设置成为true来记下它调整过这些值的事实
//在resize(to:)的最后返回语句检查$height和$width来确认是否属性包装器调整过height或width
var sizedRectangle = SizedRectangle()
sizedRectangle.resize(to: .small)
sizedRectangle.resize(to: .small)
sizedRectangle.resize(to: .large)






