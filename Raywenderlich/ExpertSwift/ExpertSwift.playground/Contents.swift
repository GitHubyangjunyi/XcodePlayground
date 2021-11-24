import UIKit

public func example(of description: String, action: () -> Void) {
  print("\n——— Example of:", description, "———")
  action()
}

let numbers = [1, 2, 4, 10, -1, 2, -10]

// 从左到右添加一个数字序列但在出现负数时停止
example(of: "functional, early-exit") {
  let total = numbers.reduce((accumulating: true, total: 0))
    { (state, value) in
      if state.accumulating && value >= 0 {
        return (accumulating: true, state.total + value)
      }
      else {
        return (accumulating: false, state.total)
      }
    }.total
  print(total)
}

example(of: "imperative, early-exit") {
  var total = 0
  for value in numbers {
    guard value >= 0 else { break }
    total += value
  }
  print(total)
}

example(of: "imperative, early-exit with just-in-time mutability") {
  let total: Int = {
    // same-old imperative code
    var total = 0
    for value in numbers {
      guard value >= 0 else { break }
      total += value
    }
    return total
  }()
  print(total)
}




// 类型擦除
func ifelse(_ condition: Bool,
            _ valueTrue: Any,
            _ valueFalse: Any) -> Any {
  condition ? valueTrue : valueFalse
}

var value = ifelse(.random(), 100, 0) as! Int

// 比类型擦除更好的范型
func ifelseG<V>(_ condition: Bool,
               _ valueTrue: V,
               _ valueFalse: V) -> V {
  condition ? valueTrue : valueFalse
}

// let value = ifelse(.random(), "100", 0)  // doesn’t compile anymore
value = ifelseG(.random(), 100, 0)


func expensiveValue1() -> Int {
  print("side-effect-1")
  return 2
}

func expensiveValue2() -> Int {
  print("side-effect-2")
  return 1729
}

var taxicab = ifelse(.random(),
                     expensiveValue1(),
                     expensiveValue2())


func ifelse<V>(_ condition: Bool,
               _ valueTrue: () -> V,
               _ valueFalse: () -> V) -> V {
  condition ? valueTrue() : valueFalse()
}

value = ifelse(.random(), { 100 }, { 0 })

taxicab = ifelse(.random(), { expensiveValue1() }, { expensiveValue2() })


func ifelse<V>(_ condition: Bool,
               _ valueTrue: @autoclosure () -> V,
               _ valueFalse: @autoclosure () -> V) -> V {
  condition ? valueTrue() : valueFalse()
}

value = ifelse(.random(), 100, 0 )

taxicab = ifelse(.random(), expensiveValue1(), expensiveValue2())




func expensiveFailingValue1() throws -> Int {
  print("side-effect-1")
  return 2
}

func expensiveFailingValue2() throws -> Int {
  print("side-effect-2")
  return 1729
}

// let failableTaxicab = ifelse(.random(),
//                             try expensiveFailingValue1(),
//                             try expensiveFailingValue2())



func ifelseThrows<V>(_ condition: Bool,
               _ valueTrue: @autoclosure () throws -> V,
               _ valueFalse: @autoclosure () throws -> V) throws -> V {
  condition ? try valueTrue() : try valueFalse()
}

var taxicab2 = try ifelseThrows(.random(),
                                try expensiveFailingValue1(),
                                try expensiveFailingValue2())




func ifelseTR<V>(_ condition: Bool,
               _ valueTrue: @autoclosure () throws -> V,
               _ valueFalse: @autoclosure () throws -> V) rethrows -> V {
  condition ? try valueTrue() : try valueFalse()
}

value = ifelse(.random(), 100, 0 )
taxicab = ifelse(.random(),
                     expensiveValue1(),
                     expensiveValue2())
taxicab2 = try ifelseTR(.random(),
                          try expensiveFailingValue1(),
                          try expensiveFailingValue2())
let taxicab3 = try ifelseTR(.random(),
                           expensiveValue1(),
                           try expensiveFailingValue2())
let taxicab4 = try ifelseTR(.random(),
                          try expensiveFailingValue1(),
                          expensiveValue2())





struct Point: Equatable {
  var x, y: Double
}

struct Size: Equatable {
  var width, height: Double
}

struct Rectangle: Equatable {
  var origin: Point
  var size: Size
}

// 对于值类型==如果存储的属性也是Equatable类型编译器将为您生成所需的方法
// 引用类型要求你写==的Equatable和hash(into:)为Hashable自己

extension Point {
  func flipped() -> Self {
    Point(x: y, y: x)
  }

  mutating func flip() {
    self = flipped()
  }
}

// 通过一个mutating方法Swift传递了一个不可见的self: inout Self


