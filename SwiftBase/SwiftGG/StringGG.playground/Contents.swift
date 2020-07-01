import UIKit

//首先明确String是值类型意味着在方法或者函数中传递时会进行值拷贝
let threeMoreDoubleQuotationMarks = #"""
Here are three more double quotes: """
"""#

let extensionString = #"Line1 \n Line"#

let extensionStringLF = #"Line1 \#n Line"#

//字符数组初始化
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)

//多行字符串拼接注意事项
let badStart = """
one
two
"""
let end = """
three
"""
print(badStart + end)
//打印两行:
//one
//twothree

let goodStart = """
one
two

"""
print(goodStart + end)
//one
//two
//three

//索引访问
let greeting = "Guten Tag!"
greeting[greeting.startIndex]
//G
greeting[greeting.index(before: greeting.endIndex)]//endIndex属性可以获取最后一个Character的后一个位置的索引
//因此endIndex属性不能作为一个字符串的有效下标
//!
greeting[greeting.index(after: greeting.startIndex)]
//u
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
//a

for index in greeting.indices {
   print("\(greeting[index]) ", terminator: "")
}

//插入和删除
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
//welcome变量现在等于"hello!"
welcome.insert(contentsOf:" there", at: welcome.index(before: welcome.endIndex))
//welcome变量现在等于"hello there!"

welcome.remove(at: welcome.index(before: welcome.endIndex))
//welcome现在等于"hello there"
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
//welcome现在等于"hello"

//子字符串与内存空间复用
let greetinga = "Hello, world!"
let indexa = greetinga.firstIndex(of: ",") ?? greeting.endIndex
let beginning = greetinga[..<index]
//beginning的值为"Hello"
//把结果转化为String以便长期存储
let newString = String(beginning)

//UTF编码
let dogString = "Dog‼🐶"
for codeUnit in dogString.utf8 {
    print("\(codeUnit) ", terminator: "")
}
print("")
//68 111 103 226 128 188 240 159 144 182

for codeUnit in dogString.utf16 {
    print("\(codeUnit) ", terminator: "")
}
print("")
//68 111 103 8252 55357 56374

for scalar in dogString.unicodeScalars {
    print("\(scalar.value) ", terminator: "")
}
print("")
//68 111 103 8252 128054


for scalar in dogString.unicodeScalars {
    print("\(scalar) ")
}
//D
//o
//g
//‼
//🐶
