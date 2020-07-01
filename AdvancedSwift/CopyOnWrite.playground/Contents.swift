import UIKit

//使用NSMutableData作为内部引用类型来重新实现写时复制
//Foundation框架中的Data结构体是值类型
var input: [UInt8] = [0x0b, 0xad, 0xf0, 0x0d]
var other: [UInt8] = [0x0d]
var d = Data.init(input)
var e = d
d.append(contentsOf: other)
print(d)
print(e)
//使用Data是相互独立的

print("使用NSMutableData是共享的")
var f = NSMutableData(bytes: &input, length: input.count)
var g = f
f.append(&other, length: other.count)
print(f)
print(g)

f === g


print("简单地将NSMutableData封装到结构体中并不能自动得到值语义")
struct MyData {
    var _data: NSMutableData
    init(_ data: NSData) {
        self._data = data.mutableCopy() as! NSMutableData
    }
}

let theData = NSData(base64Encoded: "wAEP/w==", options: [])!
let x = MyData(theData)
let y = x
print(x)
print(y)
x._data === y._data

extension MyData {
    func append(_ other: MyData) {
        _data.append(other._data as Data)
    }
}

x.append(x)
print(x)
print(y)



print("写时复制的昂贵方式")
struct MyDataE {
    fileprivate var _data: NSMutableData
    var _dataForWriting: NSMutableData {
        mutating get {
            _data = _data.mutableCopy() as! NSMutableData
            return _data
        }
    }
    
    init(_ data: NSData) {
        self._data = data.mutableCopy() as! NSMutableData
    }
}

extension MyDataE {
    mutating func append(_ other: MyDataE) {
        _dataForWriting.append(other._data as Data)
    }
}

var xe = MyDataE(theData)
let ye = xe
xe._data === ye._data
xe.append(xe)
xe._data === ye._data

print(xe)
print(ye)


//如果多次使用同一个变量则效率很低
var buffer = MyDataE(NSData())
for _ in 0 ..< 5 {
    buffer.append(xe)
}
print(buffer)



print("写时复制的高效方式")
final class Box<A> {
    var unbox: A
    init(_ value: A) {
        self.unbox = value
    }
}

var bx = Box(NSMutableData())
isKnownUniquelyReferenced(&bx)
var by = bx
isKnownUniquelyReferenced(&bx)

struct MyDataF {
    fileprivate var _data: Box<NSMutableData>
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                print("Making a Copy")
            }
            return _data.unbox  //要获取的是最底层的数据
        }
    }
    
    init(_ data: NSData) {
        self._data = Box(data.mutableCopy() as! NSMutableData)
    }
}

extension MyDataF {
    mutating func append(_ other: MyDataF) {
        _dataForWriting.append(other._data.unbox as Data)
    }
}

let someBytes = MyDataF(NSData(base64Encoded: "wAEP/w==", options: [])!)
var empty = MyDataF(NSData())
var emptyCopy = empty
for i in 0 ..< 5 {
    print(i)
    empty.append(someBytes)
}
empty._dataForWriting
print(empty._dataForWriting)
print(emptyCopy._dataForWriting)



print("使用inout才能改变数组并且数组需要var")
var ax: Array<Any> = [1, 2, 3]

 func change(_ a: inout Array<Any>) {
    a.append(contentsOf: [4])
}

change(&ax)
print(ax)



print("写时复制的陷阱")
final class Empty {}

struct COWStruct {
    var ref = Empty()
    
    mutating func change() -> String {
        if isKnownUniquelyReferenced(&ref) {
            return "No Copy"
        } else {
            return "Copy"
        }
        //进行实际的改变
    }
}

var s = COWStruct()
s.change()

var original = COWStruct()
var copyo = original
original.change()


//将结构体放入数组可以直接改变数组元素且不需要复制
//因为使用数组下标访问将直接访问到内存的相应位置
var array = [COWStruct()]
array[0].change()


var otherArray = [COWStruct()]
var xx = array[0]
xx.change()


//字典的下标将会在字典中寻找值然后返回
//因为是在值语义下进行处理的所以返回的是找到的值的复制
var dictx = ["key" : COWStruct()]
dictx["key"]?.change()      //书上是Copy但是在Swift 5.1环境下这里是No Copy


struct ContainerStruct<A> {
    var storage: A
    subscript(s: String) -> A {
        get { return storage }
        set { storage = newValue }
    }
}

var ds = ContainerStruct(storage: COWStruct())
ds.storage.change()
ds["test"].change()


//Array的下标使用了特别的处理来让写时复制生效但其他类型都没有使用这种技术
//Swift团队提到过希望提取这种技术的范式并将其应用到字典上
//Array使用地址器实现下标
//地址器允许对内存的直接访问
//数组的下标并不是返回的元素而是返回一个元素的地址器
//元素的内存可以直接原地改变而不需要进行不必要的复制
