import UIKit

//析构器只适用于类类型,当一个类的实例被释放之前析构器会被立即调用
//析构器是在实例释放发生前被自动调用的,你不能主动调用析构器
//子类继承了父类的析构器并且在子类析构器实现的最后,父类的析构器会被自动调用
//即使子类没有提供自己的析构器父类的析构器也同样会被调用
//因为直到实例的析构器被调用后实例才会被释放,所以析构器可以访问实例的所有属性并且可以根据那些属性可以修改它的行为


//Bank类管理一种虚拟硬币确保流通的硬币数量永远不可能超过10000,在游戏中有且只能有一个Bank存在
class Bank {
    static var coinsInBank = 10000
    
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        //分发硬币之前检查是否有足够的硬币
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}


class Player {
    var coinsInPurse: Int
    
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}


var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
print("There are now \(Bank.coinsInBank) coins left in the bank")

playerOne!.win(coins: 2000)
print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
print("The bank now only has \(Bank.coinsInBank) coins left")


playerOne = nil
print("PlayerOne has left the game")
print("The bank now has \(Bank.coinsInBank) coins")


