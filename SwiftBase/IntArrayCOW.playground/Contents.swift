import UIKit

//类类型的存储类,是引用类型
fileprivate class IntArrayBuffer {
    var storage: [Int]

    init() {
        storage = []
    }
    
    init(buffer: IntArrayBuffer) {
        storage = buffer.storage//创建一个新的缓存实例
    }
}

struct IntArray {
    private var buffer: IntArrayBuffer
    
    init() {
        buffer = IntArrayBuffer()
    }
    
    func describe() {
        print(buffer.storage)
    }
    
    mutating func insert(_ value: Int, at index: Int) {
        copyIfNeeded()
        buffer.storage.insert(value, at: index)
    }
    
    mutating func append(_ value: Int) {
        copyIfNeeded()
        buffer.storage.append(value)
    }
    
    mutating func remove(at index: Int) {
        copyIfNeeded()
        buffer.storage.remove(at: index)
    }

    //确保数组的数据在需要修改时被复制,只要不修改􏰸􏰹数据,integers的副􏰞本指向􏰴􏲆同一个底层存储􏰏􏰵􏰶就不会出现问题
    private mutating func copyIfNeeded() {
        if !isKnownUniquelyReferenced(&buffer) {//检查buffer是否只有一个引用,实际上这个函数不会修改传递􏰌􏰍给它的􏱧参数
                print("Making a copy of \(buffer.storage)")
                buffer = IntArrayBuffer(buffer: buffer)//创建一个IntArrayBuffer的新实例并赋给buffer􏱍属性
        }
    }
}

var integers = IntArray()
integers.append(1)
integers.append(2)
integers.append(4)
integers.describe()

var ints = integers
ints.insert(3, at: 2)
integers.describe()
ints.describe()

//当需要修改一个实例时就要用新缓存􏱣,
//􏰬􏰭调用一个方法来插入/添加或删除􏱵􏰛数据时,如果IntArrayBuffer不是被唯􏲒一引􏰋用的就需要创建一个新的实例
//在这种情况下copyIfNeeded()会创建一个新的IntArrayBuffer并将其赋给IntArray的buffer􏱍属性
