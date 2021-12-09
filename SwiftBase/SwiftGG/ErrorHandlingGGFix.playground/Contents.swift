import UIKit

//Swift使用遵循Error协议的类型来表示错误,这个空协议表明该类型可以用于错误处理
//使用throw抛出错误并用throws标记函数可以抛出错误(错误有很多种)
//只有throwing函数可以传递错误,任何在某个非throwing函数内部抛出的错误只能在函数内部处理
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

//一条do语句创建一个新的包含范围该范围允许将错误传播到一个或多个catch子句
//在catch代码块中除非你另外命名否则错误会自动命名为error
func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}

do {
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch {
    print(error)
}

//case风格的错误处理
do {
    let printerResponse = try send(job: 1440, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch PrinterError.outOfPaper {
    print("OutOfPaper.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

//可选错误处理try?
//如果函数抛出错误则该错误会被抛弃并且结果为nil否则结果是一个包含函数返回值的可选值
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Never Has Toner")
print(printerSuccess ?? "Job")
print(printerFailure == nil)


//Swift在运行时提供了抛出/捕获/传递/操作可恢复错误的一等支持
//1.你可以把函数抛出的错误传递给调用此函数的代码
//2.用do-catch语句处理错误
//3.将错误作为可选类型处理
//4.或者断言此错误根本不会发生

//与其他语言包括Objective-C的异常处理不同的是Swift中的错误处理并不涉及解除调用栈,这是一个计算代价高昂的过程
//就此而言throw语句的性能特性是可以和return语句相媲美的


//Swift的枚举类型尤为适合构建一组相关的错误状态
//枚举的关联值还可以提供错误状态的额外信息
//例如在游戏中操作自动贩卖机时你可以这样表示可能会出现的错误状态
//选择无效
//金额不足
//缺货
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var coinsDeposited = 0
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]

    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}
//在vend(itemNamed:)方法的实现中使用了guard语句来确保在购买某个物品所需的条件中有任一条件不满足时能提前退出方法并抛出相应的错误
//由于throw语句会立即退出方法所以物品只有在所有条件都满足时才会被售出


let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}


//throwing构造器能像throwing函数一样传递错误
//例如下面代码中的PurchasedSnack构造器在构造过程中调用了throwing函数并且通过传递到它的调用者来处理这些错误
struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
        print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}



//catch子句不必将do子句中的代码所抛出的每一个可能的错误都作处理
//如果所有catch子句都未处理错误,错误就会传递到周围的作用域
//然而错误还是必须要被某个周围的作用域处理的
//在不会抛出错误的函数中必须用do-catch语句处理错误
//而能够抛出错误的函数既可以使用do-catch 语句处理也可以让调用方来处理错误
//如果错误传递到了顶层作用域却依然没有被处理会得到一个运行时错误
//下面的代码为例不是VendingMachineError中申明的错误会在调用函数的地方被捕获

func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Invalid selection, out of stock, or not enough money.")
    }
}


do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("错误传递到此处进行处理\(error)")
}


//禁用错误传递
//有时你知道某个throwing函数实际上在运行时是不会抛出错误的
//在这种情况下你可以在表达式前面写try!来禁用错误传递
//这会把调用包装在一个不会有错误抛出的运行时断言中
//如果真的抛出了错误会得到一个运行时错误

//下面的代码使用了loadImage(atPath:)函数从给定的路径加载图片资源
//在这种情况下因为图片是和应用绑定的运行时不会有错误抛出所以适合禁用错误传递
//let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

