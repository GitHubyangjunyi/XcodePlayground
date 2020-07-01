import Foundation

class Person : NSObject, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Person(name: self.name, country: self.country);
    }
    
    var name:String
    var country: String
    
    init(name:String, country:String) {
        self.name = name; self.country = country;
    }
}

var data = NSMutableArray(objects: 10, "iOS", Person(name:"Joe", country:"USA"));
//var copiedData = data//使用直接赋值则两个数组对象一样
//不管是否copyItems,两个数组对象都是独立的
var copiedData = NSMutableArray(array: data as! [Any], copyItems: true);
//var copiedData = NSMutableArray(array: data as! [Any], copyItems: false);
//var copiedData = data.mutableCopy() as! NSArray



data[0] = 20;
data[1] = "MacOS";
(data[2] as! Person).name = "Alice"

print("Identity: \(data === copiedData)");
print("0: \(copiedData[0]) 1: \(copiedData[1]) 2: \((copiedData[2] as! Person).name)");


//关于@NSCopying属性修饰符
class LogItem {
    var from:String?;
    @NSCopying var data:NSArray?
}

var dataArray = NSMutableArray(array: [1, 2, 3, 4]);

var logitem = LogItem()
logitem.from = "Alice";
logitem.data = dataArray;

dataArray[1] = 10;
print("Value: \(logitem.data![1])");
