import UIKit

//具有不透明返回类型的函数或方法会隐藏返回值的类型信息
//函数不再提供具体的类型作为返回类型而是根据它支持的协议来描述返回值
//在处理模块和调用代码之间的关系时隐藏类型信息非常有用,因为返回的底层数据类型仍然可以保持私有
//而且不同于返回协议类型,不透明类型能保证类型一致性——编译器能获取到类型信息同时模块使用者却不能获取到

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    
    func draw() -> String {
        var result = [String]()
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
//*
//**
//***

//你可以利用泛型来实现垂直翻转之类的操作就像下面这样
//然而这种方式有一个很大的局限在于翻转操作的结果会暴露我们用于构造结果的泛型类型

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
//***
//**
//*



struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print(joinedTriangles.draw())
// *
// **
// ***
// ***
// **
// *

//暴露构造所用的具体类型会造成类型信息的泄露
//因为ASCII几何图形模块的部分公开接口必须声明完整的返回类型,而实际上这些类型信息并不应该被公开声明
//输出同一种几何图形模块内部可能有多种实现方式,而外部使用时应该与内部各种变换顺序的实现逻辑无关
//诸如JoinedShape和FlippedShape这样包装后的类型,模块使用者并不关心,它们也不应该可见
//模块的公开接口应该由拼接、翻转等基础操作组成,这些操作也应该返回独立的Shape类型的值


//你可以认为不透明类型和泛型相反
//泛型允许调用一个方法时为这个方法的形参和返回值指定一个与实现无关的类型
//举个例子下面这个函数的返回值类型就由它的调用者决定
//func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
//x和y的值由调用max(_:_:)的代码决定,而它们的类型决定了T的具体类型
//调用代码可以使用任何遵循了Comparable协议的类型,函数内部也要以一种通用的方式来写代码才能应对调用者传入的各种类型
//max(_:_:)的实现就只使用了所有遵循Comparable协议的类型共有的特性

//而在返回不透明类型的函数中上述角色发生了互换,不透明类型允许函数实现时选择一个与调用代码无关的返回类型
//比如下面的例子返回了一个梯形,却没直接输出梯形的底层类型

print("不透明类型")
struct Square: Shape {
    var size: Int
    
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    
    let trapezoid = JoinedShape(top: top, bottom: JoinedShape(top: middle, bottom: bottom))
    
    return trapezoid
}

let trapezoid = makeTrapezoid()
print(trapezoid.draw())
//*
//**
//**
//**
//**
//*

//这个例子中makeTrapezoid()函数将返回值类型定义为some Shape
//因此该函数返回遵循Shape协议的给定类型,而不需指定任何具体类型
//这样写makeTrapezoid()函数可以表明它公共接口的基本性质——返回的是一个几何图形——而不是部分的公共接口生成的特殊类型
//上述实现过程中使用了两个三角形和一个正方形还可以用其他多种方式重写画梯形的函数,都不必改变返回类型
//这个例子凸显了不透明返回类型和泛型的相反之处,makeTrapezoid()中代码可以返回任意它需要的类型,只要这个类型是遵循Shape协议的
//就像调用泛型函数时可以使用任何需要的类型一样,这个函数的调用代码需要采用通用的方式,就像泛型函数的实现代码一样才能让makeTrapezoid()返回的任何Shape类型的值都能被正常使用


print("将不透明返回类型和泛型结合起来")
//你也可以将不透明返回类型和泛型结合起来
//下面的两个泛型函数也都返回了遵循Shape协议的不透明类型

func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    JoinedShape(top: top, bottom: bottom)
}

let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
print(opaqueJoinedTriangles.draw())
//*
//**
//***
//***
//**
//*

//这个例子中opaqueJoinedTriangles的值和前文不透明类型解决的问题中关于泛型的那个例子中的joinedTriangles完全一样
//不过和前文不一样的是flip(-:)和join(-:-:)将对泛型参数的操作后的返回结果包装成了不透明类型,这样保证了在结果中泛型参数类型不可见
//两个函数都是泛型函数,因为他们都依赖于泛型参数,而泛型参数又将FlippedShape和JoinedShape所需要的类型信息传递给它们
//如果函数中有多个地方返回了不透明类型那么所有可能的返回值都必须是同一类型
//即使对于泛型函数,不透明返回类型可以使用泛型参数,但仍需保证返回类型唯一
//比如下面就是一个非法示例——包含针对Square类型进行特殊处理的翻转函数

//func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//    if shape is Square {
//        return shape //错误：返回类型不一致
//    }
//    return FlippedShape(shape: shape) //错误：返回类型不一致
//}

//如果你调用这个函数时传入一个Square类型那么它会返回Square类型否则它会返回一个FlippedShape类型
//这违反了返回值类型唯一的要求,所以invalidFlip(_:)不正确
//修正invalidFlip(_:)的方法之一就是将针对Square的特殊处理移入到FlippedShape的实现中去,这样就能保证这个函数始终返回FlippedShape

struct FlippedShapeW<T: Shape>: Shape {
    var shape: T
    
    func draw() -> String {
        if shape is Square {
            return shape.draw()
        }
        
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

//返回类型始终唯一的要求并不会影响在返回的不透明类型中使用泛型,比如下面的函数就是在返回的底层类型中使用了泛型参数

func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}

//这种情况下返回的底层类型会根据T的不同而发生变化
//但无论什么形状被传入repeat(shape:count:)都会创建并返回一个元素为相应形状的数组,尽管如此返回值始终还是同样的底层类型[T]所以这符合不透明返回类型始终唯一的要求



//不透明类型和协议类型的区别
//虽然使用不透明类型作为函数返回值看起来和返回协议类型非常相似,但这两者有一个主要区别就在于是否需要保证类型一致性
//一个不透明类型只能对应一个具体的类型,即便函数调用者并不能知道是哪一种类型
//协议类型可以同时对应多个类型只要它们都遵循同一协议
//总的来说协议类型更具灵活性,底层类型可以存储更多样的值,而不透明类型对这些底层类型有更强的限定
//比如这是flip(_:)方法不采用不透明类型而采用返回协议类型的版本


func protoFlip<T: Shape>(_ shape: T) -> Shape {
    return FlippedShape(shape: shape)
}

func protoFlipS<T: Shape>(_ shape: T) -> Shape {
    if shape is Square {
        return shape
    }

    return FlippedShape(shape: shape)
}

//修改后的代码根据代表形状的参数的不同可能返回Square实例或者FlippedShape实例,所以同样的函数可能返回完全不同的两个类型
//当翻转相同形状的多个实例时此函数的其他有效版本也可能返回完全不同类型的结果protoFlip(_:) 返回类型的不确定性意味着很多依赖返回类型信息的操作也无法执行了
//当翻转相同形状的多个实例时此函数的其他有效版本也可能返回完全不同类型的结果protoFlip(_:) 返回类型的不确定性意味着很多依赖返回类型信息的操作也无法执行了
//当翻转相同形状的多个实例时此函数的其他有效版本也可能返回完全不同类型的结果protoFlip(_:) 返回类型的不确定性意味着很多依赖返回类型信息的操作也无法执行了
//当翻转相同形状的多个实例时此函数的其他有效版本也可能返回完全不同类型的结果protoFlip(_:) 返回类型的不确定性意味着很多依赖返回类型信息的操作也无法执行了
//举个例子这个函数的返回结果就不能用==运算符进行比较了

let protoFlippedTriangle = protoFlip(smallTriangle)
let sameThing = protoFlip(smallTriangle)
//protoFlippedTriangle == sameThing  //错误


//上面的例子中最后一行的错误最直接的问题在于Shape协议中并没有包含对==运算符的声明
//如果你尝试加上这个声明那么你会遇到新的问题就是==运算符需要知道左右两侧参数的类型
//这类运算符通常会使用Self类型作为参数用来匹配符合协议的具体类型,但是由于将协议当成类型使用时会发生类型擦除所以并不能给协议加上对Self的实现要求
//这类运算符通常会使用Self类型作为参数用来匹配符合协议的具体类型,但是由于将协议当成类型使用时会发生类型擦除所以并不能给协议加上对Self的实现要求
//这类运算符通常会使用Self类型作为参数用来匹配符合协议的具体类型,但是由于将协议当成类型使用时会发生类型擦除所以并不能给协议加上对Self的实现要求
//这类运算符通常会使用Self类型作为参数用来匹配符合协议的具体类型,但是由于将协议当成类型使用时会发生类型擦除所以并不能给协议加上对Self的实现要求
//擦除得只会剩下当前协议类型-->我自己的理解
//擦除得只会剩下当前协议类型-->我自己的理解
//擦除得只会剩下当前协议类型-->我自己的理解
//擦除得只会剩下当前协议类型-->我自己的理解
//将协议类型作为函数的返回类型能更加灵活,函数只要返回遵循协议的类型即可,然而更具灵活性导致牺牲了对返回值执行某些操作的能力
//上面的例子就说明了为什么不能使用==运算符——它依赖于具体的类型信息,而这正是使用协议类型所无法提供的

//这种方法的另一个问题在于变换形状的操作不能嵌套,翻转三角形的结果是一个具体的Shape类型,如正方形,而protoFlip(_:)方法的则将遵循Shape协议的类型作为形参,然而协议类型的值并不遵循这个协议
//protoFlip(_:)的返回值也并不遵循Shape协议,这就是说protoFlip(protoFlip(smallTriange))这样的多重变换操作是非法的
//因为经过翻转操作后的结果类型并不能作为protoFlip(_:)的形参

//相比之下不透明类型则保留了底层类型的唯一性,Swift能够推断出关联类型,这个特点使得作为函数返回值不透明类型比协议类型有更大的使用场景
//比如下面这个例子是泛型中讲到的Container协议

protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container { }


//你不能将Container作为方法的返回类型,因为此协议有一个关联类型
//你也不能将它用于对泛型返回类型的约束因为函数体之外并没有暴露足够多的信息来推断泛型类型

//错误：有关联类型的协议不能作为返回类型
//func makeProtocolContainer<T>(item: T) -> Container {
//    return [item]
//}

//错误：没有足够多的信息来推断C的类型
//func makeProtocolContainer<T, C: Container>(item: T) -> C {
//    return [item]
//}

//而使用不透明类型some Container作为返回类型就能够明确地表达所需要的API契约——函数会返回一个集合类型但并不指明它的具体类型

func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item]
}
let opaqueContainer = makeOpaqueContainer(item: 12)
opaqueContainer.count
let twelve = opaqueContainer[0]
twelve
print(type(of: twelve))
//输出"Int"


//twelve的类型可以被推断出为Int说明了类型推断适用于不透明类型
//在makeOpaqueContainer(item:)的实现中,底层类型是不透明集合[T]
//在上述这种情况下T就是Int类型所以返回值就是整数数组
//而关联类型Item也被推断出为Int
//Container协议中的subscipt方法会返回Item,这也意味着twelve的类型也被能推断出为Int


