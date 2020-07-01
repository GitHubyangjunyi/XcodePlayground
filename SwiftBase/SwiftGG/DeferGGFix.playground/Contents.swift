import UIKit

//使用defer代码块来表示在函数返回前最后执行的代码
//无论函数是否会抛出错误这段代码都将执行
//使用defer可以把函数调用之初就要执行的代码和函数调用结束时的扫尾代码写在一起,虽然这两者的执行时机截然不同

var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]

func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }

    return fridgeContent.contains(food)
}
fridgeContains("banana")
fridgeIsOpen

//指定清理操作
//使用defer语句在即将离开当前代码块时执行一系列语句
//该语句让你能执行一些必要的清理工作不管是以何种方式离开当前代码块的——无论是由于抛出错误而离开或是由于诸如return、break的语句
//例如可以用defer语句来确保文件描述符得以关闭以及手动分配的内存得以释放
//defer语句将代码的执行延迟到当前的作用域退出之前
//该语句由defer关键字和要被延迟执行的语句组成,延迟执行的语句不能包含任何控制转移语句,例如break、return语句或是抛出一个错误
//延迟执行的操作会按照它们声明的顺序从后往前执行
//也就是说第一条defer语句中的代码最后才执行
//第二条defer语句中的代码倒数第二个执行以此类推
//最后一条语句会第一个执行
//即使没有涉及到错误处理的代码也可以使用defer语句

func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            //处理文件
        }
        //close(file)会在这里被调用,即作用域的最后
    }
}

