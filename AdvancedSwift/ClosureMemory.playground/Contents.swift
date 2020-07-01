import UIKit

typealias USDCents = Int

class Account {
    var funds: USDCents = 0
    init(funds: USDCents) {
        self.funds = funds
    }
}

func transfer(amount: USDCents, source: Account, destination: Account) -> Bool {
    guard source.funds >= amount else {
        return false
    }
    source.funds -= amount
    destination.funds += amount
    return true
}

let alice = Account(funds: 1000)
let bob = Account(funds: 0)

transfer(amount: 50, source: alice, destination: bob)
print(alice.funds)
print(bob.funds)

//以上代码不是线程安全的
//不能在同一时间里从不同的线程调用这个函数进行转账操作
//应该使用串行队列


//纯结构体实现账户
struct AccountS {
    var funds: USDCents
}

func transfer(amount: USDCents, source: AccountS, destination: AccountS) -> (source: AccountS, destination: AccountS)? {
    guard source.funds >= amount else {
        return nil
    }
    var newSource = source
    var newDestination = destination
    newSource.funds -= amount
    newDestination.funds += amount
    return (newSource, newDestination)
}

func transferio(amount: USDCents, source: inout AccountS, destination: inout AccountS) -> Bool {
    guard source.funds >= amount else {
        return false
    }
    source.funds -= amount
    destination.funds += amount
    return true
}

var alices = AccountS(funds: 100)
var bobs = AccountS(funds: 0)

transferio(amount: 50, source: &alices, destination: &bobs)
print(alices.funds)
print(bobs.funds)

//当调用含有inout修饰的函数时需要为变量加上&
//但是这里与C指针的语法不同,并不代表传递引用
//当函数返回的时候被改变的值将会被复制回调用者中
