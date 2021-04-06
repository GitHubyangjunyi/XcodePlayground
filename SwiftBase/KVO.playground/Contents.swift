import UIKit
import WebKit

@objcMembers class Food: NSObject {
    dynamic var string: String
    
    override init() {
        string = "hotdog"
        super.init()
    }
}
 
let food = Food()
let observation = food.observe(\.string) { (foo, changed) in
     print("new food string: \(foo.string)")
}
food.string = "not hotdog" // new food string: not hotdog


//用KVO依然需要是NSObject类或子类
//Swift4中swift类不再自动被推测为继承于NSObject所以需要为类添加@objcMembers关键字

//注意到属性string我们使用了dynamic关键字主要是告诉观察者在值发生改变之后触发闭包
//如果没有该关键字那么无法观察到值的改变
//使用新语法特性\.string监听属性变化
//我们不再需要手动去除观察者而以前都需要在deinit()中去除观察者
//当然也可以为属性添加@objc,那么类就不在需要@objcMembers关键字

class Child: NSObject {
    let name: String
    @objc dynamic var age: Int
 
    init(name: String, age: Int) {
        self.name = name
        self.age = age
        super.init()
    }
 
    func celebrateBirthday() {
        age += 1
    }
}

let mia = Child(name: "Mia", age: 5)
let observationa = mia.observe(\.age, options: [.initial, .old]) { (child, change) in
    if let oldValue = change.oldValue {
        print("\(child.name)’s age changed from \(oldValue) to \(child.age)")
    } else {
        print("\(child.name)’s age is now \(child.age)")
      }
}

mia.celebrateBirthday()
 
observation.invalidate()

mia.celebrateBirthday()

//options参数我们设置了两个值.initial,.old表示获取最开始的值和变化前的值
//KVO的options一共有4种

//public struct NSKeyValueObservingOptions : OptionSet {
//
//    public init(rawValue: UInt)
//    public static var new: NSKeyValueObservingOptions { get }//变化前的值
//    public static var old: NSKeyValueObservingOptions { get }//变化后的值
//    public static var initial: NSKeyValueObservingOptions { get }//初始值
//    public static var prior: NSKeyValueObservingOptions { get }//notification变化前后的标准
//}

//监听WebKit加载进度
class ViewController: UIViewController {
    var webView: WKWebView!
    var urlPath: String = "https://www.baidu.com/"
    var progressView: UIProgressView!
    var observer: NSKeyValueObservation!
 
    override func viewDidLoad() {
        super.viewDidLoad()
          setupWebView()
    }
 
    func setupWebView() {
        webView = WKWebView(frame: view.frame)
        view.addSubview(webView)
 
        progressView = UIProgressView(frame: CGRect(x: 0, y: 43, width: view.bounds.width, height: 1.0))
        navigationController?.navigationBar.addSubview(progressView)
 
        observer = webView.observe(\.estimatedProgress, options: .new) { [weak self] (_, changed) in
            if let new = changed.newValue {
                self?.changeProgress(Float(new))
            }
        }
        if let url = URL(string: urlPath) { webView.load(URLRequest(url: url)) }
    }
 
    func changeProgress(_ progress: Float) {
        progressView.isHidden = progress == 1
        progressView.setProgress(progress, animated: true)
    }
}



//遵守OptionSet协议并拥有initial、old、new3个值跟系统本身KVO中的NSKeyValueObservableOptions有点类似
public struct ObservableOptions: OptionSet {
    public static let initial = ObservableOptions(rawValue: 1 << 0)
    public static let old = ObservableOptions(rawValue: 1 << 1)
    public static let new = ObservableOptions(rawValue: 1 << 2)
 
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

//自己封装观察者
//声明一个泛型的观察者类并拥有一个嵌套回调类
public class Observable<Type> {
    //内嵌回调类
    fileprivate class Callback {
        fileprivate weak var observer: AnyObject?               //观察者是弱引用可以为任意对象
        fileprivate let options: [ObservableOptions]            //触发选项
        fileprivate let closure: (Type, ObservableOptions) -> Void//回调闭包closure
 
        init(observer: AnyObject, options: [ObservableOptions], closure: @escaping  (Type, ObservableOptions) -> Void) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }
    }
    
    //在Observable中增加添加观察者去除观察者等方法
    private var callbacks: [Callback] = []
    
    //在Observable中声明泛型的value属性并监听,无论什么时候值发生改变发送通知
    public var value: Type {
        didSet {
            //去除为nil的通知防止当观察者被释放掉之后然后使用所造成的crash
            removeNilObserverCallbacks()
            //回调旧值和新值
            notifyCallbacks(value: oldValue, options: .old)
            notifyCallbacks(value: value, options: .new)
        }
    }
     
    public init(_ value: Type) {
        self.value = value
    }

    //添加观察者
    public func addObserver(_ observer: AnyObject, removeIfExists: Bool = true, options: [ObservableOptions] = [.new], closure: @escaping (Type, ObservableOptions) -> Void) {
        if removeIfExists {
            removeObserver(observer)
        }
        let callback = Callback(observer: observer, options: options, closure: closure)
        callbacks.append(callback)

        if options.contains(.initial) {
            closure(value, .initial)
        }
    }
    
    //去除观察者为nil的回调
    private func removeNilObserverCallbacks() {
        callbacks = callbacks.filter { $0.observer != nil }
    }
    
    //去除观察者
    public func removeObserver(_ observer: AnyObject) {
        callbacks = callbacks.filter { $0.observer !== observer }
    }

    private func notifyCallbacks(value: Type, options: ObservableOptions) {
        let callbacksToNotify = callbacks.filter { $0.options.contains(options) }
        callbacksToNotify.forEach { $0.closure(value, options) }
    }

}


public class User {
    public let name: Observable<String>
    
    public init(name: String) {
        self.name = Observable(name)
    }
}
 
public class Observer {}

let myUser = User(name: "Jack")     //可观察对象
var observer: Observer? = Observer() //观察者可以是NSObject的任意实例或者任意类
//对name进行观察
myUser.name.addObserver(observer!, options: [.initial, .new]) { (name, change) in
    print("user is name is: \(name)")
}
myUser.name.addObserver(observer!, removeIfExists: true, options: [.new]) { (name, change) in
    print("user is name change: \(name)")
}
//设置value来更新其值
myUser.name.value = "hello jack"
//去除观察者那么后面其值再次改变将不受影响,因为内部的实现告诉我们其相关回调已经被去除
observer = nil
//监听无效
myUser.name.value = "poor jack"

print("观察者已经失效")


