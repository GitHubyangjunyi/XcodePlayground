import UIKit

//类型转换可以判断实例的类型也可以将实例看做是其父类或者子类的实例
//你可以将类型转换用在类和子类的层次结构上
//检查特定类实例的类型并且转换这个类实例的类型成为这个层次结构中的其他类型
//转换没有真的改变实例或它的值,根本的实例保持不变而只是简单地把它作为它被转换成的类型来使用

class MediaItem {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}


class Movie: MediaItem {
    var director: String
    
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
//数组library的类型被推断为[MediaItem]
//在幕后library里存储的媒体项依然是Movie和Song类型的
//但是若你迭代它依次取出的实例会是MediaItem类型的而不是Movie和Song类型
//为了让它们作为原本的类型工作需要检查它们的类型或者向下转换它们到其它类型

//is
//用类型检查操作符is来检查一个实例是否属于特定子类型
//若实例属于那个子类型类型检查操作符返回true否则返回false

var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}

print("Media library contains \(movieCount) movies and \(songCount) songs")



//as? as!
//某类型的一个常量或变量可能在幕后实际上属于一个子类
//当确定是这种情况时可以尝试用类型转换操作符as?或as!向下转到它的子类型
//因为向下转型可能会失败所以类型转型操作符带有两种不同形式
//条件形式as?返回一个你试图向下转成的类型的可选值
//强制形式as!把试图向下转型和强制解包转换结果结合为一个操作
//当你不确定向下转型可以成功时用类型转换的条件形式as?返回一个可选值并且若下转是不可能的可选值将是nil,这使你能够检查向下转型是否成功
//只有你可以确定向下转型一定会成功时才使用强制形式as!
//当你试图向下转型为一个不正确的类型时强制形式的类型转换会触发一个运行时错误

for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}




//Any和AnyObject
//Swift为不确定类型提供了两种特殊的类型别名
//Any可以表示任何类型包括函数类型
//AnyObject可以表示任何类类型的实例

var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })


for thing in things {
    switch thing {
        case 0 as Int:
            print("zero as an Int")
        case 0 as Double:
            print("zero as a Double")
        case let someDouble as Double where someDouble > 0:
            print("a positive double value of \(someDouble)")
        case is Double:
            print("some other double value that I don't want to print")
        case let someInt as Int:
            print("an integer value of \(someInt)")
        case let someString as String:
            print("a string value of \"\(someString)\"")
        case let (x, y) as (Double, Double):
            print("an (x, y) point at \(x), \(y)")
        case let movie as Movie:
            print("a movie called \(movie.name), dir. \(movie.director)")
        case let stringConverter as (String) -> String:
            print(stringConverter("Michael"))
        default:
            print("something else")
    }
}



//Any类型可以表示所有类型的值包括可选类型
//Swift会在你用Any类型来表示一个可选值的时候给你一个警告
//如果你确实想使用Any类型来承载可选值你可以使用as操作符显式转换为Any
let optionalNumber: Int? = 3
things.append(optionalNumber)        //警告
things.append(optionalNumber!)          //强制解包消除警告
things.append(optionalNumber ?? 100)    //默认值消除警告
things.append(optionalNumber as Any)    //指定Any消除警告
