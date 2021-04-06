import UIKit

let data = 1...3
var result = data.map { (i: Int) -> Int in
    print("正在处理 \(i)")
    return i * 2
}

print("准备访问结果")
for i in result {
    print("操作后结果为 \(i)")
}

print("操作完毕")

print("Lazy操作..........")
let resultLazy = data.lazy.map { (i: Int) -> Int in
    print("正在处理 \(i)")
    return i * 2
}

print("准备访问结果")
for i in resultLazy {
    print("操作后结果为 \(i)")
}

print("操作完毕")
//对于那些不需要完全运行可能提前退出的情况使用lazy来进行性能优化效果会非常有效



