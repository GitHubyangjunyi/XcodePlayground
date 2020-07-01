import UIKit
import CoreLocation

//只要让你的类型满足Codable协议它就能变为可编解码的类型
//如果类型中所有的存储属性都是可编解码的那么Swift编译器会自动帮你生成实现Encodable和Decodable协议的代码

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}


struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
    
    //由编译器生成的私有枚举类型,为了存储需要必须能将这些键转为字符串或者整数值必须实现CodingKey协议
    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }
    
    //由编译器生成的encode方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate, forKey: .coordinate)
        //编码过程的最终结果是一颗嵌套的容器树,JSON编码器可以根据树中节点的类型将结果转换成对应的目标格式
        //键容器会变成JSON{....},无键容器变成JSON数组[....],单值容器则按照数据类型被转换为数字,布尔值,字符串或者null
    }
    
    //由编译器生成的init方法
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
    
    init(name: String, coordinate: Coordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}

let places = [
    Placemark(name: "Berlin", coordinate: Coordinate(latitude: 52, longitude: 13)),
    Placemark(name: "Cape Town", coordinate: Coordinate(latitude: -34, longitude: 18))
]



let jsonData = try JSONEncoder().encode(places)
let jsonString = String(decoding: jsonData, as: UTF8.self)
print(jsonString)

let decoded = try JSONDecoder().decode([Placemark].self, from: jsonData)
type(of: decoded)



//数组会向编码器请求一个无键容器然后对自身的元素进行迭代并告诉容器对这些元素进行编码
extension Array: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try container.encode(element)
        }
    }
}


//自定义CodingKeys
//自定义key名
struct Placenark2: Codable {
    var name: String
    var coordinate: Coordinate
    
    private enum CodingKeys: String, CodingKey {
        case name = "label"
        case coordinate
    }
    
}

struct Placemark3: Codable {
    var name: String = "Unknown"//使用默认值避免在初始化方法中无法给name属性正确赋值
    var coordinate: Coordinate
    
    private enum CodingKeys: CodingKey {
        case coordinate
    }
}




//自定义encode和init
//编码器和解码器默认可以处理可选值,当目标类型中的一个属性是可选值并且输入数据中对应的值不存在则解码器将跳过这个值
struct Placemark4: Codable {
    var name: String
    var coordinate: Coordinate?
    
    //重写了init解码方法后可以成功解码这个损坏的JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.coordinate = try container.decodeIfPresent(Coordinate.self, forKey: .coordinate)
        } catch DecodingError.keyNotFound {
            self.coordinate = nil
        }
    }
}

let validJSONInput = """
                        [{ "name" : "Berlin" }, { "name" : "Cape Town" }]
                     """

do {
    let inputData = validJSONInput.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([Placemark4].self, from: inputData)
    decoded
} catch {
    print(error.localizedDescription)
// The data couldn’t be read because it is missing.
}


let invalidJSONInput = """
                        [{ "name" : "Berlin", "coordinate": {}}]
                        """

do {
    let inputData = invalidJSONInput.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([Placemark4].self, from: inputData)
    decoded
} catch {
    print(error.localizedDescription)
// The data couldn’t be read because it is missing.
}
//当我们尝试解码这个输入时解码器本来期待"latitude"和"longitude"字段存在于coordinate中但是由于这两个字段实际并不存在所以这会触发.keyNotFound错误
//重写了init解码方法后可以成功解码这个损坏的JSON



//让其他人的代码符合Codable
//CLLocationCoordinate2D并不符合可编码协议
//Swift不能在类型定义的文件之外通过扩展自动合成实现Encodable的代码
//Swift只在两种情况下会自动合成协议实现的代码
//直接添加在类型定义上的协议
//定义在同一个文件的类型扩展上的协议

//使用结构体封装
struct Placemark5 {
    var name: String
    var coordinate: CLLocationCoordinate2D
}

extension Placemark5: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        //分别编码纬度和经度
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        //从纬度和经度重新构建CLLocationCoordinate2D
        self.coordinate = CLLocationCoordinate2D(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude))
    }
}



//使用嵌套容器
//另一种方案是使用嵌套容器来编码经纬度
//KeyedDecodingContainer有一个叫做nestedContainer(keyedBy:forKey:)的方法,它可以在forKey指定的键上新建一个嵌套的键容器
//(译注：想象一下原本这个键对应的应该是在原始容器中保存的编码结果)这个嵌套键容器使用keyedBy参数指定的另一套编码键
//于是我们只要再定义一个实现了CodingKeys的枚举用它作为键,在嵌套的键容器中编码纬度和精度就好了
//这里我们只给出了Encodable的实现,Decodable也遵循同样的模式


struct Placemark6: Encodable {
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }
    //嵌套容器的编码键
    private enum CoordinateCodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        var coordinateContainer = container.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        try coordinateContainer.encode(coordinate.latitude, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longitude, forKey: .longitude)
    }
}












extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
}

extension UIColor {
    struct CodableWrapper: Codable {
        var value: UIColor
        
        init(_ value: UIColor) {
            self.value = value
        }
        
        enum CodingKeys: CodingKey {
            case red
            case green
            case blue
            case alpha
        }
        
        func encode(to encoder: Encoder) throws {
            guard let (red, green, blue, alpha) = value.rgba else {
                let errorContext = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported color format:\(value)")
                throw EncodingError.invalidValue(value, errorContext)
            }
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(alpha, forKey: .alpha)
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let red = try container.decode(CGFloat.self, forKey: .red)
            let green = try container.decode(CGFloat.self, forKey: .green)
            let blue = try container.decode(CGFloat.self, forKey: .blue)
            let alpha = try container.decode(CGFloat.self, forKey: .alpha)
            self.value = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

//使用结构体进行封装的最大缺点在于需要手动在编码前后将类型在UIColor和封装类型之间进行转换
let colors: [UIColor] = [
    .red,
    .white,
    .init(displayP3Red: 0.5, green: 0.4, blue: 1.0, alpha: 0.8),
    .init(hue: 0.6, saturation: 1.0, brightness: 0.8, alpha: 0.9),
]

let codableColors = colors.map(UIColor.CodableWrapper.init)



struct ColoredRect: Codable {
    var rect: CGRect
    //存储颜色
    private var _color: UIColor.CodableWrapper
    
    var color: UIColor {
        get {
            return _color.value
        }
        set {
            _color.value = newValue
        }
    }
    
    init(rect: CGRect, color: UIColor) {
        self.rect = rect
        self._color = UIColor.CodableWrapper(color)
    }
    
    private enum CodingKeys: String, CodingKey {
        case rect
        case _color = "color"
    }
    
}

let rects = [ColoredRect(rect: CGRect(x: 10, y: 20, width: 100, height: 200), color: .yellow)]
do {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(rects)
    let jsonString = String(decoding: jsonData, as: UTF8.self)
    //[{"color":{"red":1,"alpha":1,"blue":0,"green":1},"rect":[[10,20],[100,200]]}]
    print(jsonString)
} catch {
    print(error.localizedDescription)
}





//编译器也可以为实现了RawRepresentable协议的枚举自动合成实现Codable的代码
//只要枚举的RawValue类型是这些原生就支持Codable的类型即可
//Bool,String,Float,Double以及各种形式的整数,而对于其它情况例如带有关联值的枚举你就只能手动添加Codable实现了

enum Either<A, B> {
    case left(A)
    case right(B)
}


extension Either: Codable where A: Codable, B: Codable {
    
    private enum CodingKeys: CodingKey {
        case left
        case right
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .left(let value):
            try container.encode(value, forKey: .left)
        case .right(let value):
            try container.encode(value, forKey: .right)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let leftValue = try container.decodeIfPresent(A.self, forKey: .left) {   //检查是否拥有左键否则无条件解码右键
            self = .left(leftValue)
        } else {
            let rightValue = try container.decode(B.self, forKey: .right)
            self = .right(rightValue)
        }
    }
}


let values: [Either<String, Int>] = [
    .left("Forty-Two"),
    .right(42)
]

do {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let xmlData = try encoder.encode(values)
    let xmlString = String(decoding: xmlData, as: UTF8.self)
    print(xmlString)
    
    
    let decoder = PropertyListDecoder()
    let decoded = try decoder.decode([Either<String, Int>].self, from: xmlData)
    
    print(decoded[1])
}


















































