import UIKit


//下标可以定义在类、结构体和枚举中
//是访问集合、列表或序列中元素的快捷方式
//可以使用下标的索引，设置和获取值，而不需要再调用对应的存取方法
//一个类型可以定义多个下标通过不同索引类型进行对应的重载
//下标不限于一维,可以定义具有多个入参的下标满足自定义类型的需求
//下标允许你通过在实例名称后面的方括号中传入一个或者多个索引值来对实例进行查询
//它的语法类似于实例方法语法和计算型属性语法,定义下标使用subscript关键字
//与定义实例方法类似都是指定一个或多个输入参数和一个返回类型
//与实例方法不同的是下标可以设定为读写或只读,这种行为由getter和setter实现,类似计算型属性
//与函数一样下标可以接受不同数量的参数并且为这些参数提供默认值
//如在可变参数和默认参数值中所述,但是与函数不同的是下标不能使用in-out参数
//一个类或结构体可以根据自身需要提供多个下标实现,使用下标时将通过入参的数量和类型进行区分自动匹配合适的下标,它通常被称为下标的重载

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    //判断是否超出索引范围
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}


var matrix = Matrix(rows: 2, columns: 2)

matrix[0, 1] = 1.5
matrix[1, 0] = 3.2


//let someValue = matrix[2, 2]
//断言将会触发因为[2, 2]已经超过了matrix的范围



//实例下标是在特定类型的一个实例上调用的下标,你也可以定义一种在这个类型自身上调用的类型下标
//你可以通过在subscript关键字之前写下static关键字的方式来表示一个类型下标,类类型可以使用class关键字,它允许子类重写父类中对那个下标的实现

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}


let mars = Planet[4]
print(mars)


