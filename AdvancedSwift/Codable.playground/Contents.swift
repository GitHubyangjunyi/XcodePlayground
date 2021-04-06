import UIKit
import CoreLocation

//最简单的JSON解码器
//调用解码器的解码方法并指定
//  要解码的值的类型即Loan.self
//  要解码的数据
let json = """
{
    "name": "John Davis",
    "country": "Peru",
    "use": "to buy a new collection of clothes to stock her shop before the holidays.",
    "amount": 150
}
"""

struct Loan: Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int
}

let decoder = JSONDecoder()
if let jsonData = json.data(using: .utf8) {
    do {
        let loan = try decoder.decode(Loan.self, from: jsonData)
        print(loan.name)
        print(loan.country)
        print(loan.use)
        print(loan.amount)
    } catch {
        print(error)
    }
}


//类型的属性名称和JSON数据的键不完全匹配时使用自定义的属性名称
print("类型的属性名称和JSON数据的键不完全匹配时使用自定义的属性名称")
let jsons = """
{
    "name": "John Davis",
    "country": "Peru",
    "use": "to buy a new collection of clothes to stock her shop before the holidays.",
    "loan_amount": 150
}
"""
//只需要更新结构信息
//定义键和属性名称之间的映射需要声明一个名为CodingKeys的枚举
//该枚举的RawValue类型为String并符合CodingKey协议
struct Loans: Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int
 
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case use
        case amount = "loan_amount"
    }
}
 
if let jsonData = jsons.data(using: .utf8) {
    do {
        let loans = try decoder.decode(Loans.self, from: jsonData)
        print(loans.name)
        print(loans.country)
        print(loans.use)
        print(loans.amount)
    } catch {
        print(error)
    }
}


//使用嵌套的JSON对象
print("使用嵌套的JSON对象")
let jsonx  = """
{
    "name": "John Davis",
    "location": {
        "country": "Peru"
    },
    "use": "to buy a new collection of clothes to stock her shop before the holidays.",
    "loan_amount": 150
}
"""

struct Loanx: Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int
 
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
 
    //附加枚举
    enum LocationKeys: String, CodingKey {
        case country
    }
 
    init(from decoder: Decoder) throws {
        let topKeys = try decoder.container(keyedBy: CodingKeys.self)
            name = try topKeys.decode(String.self, forKey: CodingKeys.name)
            use = try topKeys.decode(String.self, forKey: .use)
            amount = try topKeys.decode(Int.self, forKey: .amount)
 
        let location = try topKeys.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
            country = try location.decode(String.self, forKey: .country)
    }
}

if let jsonData = jsonx.data(using: .utf8) {
    do {
        let loanx = try decoder.decode(Loanx.self, from: jsonData)
        print(loanx.name)
        print(loanx.country)
        print(loanx.use)
        print(loanx.amount)
    } catch {
        print(error)
    }
}

//由于它不是直接映射因此我们需要实现Decodable协议的初始化程序来处理所有属性的解码
//在init方法中我们首先使用CodingKeys.self调用解码器的container方法以检索与指定编码键有关的数据
//这些数据是name/location/use/amount
//要解码特定值我们使用特定键例如name和关联的类型例如String.self调用解码方法
//对于country属性解码我们必须使用LocationKeys.self调用nestedContainer方法来检索嵌套的JSON对象
//根据返回的值我们进一步解码country的值


//解码JSON数组
print("解码JSON数组")

let jsona = """
 
[
    {
        "name": "John Davis",
        "location": {
            "country": "Paraguay"
        },
        "use": "to buy a new collection of clothes to stock her shop before the holidays.",
        "loan_amount": 150
    },
    {
        "name": "Las Margaritas Group",
        "location": {
            "country": "Colombia"
        },
        "use": "to purchase coal in large quantities for resale.",
        "loan_amount": 200
    }
]
 
"""

if let jsonData = jsona.data(using: .utf8) {
    do {
        let loans = try decoder.decode([Loanx].self, from: jsonData)
        for item in loans {
            print(item.name)
            print(item.country)
            print(item.use)
            print(item.amount)
        }
    } catch {
        print(error)
    }
}


//忽略某些键值对
print("忽略某些键值对")
let jsond = """
{
    "paging": {
        "page": 1,
        "total": 6083,
        "page_size": 20,
        "pages": 305
    },
    "loans": [
        {
            "name": "John Davis",
            "location": {
                "country": "Paraguay"
            },
            "use": "to buy a new collection of clothes to stock her shop before the holidays.",
            "loan_amount": 150
        },
        {
            "name": "Las Margaritas Group",
            "location": {
                "country": "Colombia"
            },
            "use": "to purchase coal in large quantities for resale.",
            "loan_amount": 200
        }
    ]
}
"""

//声明另一个名为LoanDataStore的结构并采用Codable
//此LoanDataStore仅具有与JSON数据的loans匹配的loans属性
struct LoanDataStore: Codable {
    var loans: [Loanx]
}

if let jsonData = jsond.data(using: .utf8) {
    do {
        let loanDataStore = try decoder.decode(LoanDataStore.self, from: jsonData)
        for loan in loanDataStore.loans {
            print(loan)
        }
    } catch {
        print(error)
    }
}


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



// MARK: - Model classes
/// The Pet superclass.
class Pet: Codable {
    /// The name of the pet.
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

class Cat: Pet {
    /// A cat can have a maximum of 9 lives.
    var lives: Int
    
    enum CatCodingKeys: String, CodingKey {
        case lives
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CatCodingKeys.self)
        lives = try container.decode(Int.self, forKey: .lives)
        try super.init(from: decoder)
    }
}

class Dog: Pet {
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    func fetch() { /**/ }
}

class Person: Codable {
    /// The name of the person.
    let name: String
    /// The heterogeneous list of Pets
    let pets: [Pet]
    
    enum PersonCodingKeys: String, CodingKey {
        case name
        case pets
    }
    
    // CHALLENGE 1: Nested Heterogeneous Array Decoded.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonCodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        pets = try container.decode(family: PetFamily.self, forKey: .pets)
    }
    
    // CHALLENGE 2: Heterogeneous Array as decoded return type.
    func getPets(completion: ([Pet]) -> Void) throws {
        let data = Data() // TODO: Replace this data with pet data.
        completion(try JSONDecoder().decode(family: PetFamily.self, from: data))
    }
}

/// To support a new class family, create an enum that conforms to this protocol and contains the different types.
protocol ClassFamily: Decodable {
    /// The discriminator key.
    static var discriminator: Discriminator { get }
    
    /// Returns the class type of the object coresponding to the value.
    func getType() -> AnyObject.Type
}

/// Discriminator key enum used to retrieve discriminator fields in JSON payloads.
enum Discriminator: String, CodingKey {
    case type = "type"
}

/// The PetFamily enum describes the Pet family of objects.
enum PetFamily: String, ClassFamily {
    case cat = "Cat"
    case dog = "Dog"
    
    static var discriminator: Discriminator = .type
    
    func getType() -> AnyObject.Type {
        switch self {
        case .cat:
            return Cat.self
        case .dog:
            return Dog.self
        }
    }
}

extension JSONDecoder {
    /// Decode a heterogeneous list of objects.
    /// - Parameters:
    ///     - family: The ClassFamily enum type to decode with.
    ///     - data: The data to decode.
    /// - Returns: The list of decoded objects.
    func decode<T: ClassFamily, U: Decodable>(family: T.Type, from data: Data) throws -> [U] {
        return try self.decode([ClassWrapper<T, U>].self, from: data).compactMap { $0.object }
    }
    
    private class ClassWrapper<T: ClassFamily, U: Decodable>: Decodable {
        /// The family enum containing the class information.
        let family: T
        /// The decoded object. Can be any subclass of U.
        let object: U?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Discriminator.self)
            // Decode the family with the discriminator.
            family = try container.decode(T.self, forKey: T.discriminator)
            // Decode the object by initialising the corresponding type.
            if let type = family.getType() as? U.Type {
                object = try type.init(from: decoder)
            } else {
                object = nil
            }
        }
    }
}

extension KeyedDecodingContainer {
    
    /// Decode a heterogeneous list of objects for a given family.
    /// - Parameters:
    ///     - family: The ClassFamily enum for the type family.
    ///     - key: The CodingKey to look up the list in the current container.
    /// - Returns: The resulting list of heterogeneousType elements.
    func decode<T : Decodable, U : ClassFamily>(family: U.Type, forKey key: K) throws -> [T] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        var list = [T]()
        var tmpContainer = container
        while !container.isAtEnd {
            let typeContainer = try container.nestedContainer(keyedBy: Discriminator.self)
            let family: U = try typeContainer.decode(U.self, forKey: U.discriminator)
            if let type = family.getType() as? T.Type {
                list.append(try tmpContainer.decode(type))
            }
        }
        return list
    }
}


// MARK: - EXAMPLES
let petsJson = """
[
    { "type": "Cat", "name": "Garfield", "lives": 9 },
    { "type": "Dog", "name": "Pluto" }
]
"""
let personJson = """
{
    "name": "Kewin",
    "pets": \(petsJson)
}
"""

if let personData = personJson.data(using: .utf8), let petsData = petsJson.data(using: .utf8) {
    let decoder = JSONDecoder()
    
    // Correctly decoded Person with pets.
    let person = try? decoder.decode(Person.self, from: personData)
    print("Correctly decoded Person with pets: \(String(describing: person?.pets))") // Prints [Cat, Dog]
    // Wrongly decoded Pets
    let pets1 = try decoder.decode([Pet].self, from: petsData)
    print("Wrongly decoded pets: \(pets1)") // Prints [Pet, Pet]
    
    // Correctly decoded Pets
    let pets2: [Pet] = try decoder.decode(family: PetFamily.self, from: petsData)
    print("Correctly decoded pets: \(pets2)") // Prints [Cat, Dog]
}


