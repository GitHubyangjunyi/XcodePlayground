import UIKit

//diff版本2021年03月26日



// 访问权限控制
//open          只使用在类上,通常在框架或者第三方库中,所有的文件都可以访问这个类/属性/方法,被标记为open的类可以被继承,方法可以在模块外也可以被重载
//public        与open类似,类也可以被继承,但是方法只能在模块内被重载
//internal      默认值,任何当前模块中的文件都可以访问这个类/属性和方法,对于app来说,只有项目中的文件可以访问,如果读者写了一个第三方库那么只有库中的文件可以访问,使用第三方库的app不能访问
//private       只能在当前作用域下可以访问并设置这个类/属性/方法,文件内其他作用域不可访问
//fileprivate   只能在当前文件内可以访问并设置这个类/属性/方法,文件外不可访问
//private(set)       能当前作用域下访问并设置这个类/属性/方法,作用域外只能访问不能设置
//fileprivate(set)   能当前文件内访问并设置这个类/属性/方法,文件外只能访问不能设置


//Swift5.3特性
//返回值是透明类型的函数依赖于5.1运行时
//try？表达式不会为已返回可选类型的代码引入额外的可选类型层级
//大整数字面量初始化代码的类型会被正确推导，例如UInt64(0xffff_ffff_ffff_ffff)将会被推导为整型类型而非溢出


let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0



//浮点数陷阱
let d1 = 1.1
let d2: Double = 1.1
let f1: Float = 100.3

if d1 == d2 {
    print("d1 and d2 are the same!")
}

print("d1 + 0.1 is \(d1 + 0.1)")
if d1 + 0.1 == 1.2 {
    print("d1 + 0.1 is equal to 1.2")//不会输出,因为浮点数不精确,不可比较
}


//求余运算符a % b是计算b的多少倍刚刚好可以容入a并返回多出来的那部分余数
//a = (b × 倍数) + 余数
9 % 4
-9 % -4
-9 % 4
//在对负数b求余时b的符号会被忽略


//算术运算符+-*/%等的结果会被检测并禁止值溢出以此来避免保存变量时由于变量大于或小于其类型所能承载的范围时导致的异常结果
//当然允许你使用溢出运算符来实现溢出
let y: Int8 = 120
var zx = y &+ 10
print("120 &+ 10 is \(zx)")

let yy: Int8 = -120
zx = yy &- 10
print("120 &+ 10 is \(zx)")





let ssss = Optional("sdfdfdf")
let sss: Optional<String> = "howy"
print(ssss)
print(sss)



//if-case
let ifcase = 25
if case 18...35 = ifcase, ifcase >= 21{
    print("In cool demographic and of drinking age")
}

//if case let
//if case let .success(image) = result {
//    photo.image = image
//}

//相当于

//switch result {
//case let .success(image):
//    photo.image = image
//default:
//    break
//}

//guard case let
//guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
//    case let .Success(image) = result else {
//        return
//}


// 断言和先决条件
//断言仅在调试环境运行
var age = -3
//assert(age >= 0, "年龄不能小于0")


age = 12
assert(age >= 0, "年龄不能小于0")
precondition(age > 10, "Index must be greater than zero.")
if age > 10 {
    print("age > 10")
} else if age > 0 {
    print("age > 0")
} else {
    assertionFailure("年龄不能小于0")
}


//先决条件则在调试环境和生产环境中运行
//当一个条件可能为假但是继续执行代码要求条件必须为真的时候需要使用先决条件
//强制执行先决条件
//例如使用先决条件来检查下标越界或者是否将一个正确的参数传给函数
//你可以使用全局precondition(_:_:file:line:)函数来写一个先决条件
//向这个函数传入一个结果为true或者false的表达式以及一条信息
//当表达式的结果为false的时候这条信息会被显示

//在一个下标的实现里...
//precondition(index > 0, "Index must be greater than zero.")


//你可以调用preconditionFailure(_:file:line:)方法来表明出现了一个错误
//例如switch进入了default分支但是所有的有效值应该被任意一个其他分支而非default分支处理

//如果你使用unchecked模式(-Ounchecked编译代码则先决条件将不会进行检查
//编译器假设所有的先决条件总是为true并将优化你的代码
//然而fatalError(_:file:line:)函数总是中断执行无论你怎么进行优化设定
//你能使用fatalError(_:file:line:)函数在设计原型和早期开发阶段,这个阶段只有方法的声明但是没有具体实现
//你可以在方法体中写上fatalError("Unimplemented")作为具体实现
//因为fatalError不会像断言和先决条件那样被优化掉所以你可以确保当代码执行到一个没有被实现的方法时程序会被中断

//assert(condition:message:file:line:)函数接受自动闭包作为它的condition参数和message参数
//它的condition参数仅会在debug模式下被求值,message参数仅当condition参数为false时被计算求值



//Range是泛型类型

//开区间
//stride函数支持浮点数进行区间计算
for _ in stride(from: 0, to: 60, by: 5) {
    //每5分钟渲染一个刻度线0, 5, 10, 15 ... 45, 50, 55
}

//闭区间
for _ in stride(from: 3, through: 12, by: 3) {
    //每3小时渲染一个刻度线3, 6, 9, 12
}

//for-where
for i in 1...100 where i % 3 == 0 {
    print(i)
}




//Defer
//使用defer代码块来表示在函数返回前最后执行的代码,无论函数是否会抛出错误这段代码都将执行
//使用defer可以把函数调用之初就要执行的代码和函数调用结束时的扫尾代码写在一起,虽然这两者的执行时机截然不同
//该语句让你能执行一些必要的清理工作不管是以何种方式离开当前代码块的——无论是由于抛出错误而离开或是由于诸如return、break的语句
//defer语句将代码的执行延迟到当前的作用域退出之前
//该语句由defer关键字和要被延迟执行的语句组成,延迟执行的语句不能包含任何控制转移语句,例如break、return语句或是抛出一个错误
//延迟执行的操作会按照它们声明的顺序从后往前执行,也就是说第一条defer语句中的代码最后才执行
//第二条defer语句中的代码倒数第二个执行以此类推
//最后一条语句会第一个执行
//即使没有涉及到错误处理的代码也可以使用defer语句


