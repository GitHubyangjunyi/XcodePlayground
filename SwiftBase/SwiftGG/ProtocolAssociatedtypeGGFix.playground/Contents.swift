import UIKit

//关联类型
//定义一个协议时,声明一个或多个关联类型作为协议定义的一部分将会非常有用
//关联类型为协议中的某个类型提供了一个占位符名称,其代表的实际类型在协议被遵循时才会被指定



//Container容器协议定义了三个任何遵循该协议的类型,即容器必须提供的功能
//必须可以通过append(_:)方法添加一个新元素到容器里
//必须可以通过count属性获取容器中元素的数量并返回一个Int值
//必须可以通过索引值类型为Int的下标检索到容器中的每一个元素

//该协议没有指定容器中元素该如何存储以及元素类型,该协议只指定了任何遵从Container协议的类型必须提供的三个功能
//遵从协议的类型在满足这三个条件的情况下也可以提供其他额外的功能
//任何遵从Container协议的类型必须能够指定其存储的元素的类型,具体来说它必须确保添加到容器内的元素以及下标返回的元素类型是正确的
//为了定义这些条件Container协议需要在不知道容器中元素的具体类型的情况下引用这种类型
//Container协议需要指定任何通过append(_:)方法添加到容器中的元素和容器内的元素是相同类型并且通过容器下标返回的元素的类型也是这种类型
//为此Container协议声明了一个关联类型Item写作associatedtype Item
//协议没有定义Item是什么,这个信息留给遵从协议的类型来提供,尽管如此Item别名提供了一种方式来引用Container中元素的类型并将之用于append(_:)方法和下标
//从而保证任何Container的行为都能如预期


protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}


//非泛型版本的栈实现Container协议
struct IntStack: Container {
    var items = [Int]()
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    //Container协议的实现部分
    //将抽象的Item转换为具体的类型
    //由于Swift的类型推断实际上在IntStack的定义中不需要声明Item为Int
    typealias Item = Int
    
    mutating func append(_ item: Int) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
}



//泛型版本的栈实现Container协议
struct Stack<Element>: Container {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    //Container协议的实现部分
    //占位类型参数Element被用作append(_:)方法的item参数和下标的返回类型
    //Swift可以据此推断出Element的类型即是Item的类型
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}


//扩展现有类型来指定关联类型
//在扩展添加协议一致性中描述了如何利用扩展让一个已存在的类型遵循一个协议,这包括使用了关联类型协议
//Swift的Array类型已经提供append(_:)方法,count属性以及带有Int索引的下标来检索其元素,这三个功能都符合Container协议的要求
//也就意味着你只需声明Array遵循Container协议就可以扩展Array使其遵从Container协议,你可以通过一个空扩展来实现这点,正如通过扩展采纳协议中的描述
extension Array: Container {}


//给关联类型添加约束
//你可以在协议里给关联类型添加约束来要求遵循的类型满足约束
//例如下面的代码定义了Container协议,要求关联类型Item必须遵循Equatable协议
protocol ContainerEquatable {
    associatedtype Item: Equatable
    
    mutating func append(_ item: Item)
    
    var count: Int { get }
    
    subscript(i: Int) -> Item { get }
}



//在关联类型约束里使用协议
//协议可以作为它自身的要求出现
//例如有一个协议细化了Container协议添加了一个suffix(_:)方法,返回容器中从后往前给定数量的元素并把它们存储在一个Suffix类型的实例里
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

//在这个协议里Suffix是一个关联类型就像上边例子中Container的Item类型一样
//Suffix拥有两个约束
//它必须遵循当前定义的SuffixableContainer协议,也就是自身
//它的Item类型必须是和容器里的Item类型相同

extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }
    //推断suffix结果是Stack
}

var stackOfInts = Stack<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
let suffix = stackOfInts.suffix(2)
//在上面的例子中Suffix是Stack的关联类型,也是Stack,所以Stack的后缀运算返回另一个Stack
//另外遵循SuffixableContainer的类型可以拥有一个与它自己不同的Suffix类型——也就是说后缀运算可以返回不同的类型
//比如说这里有一个非泛型IntStack类型的扩展,它遵循了SuffixableContainer协议,使用Stack<Int>作为它的后缀类型而不是IntStack
extension IntStack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack<Int> {
        var result = Stack<Int>()
        
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }
    //推断suffix结果是Stack<Int>
}


//泛型Where语句
//通过泛型where子句让关联类型遵从某个特定的协议以及某个特定的类型参数和关联类型必须类型相同
//你可以通过将where关键字紧跟在类型参数列表后面来定义where子句
//where子句后跟一个或者多个针对关联类型的约束以及一个或多个类型参数和关联类型间的相等关系
//你可以在函数体或者类型的大括号之前添加where子句
//下面的例子定义了一个名为allItemsMatch的泛型函数用来检查两个Container实例是否包含相同顺序的相同元素
//如果所有的元素能够匹配那么返回true否则返回false
//被检查的两个Container可以不是相同类型的容器,虽然它们可以相同,但它们必须拥有相同类型的元素
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {

        //检查两个容器含有相同数量的元素
        if someContainer.count != anotherContainer.count {
            return false
        }

        //检查每一对元素是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        //所有元素都匹配返回true
        return true
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}



//具有泛型Where子句的扩展
//这个startsWith(_:)方法首先确保容器至少有一个元素然后检查容器中的第一个元素是否与给定的元素相等
//任何符合Container协议的类型都可以使用这个新的startsWith(_:)方法包括上面使用的栈和数组,只要容器的元素是符合Equatable协议的就可以
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}


if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}


//特定类型遵循
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
print([12.0, 12.0, 98.0, 0.0].average())



//具有泛型Where子句的关联类型
//你可以在关联类型后面加上具有泛型where的字句
//例如建立一个包含迭代器Iterator的容器,就像是标准库中使用的Sequence协议那样

protocol ContainerW {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }

    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}
//迭代器Iterator的泛型where子句要求无论迭代器是什么类型,迭代器中的元素类型必须和容器项目的类型保持一致
//makeIterator()则提供了容器的迭代器的访问接口



//一个协议继承了另一个协议,通过在协议声明的时候包含泛型where子句来添加了一个约束到被继承协议的关联类型
//例如下面的代码声明了一个ComparableContainer协议它要求所有的Item必须是Comparable的
protocol ComparableContainer: ContainerW where Item: Comparable { }



//泛型下标
//泛型下标能够包含泛型where子句
//你可以在subscript后用尖括号来写占位符类型,你还可以在下标代码块花括号前写where子句
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item] where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}

//这Container协议的扩展添加了一个下标方法,接收一个索引的集合返回每一个索引所在的值的数组
//这个泛型下标的约束如下
//在尖括号中的泛型参数Indices必须是符合标准库中的Sequence协议的类型
//下标使用的单一的参数indices必须是Indices的实例
//泛型where子句要求Sequence(Indices)的迭代器其所有的元素都是Int类型
//这样就能确保在序列Sequence中的索引和容器Container里面的索引类型是一致的
//综合一下这些约束意味着传入到indices下标是一个整型的序列
let arr = [1, 2, 3, 4, 5, 6, 7]
let arrIndex = [2, 3, 5]

arr[arrIndex]




//王巍Swifter
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
