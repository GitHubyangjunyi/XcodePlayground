import UIKit

// 判断一个给定的点是否在射程范围内内并且距离友方船只和自身都不太近
typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
    
    // 检查一个点是否在范围之内
    func within(range: Distance) -> Bool {
        sqrt(x * x + y * y) <= range
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    // 检查一艘船是否在开火范围之内
    func canEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
    
    // 仅瞄准在不安全范围(爆炸会影响到自己的范围)之外的敌人避免与过近的敌人交战
    func canSafelyEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
    
    // 避免敌方过于接近友方船只避免误伤
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        
        //              敌方在开火范围之内                       爆炸不会影响到自己                       爆炸不会影响到友方船只
        return (targetDistance <= firingRange) && (targetDistance > unsafeRange) && (friendlyDistance > unsafeRange)
    }
}

extension Position {
    // 距离原点的距离
    var length: Double {
        return sqrt(x * x + y * y)
    }
    
    // 与另一个点的距离差值
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
}

extension Ship {
    func canSafelyEngage2(ship target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        
        return (targetDistance <= firingRange) && (targetDistance > unsafeRange) && (friendlyDistance > unsafeRange)
    }
}


// 使用一个能判定给定点是否在区域内的函数来代表一个区域
// 而不是定义一个对象或者结构体来表示一个区域
// 并且这个函数的命名不会让人感觉它是个运算函数
// 函数式编程的核心理念就是函数是值并且跟其他类型没什么区别
// 对函数的命名使用面向对象或者面向过程的风格将会破坏这一核心理念使得函数式编程风格变得不纯

typealias Region = (Position) -> Bool

// 定义一个以原点为圆心半径为radius的圆
func circle(radius: Double) -> Region {
    // 给定一个参数point检查point是否在以原点为中心半径为radius的圆形区域内
    return { point in point.length <= radius }
}

// 定义一个原点为center半径为radius的圆
func circle2(radius: Double, center: Position) -> Region {
    return { point in point.minus(center).length <= radius }
}

// 为了避免写一大堆类似circle3 circle4的函数而编写一个函数来改变另一个函数(变换函数)
func shift(_ region: @escaping Region, by offset: Position) -> Region {
    return { point in region(point.minus(offset)) }
}


let shifted = shift(circle(radius: 10), by: Position(x: 5, y: 5))


// 反转区域
func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point) }
}

// 两个区域的交集
func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
    return { point in region(point) && other(point) }
}

// 两个区域的并集
func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
    return { point in region(point) || other(point) }
}

// 在第一个区域且不在第二个区域
func subtract(_ region: @escaping Region, from original: @escaping Region) -> Region {
    return intersect(original, with: invert(region))
}

// 重构canSafelyEngage
extension Ship {
    func canSafelyEngageRefacting(ship target: Ship, friendly: Ship) -> Bool {
        // 开火安全区
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        // 基于船只位置的开火安全区
        let firingRegion = shift(rangeRegion, by: position)
        // 基于友方船只位置的危险区域
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.position)
        // 不会伤及友方船只的开火安全区
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        return resultRegion(target.position)
    }
}



var f = CGRect(x: 5, y: 20, width: 80, height: 100)
f = f.insetBy(dx: 20, dy: 10)
print("移动后\(f)")












