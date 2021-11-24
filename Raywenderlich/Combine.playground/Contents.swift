import UIKit
import Combine


public func example(of description: String, action: () -> Void) {
  print("\n——— Example of:", description, "———")
  action()
}

example(of: "Publisher") {
    let center = NotificationCenter.default
    let myNotification = Notification.Name.init("MyNotification")
    //let publisher = NotificationCenter.default.publisher(for: myNotification, object: nil)
    
    let observer = center.addObserver(forName: myNotification, object: nil, queue: nil) { notification in
        print("收到通知")
    }
    
    center.post(name: myNotification, object: nil)
    center.removeObserver(observer)
}

example(of: "Subscriber") {
    let center = NotificationCenter.default
    let myNotification = Notification.Name.init("MyNotification")
    // 创建发布特定通知的发布者
    let publisher = NotificationCenter.default.publisher(for: myNotification, object: nil)
    // 创建订阅特定通知的订阅者
    let subscription = publisher.sink { _ in
        print("从发布者接收到通知")
    }
    // 发布者发布通知
    center.post(name: myNotification, object: nil)
    // 取消订阅
    subscription.cancel()
}


example(of: "Just") {
    let just = Just.init("一次性发布事件")
    just.sink {
        print("一次性发布事件接收完成", $0)
    } receiveValue: {
        print("接收到", $0)
    }

    just.sink {
        print("另一个一次性事件接受完成", $0)
    } receiveValue: {
        print("接收到", $0)
    }
}

example(of: "assign(to:on:)") {
    class SomeObject {
        @objc var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    let object = SomeObject()
    
    let publisher = ["a", "b"].publisher
    
    publisher.assign(to: \.value, on: object)
}


example(of: "assign(to)") {
    class SomeObject {
        @Published var value = 0
    }
    let object = SomeObject()
    
    object.$value.sink {
        print($0)
    }
    // 创建发布者并将每个值分配给object的底层发布者
    (0..<10).publisher.assign(to: &object.$value)
}
