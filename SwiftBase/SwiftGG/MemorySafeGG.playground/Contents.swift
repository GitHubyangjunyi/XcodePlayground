import UIKit

//Swift保证同时访问同一块内存时不会冲突,通过约束代码里对于存储地址的写操作去获取那一块内存的访问独占权
//内存访问的冲突会发生在你的代码尝试同时访问同一个存储地址的时侯
//同一个存储地址的多个访问同时发生会造成不可预计或不一致的行为
//在Swift里有很多修改值的行为都会持续好几行代码在修改值的过程中进行访问是有可能发生的


//注意
//如果你写过并发和多线程的代码,内存访问冲突也许是同样的问题
//然而这里访问冲突的讨论是在单线程的情境下讨论的并没有使用并发或者多线程
//如果你曾经在单线程代码里有访问冲突,Swift可以保证你在编译或者运行时会得到错误
//对于多线程的代码可以使用Thread Sanitizer去帮助检测多线程的冲突


//内存访问冲突时要考虑内存访问上下文中的这三个性质：访问是读还是写/访问的时长以及被访问的存储地址
//特别是冲突会发生在当你有两个访问符合下列的情况
//  至少有一个是写访问
//  它们访问的是同一个存储地址
//  它们的访问在时间线上部分重叠
//内存访问的时长要么是瞬时的要么是长期的
//如果一个访问不可能在其访问期间被其它代码访问那么就是一个瞬时访问
//正常来说两个瞬时访问是不可能同时发生的,大多数内存访问都是瞬时的
//例如下面列举的所有读和写访问都是瞬时的

func oneMore(than number: Int) -> Int {
    return number + 1
}

var myNumber = 1
myNumber = oneMore(than: myNumber)
print(myNumber)
//打印“2”


//重叠的访问主要出现在使用in-out参数的函数和方法或者结构体的mutating方法里



//In-Out参数的访问冲突
//一个函数会对它所有的in-out参数进行长期写访问
//in-out参数的写访问会在所有非in-out参数处理完之后开始,直到函数执行完毕为止
//如果有多个in-out参数则写访问开始的顺序与参数的顺序一致
//长期访问的存在会造成一个结果,你不能在访问以in-out形式传入后的原变量,即使作用域原则和访问权限允许——任何访问原变量的行为都会造成冲突

var stepSize = 1

func increment(_ number: inout Int) {
    number += stepSize
}

//increment(&stepSize)
//错误：stepSize访问冲突
//number和stepSize都指向了同一个存储地址,同一块内存的读和写访问重叠了就此产生了冲突

//解决这个冲突的一种方式是显示拷贝一份stepSize
//显式拷贝
var copyOfStepSize = stepSize
increment(&copyOfStepSize)

//更新原来的值
stepSize = copyOfStepSize
//stepSize现在的值是2

//当你在调用increment(_:)之前做一份拷贝,显然copyOfStepSize就会根据当前的stepSize增加,读访问在写操作之前就已经结束了所以不会有冲突


//长期写访问的存在还会造成另一种结果,往同一个函数的多个in-out参数里传入同一个变量也会产生冲突,例如
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)   //正常
//balance(&playerOneScore, &playerOneScore)   //错误：playerOneScore访问冲突
//上面的 balance(_:_:)函数会将传入的两个参数平均化
//将playerOneScore和playerTwoScore作为参数传入不会产生错误,有两个访问重叠了但它们访问的是不同的内存位置
//相反将 playerOneScore作为参数同时传入就会产生冲突因为它会发起两个写访问同时访问同一个的存储地址
//注意
//因为操作符也是函数,它们也会对in-out参数进行长期访问
//例如假设balance(_:_:)是一个名为<^>的操作符函数,那么playerOneScore<^>playerOneScore也会造成像balance(&playerOneScore, &playerOneScore)一样的冲突



//方法里self的访问冲突
//一个结构体的mutating方法会在调用期间对self进行写访问
//例如想象一下这么一个游戏,每一个玩家都有血量,受攻击时血量会下降,并且有敌人的数量,使用特殊技能时会减少敌人数量

struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}


//在上面的restoreHealth()方法里一个对于self的写访问会从方法开始直到方法return
//在这种情况下restoreHealth()里的其它代码不可以对Player实例的属性发起重叠的访问
//下面的shareHealth(with:)方法接受另一个Player的实例作 in-out参数产生了访问重叠的可能性

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)  //正常


//上面的例子里调用shareHealth(with:)方法去把oscar玩家的血量分享给maria玩家并不会造成冲突
//在方法调用期间会对oscar发起写访问因为在mutating方法里self就是oscar,同时对于maria也会发起写访问,因为maria作为in-out参数传入
//过程如下它们会访问内存的不同位置,即使两个写访问重叠了它们也不会冲突

//当然如果你将oscar作为参数传入shareHealth(with:)里就会产生冲突
//oscar.shareHealth(with: &oscar)
//错误：oscar访问冲突

//mutating方法在调用期间需要对self发起写访问而同时in-out参数也需要写访问,在方法里self和teammate都指向了同一个存储地址
//对于同一块内存同时进行两个写访问并且它们重叠了就此产生了冲突



//属性的访问冲突
//如结构体,元组和枚举的类型都是由多个独立的值组成的,例如结构体的属性或元组的元素
//因为它们都是值类型,修改值的任何一部分都是对于整个值的修改意味着其中一个属性的读或写访问都需要访问整一个值
//例如元组元素的写访问重叠会产生冲突

var playerInformation = (health: 10, energy: 20)
balance(&playerInformation.health, &playerInformation.energy)
//错误：playerInformation的属性访问冲突

//下面的代码展示了一样的错误,对于一个存储在全局变量里的结构体属性的写访问重叠了

var holly = Player(name: "Holly", health: 10, energy: 10)
balance(&holly.health, &holly.energy)  //错误


//在实践中大多数对于结构体属性的访问都会安全的重叠
//例如将上面例子里的变量holly改为本地变量而非全局变量编译器就会可以保证这个重叠访问是安全的

func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&oscar.health, &oscar.energy)  //正常
}


//限制结构体属性的重叠访问对于保证内存安全不是必要的
//保证内存安全是必要的但因为访问独占权的要求比内存安全还要更严格——意味着即使有些代码违反了访问独占权的原则也是内存安全的
//所以如果编译器可以保证这种非专属的访问是安全的那Swift就会允许这种行为的代码运行
//特别是当你遵循下面的原则时它可以保证结构体属性的重叠访问是安全的
//  你访问的是实例的存储属性而不是计算属性或类的属性
//  结构体是本地变量的值而非全局变量
//  结构体要么没有被闭包捕获要么只被非逃逸闭包捕获了
//  如果编译器无法保证访问的安全性它就不会允许那次访问

