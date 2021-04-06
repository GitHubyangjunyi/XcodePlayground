import UIKit

//面向轨道编程
//比如对于即将输入的数字x我们希望输出4 / (2 / x - 1)的计算结果
//这里会有两处出错的可能一是(2 / x)时x为0
//另一个就是(2 / x - 1)为0
let errorStr = "输入错误我很抱歉"
func cal(value: Float) {
    if value == 0 {
        print(errorStr)
    } else {
        let value1 = 2 / value
        let value2 = value1 - 1
        if value2 == 0 {
            print(errorStr)
        } else {
            let value3 = 4 / value2
            print(value3)
        }
    }
}
cal(value: 2.0)    //输入错误我很抱歉
cal(value: 1.0)    //4.0
cal(value: 0.0)    //输入错误我很抱歉


final class Box<T> {
    let value: T
    init(value: T) {
        self.value = value
    }
}

enum Result<T> {
    case Success(Box<T>)
    case Failure(String)
}


func call(value: Float) {
    func cal1(value: Float) -> Result<Float> {
        if value == 0 {
            return .Failure(errorStr)
        } else {
            return .Success(Box(value: 2 / value))
        }
    }
    func cal2(value: Result<Float>) -> Result<Float> {
        switch value {
        case .Success(let v):
            return .Success(Box(value: v.value - 1))
        case .Failure(let str):
            return .Failure(str)
        }
    }
    func cal3(value: Result<Float>) -> Result<Float> {
        switch value {
        case .Success(let v):
            if v.value == 0 {
                return .Failure(errorStr)
            } else {
                return .Success(Box(value: 4 / v.value))
            }
        case .Failure(let str):
            return .Failure(str)
        }
    }

    let r = cal3(value: cal2(value: cal1(value: value)))
    switch r {
    case .Success(let v):
        print(v.value)
    case .Failure(let s):
        print(s)
    }
}
cal(value: 2)    //输入错误我很抱歉
cal(value: 1)    //4.0
cal(value: 0)    //输入错误我很抱歉


//上面的代码switch的操作重复而多余都在重复着把Success和Failure分开的逻辑
//实际上每个函数只需要处理Success的情况,我们在Result中加入funnel提前处理掉Failure的情况

//enum Result<T> {
//    case Success(Box<T>)
//    case Failure(String)
//
//    func funnel<U>(f:(T) -> Result<U>) -> Result<U> {
//        switch self {
//        case .Success(let value):
//            return f(value.value)
//        case .Failure(let errString):
//            return Result<U>.Failure(errString)
//        }
//    }
//}

//funnel帮我们把上次的结果进行分流只将Success的轨道对接到了下个业务上而将Failure引到了下一个Failure轨道上
//此时我们已经不再需要传入Result值了只需要传入value即可
//
//    func cal(value: Float) {
//        func cal1(v: Float) -> Result<Float> {
//            if v == 0 {
//                return .Failure(errorStr)
//            } else {
//                return .Success(Box(2 / v))
//            }
//        }
//
//        func cal2(v: Float) -> Result<Float> {
//            return .Success(Box(v - 1))
//        }
//
//        func cal3(v: Float) -> Result<Float> {
//            if v == 0 {
//                return .Failure(errorStr)
//            } else {
//                return .Success(Box(4 / v))
//            }
//        }
//
//        let r = cal1(value).funnel(cal2).funnel(cal3)
//        switch r {
//        case .Success(let v):
//            print(v.value)
//        case .Failure(let s):
//            print(s)
//        }
//    }
//看起来简洁了一些我们可以通过cal1(value).funnel(cal2).funnel(cal3)这样的链式调用来获取计算结果

