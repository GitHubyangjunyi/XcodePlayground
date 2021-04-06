import UIKit

//Swift 5.2中引入的callAsFunction它可以让我们直接以“调用实例”的方式call一个方法
//使用起来很简单只需要创建一个名称为callAsFunction的实例方法就可以了

struct Adder {
    let value: Int
    
    func callAsFunction(_ input: Int) -> Int {
      return input + value
    }
}

let add2 = Adder(value: 2)
let value = add2(1)
print(value)



public class Delegate<Input, Output> {
    public init() {}
    
    private var block: ((Input) -> Output?)?
    public func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
        self.block = { [weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }
    
    public func call(_ input: Input) -> Output? {
        return block?(input)
    }
    
    func callAsFunction(_ input: Input) -> Output? {
        return block?(input)
    }
}

public extension Delegate where Input == Void {
    func call() -> Output? {
        return call(())
    }
}

//如果Delegate<Input, Output>中的Output是一个可选值的话那么call之后的结果将会是双重可选的Output??
let onReturnOptional = Delegate<Int, Int?>()
let valueOptional = onReturnOptional.call(1)
print(valueOptional ?? 1)
// valueOptional : Int??
//这可以让我们区分出block没有被设置的情况和Delegate确实返回nil的情况
//当onReturnOptional.delegate(on:block:)没有被调用过(block 为 nil)时value是简单的nil
//但如果delegate被设置了但是闭包返回的是nil时,value的值将为.some(nil),在实际使用上这很容易造成困惑
//绝大多数情况下我们希望把.none，.some(.none)和.some(.some(value))这样的返回值展平到单层Optional的.none或.some(value)

//要解决这个问题可以对Delegate进行扩展为那些Output是Optional情况提供重载的call(_:)实现
//不过Optional是带有泛型参数的类型所以我们没有办法写出像是extension Delegate where Output == Optional这样的条件扩展
//一个“取巧”的方式是自定义一个新的OptionalProtocol让extension基于where Output: OptionalProtocol来做条件扩展

public protocol OptionalProtocol {
    static var createNil: Self { get }
}

extension Optional : OptionalProtocol {
    public static var createNil: Optional<Wrapped> {
         return nil
    }
}

extension Delegate where Output: OptionalProtocol {
    public func call(_ input: Input) -> Output {
        if let result = block?(input) {
            return result
        } else {
            return .createNil
        }
    }
}
//这样即使Output为可选值,block?(input)调用所得到的结果也可以经过if let解包并返回单层的result或是nil

