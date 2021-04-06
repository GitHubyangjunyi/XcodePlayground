import UIKit


let apples = 3
let oranges = 5
//每行行首的缩进会被去除直到和结尾引号的缩进相匹配
let quotation = """
            I said "I have \(apples) apples."
    And then I said "I have \(apples + oranges) pieces of fruit."
    """
print(quotation)


let softWrappedQuotation = """
    The White Rabbit put on his spectacles.  "Where shall I begin, \
    please your Majesty?" he asked.

    "Begin at the beginning," the King said gravely, "and go on \
    till you come to the end; then stop."
    """
print(softWrappedQuotation)

// 不以换行开头或结尾的多行字符串文字
let singleLineString = "These are the same."
let multilineString = """
These are the same.
"""

// 以换行开头或结尾的多行字符串文字
let lineBreaks = """

This string starts with a line break.
It also ends with a line break.

"""
print(lineBreaks)
print("xxxx")


// 扩展字符串分隔符
let extensionString = #"Line1 \n Line"#
print(extensionString)
let extensionStringLF = #"Line1 \#n Line"#
print(extensionStringLF)
let threeMoreDoubleQuotationMarks = #"""
Here are three more double quotes: """
"""#

print(#"Write an interpolated string in Swift using \(multiplier)."#)
print(#"6 times 7 is \#(6 * 7)."#)
// 在插值字符串内的括号内编写的表达式不能包含未转义的反斜杠（\），回车符或换行符



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

// 创建一个包含全部索引的范围
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
//把结果转化为String以便长期存储,因为它重用了原String的内存空间,原String的内存空间必须保留直到它的Substring不再被使用为止
let newString = String(beginning)

//UTF编码
let dogString = "Dog‼🐶"
for codeUnit in dogString.utf8 {
    print("\(codeUnit) ", terminator: "")
}
print("")
//68 111 103     226 128 188      240 159 144 182

for codeUnit in dogString.utf16 {
    print("\(codeUnit) ", terminator: "")
}
print("")
//68 111 103     8252     55357 56374

for scalar in dogString.unicodeScalars {
    print("\(scalar.value) ", terminator: "")
}
print("")
//68 111 103     8252     128054


for scalar in dogString.unicodeScalars {
    print("\(scalar) ")
}
//D
//o
//g
//‼
//🐶


// 可扩展的字形群可以由多个Unicode标量组成这意味着不同的字符以及相同字符的不同表示方式可能需要不同数量的内存空间来存储
// 所以Swift中的字符在一个字符串中并不一定占用相同的内存空间数量因此在没有获取字符串的可扩展的字符群的范围时候就不能计算出字符串的字符数量
// 如果你正在处理一个长字符串需要注意count属性必须遍历全部的Unicode标量来确定字符串的字符数量
// 另外需要注意的是通过count属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同
// NSString的length属性是利用UTF-16表示的十六位代码单元数字而不是Unicode可扩展的字符群集
