import UIKit

//func fib1(n: UInt) -> UInt {
//    return fib1(n: n - 1) + fib1(n: n - 2)
//}

func fib2(n: UInt) -> UInt {
    if n < 2 {
        return n    //基本情形用作终止点
    }
    return fib2(n: n - 1) + fib2(n: n - 2)
}

fib2(n: 4)

//使用计算缓存
var fibMemo: [UInt : UInt] = [0 : 1, 1 : 1]
func fibm(n: UInt) -> UInt {
    if let result = fibMemo[n] {
        return result
    } else {
        fibMemo[n] = fibm(n: n - 1) + fibm(n: n - 2)
    }
    return fibMemo[n]!
}


fibm(n: 4)


//性能更高的迭代法
func fibi(n: UInt) -> UInt {
    if n == 0 {
        return n
    }
    var last: UInt = 0, next: UInt = 1
    for _ in 1..<n {
        (last, next) = (next, last + next)
    }
    return next
}

fibi(n: 4)









