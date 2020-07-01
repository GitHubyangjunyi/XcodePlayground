import UIKit

//函数被标注为@discardableResult属性告诉编译器允许在调用时忽略返回值


//游戏初始时所有的游戏等级除了等级1都被锁定
//每次有玩家完成一个等级这个等级就对这个设备上的所有玩家解锁
//LevelTracker结构体用类型属性和方法监测游戏的哪个等级已经被解锁,还监测每个玩家的当前等级

struct LevelTracker {
    static var highestUnlockedLevel = 1     //监测玩家已解锁的最高等级
    var currentLevel = 1                //监测每个玩家当前的等级

    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}


class Player {
    var tracker = LevelTracker()
    let playerName: String
    
    init(name: String) {
        playerName = name
    }
    
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
        //我们忽略了advance(to:)返回的布尔值是因为之前调用LevelTracker.unlock(_:)时就知道了这个等级已经被解锁了
    }
    
}

var player = Player(name: "Argyrios")
player.complete(level: 4)
print("解锁的最高等级为 \(LevelTracker.highestUnlockedLevel)")

var player1 = Player(name: "Beto")

if player1.tracker.advance(to: 6) {
    print("玩家位于等级6")
} else {
    print("等级6还未解锁")
}

//Player类创建一个新的LevelTracker实例来监测这个用户的进度
//它提供了complete(level:)方法,一旦玩家完成某个指定等级就调用它为所有玩家解锁下一等级,并且将当前玩家的进度更新为下一等级
//如果你创建了第二个玩家，并尝试让他开始一个没有被任何玩家解锁的等级那么试图设置玩家当前等级将会失败
//因为还没有玩家complete第5等级

