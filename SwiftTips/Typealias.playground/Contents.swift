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



class Person<T> {}

//typealias Worker = Person
//typealias Worker = Person<T>


typealias Worker<T> = Person<T>


typealias WorkId = String
typealias Workere = Person<WorkId>


protocol Cat {}
protocol Dog {}

typealias Pat = Cat & Dog



