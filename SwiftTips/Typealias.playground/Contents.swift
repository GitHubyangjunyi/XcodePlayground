import UIKit

typealias Location = CGPoint
typealias Distance = Double


func distance(from point: Location, to anotherPoint: Location) -> Distance {
    let dx = Distance(anotherPoint.x - point.x)
    let dy = Distance(anotherPoint.y - point.y)
    return sqrt(dx * dx + dy * dy)
}

let origin: Location = CGPoint(x: 0, y: 0)
let point: Location = CGPoint(x: 1, y: 1)

let d = distance(from: origin, to: point)


//typealias是单一的必须指定将某个特定的类型通过typealias赋值为新名字而不能将整个泛型类型进行typealias
class Person<T> {}

//错误行为
//typealias Worker = Person
//typealias Worker = Person<T>

//如果在别名中也引入泛型可以通过
typealias Worker<T> = Person<T>


typealias WorkId = String
typealias Workere = Person<WorkId>

//另一个场景是某个类型同时实现多个协议组合时
protocol Cat {}
protocol Dog {}

typealias Pat = Cat & Dog



