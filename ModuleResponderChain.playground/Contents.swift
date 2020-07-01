import UIKit

//钩子系统的实现
//首先我们从带有调用点的协议开始
//模块管理器将调用此方法以按名称调用正确的钩子函数
//我们将传递参数字典因此我们的钩子可以有参数,我们在此使用Any类型作为值因此您可以在给定键下将任何内容作为参数发送

protocol Module {
    func invoke(name: String, params: [String : Any]) -> Any?
}

extension Module {
    func invoke(name: String, params: [String : Any]) -> Any? { nil }
}


class A: Module {
    func invoke(name: String, params: [String : Any]) -> Any? {
        switch name {
        case "example_form":
            return self.examleFormHock()
        default:
            return nil
        }
    }
    
    private func examleFormHock() -> [String] {
        ["Field 1", "Field 2", "Field 3"]
    }
}

class B: Module {
    func invoke(name: String, params: [String : Any]) -> Any? {
        switch name {
            case "example_form":
                return self.examleFormHock()
            default:
                return nil
            }
    }
    
    private func examleFormHock() -> [String] {
        ["Field 4", "Field 5"]
    }
}


class C: Module {
    func invoke(name: String, params: [String: Any]) -> Any? {
        switch name {
        case "example_form":
            return self.exampleFormHook()
        default:
            return nil
        }
    }

    private func exampleFormHook() -> [String] {
        ["Field 6"]
    }
}



//接下来我们需要一个模块管理器,可以使用模块数组对其进行初始化
//该管理器将负责在每个模块上调用正确的调用方法并将以类型安全的方式处理返回的响应
//我们将立即实现两个invoke方法版本,一个用于合并结果另一个用于返回挂钩的第一个结果



struct ModuleManager {
    let modules: [Module]
    
    func invokeAllHooks<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> [T] {
        let result = self.modules.map { module in
            module.invoke(name: name, params: params)
        }
        return result.compactMap { $0 as? [T] }.flatMap { $0 }
    }
    
    func invokeHook<T>(_ name: String, type: T.Type, params: [String : Any] = [:]) -> T? {
        for module in self.modules {
            let result = module.invoke(name: name, params: params)
            if result != nil {
                return result as? T
            }
        }
        return nil
    }
}
    

let manager1 = ModuleManager(modules: [A(), B(), C()])
let form1 = manager1.invokeAllHooks("example_form", type: String.self)
print(form1) //1, 2, 3, 4, 5, 6

let manager2 = ModuleManager(modules: [A(), C()])
let form2 = manager2.invokeAllHooks("example_form", type: String.self)
print(form2) //1, 2, 3, 6




//您可以使用invokeAllHooks方法将通用类型的数组合并在一起,这是我们可以使用基础钩子方法收集他所有表单字段的方法
//使用该invokeHook方法您可以实现类似的行为例如责任链设计模式,该响应链的作品非常相似similiar,苹果使用反应几乎每一个平台上处理UI事件
//让我通过更新module向您展示它是如何工作的


class BB: Module {
    func invoke(name: String, params: [String: Any]) -> Any? {
        switch name {
        case "example_form":
            return self.exampleFormHook()
        case "example_responder":
            return self.exampleResponderHook()
        default:
            return nil
        }
    }

    private func exampleFormHook() -> [String] {
        ["Field 4", "Field 5"]
    }
    
    private func exampleResponderHook() -> String {
        "Hello, this is module B exampleResponderHook."
    }
}


//如果我们在两个管理器上都example_responder使用该invokeHook方法触发新的钩子我们将看到结果完全不同
let manager3 = ModuleManager(modules: [A(), BB(), C()])
if let value = manager3.invokeHook("example_responder", type: String.self) {
    print(value) //Hello, this is module B.
}


let manager4 = ModuleManager(modules: [A(), C()])
if let value = manager4.invokeHook("example_responder", type: String.self) {
    print(value) //this won't be called at all...
}



//在第一种情况下由于我们在其中一个模块中为此钩子实现了一个实现因此将显示返回值可以进行打印
//在第二种情况下没有模块可以处理事件,因此不会执行条件内的块,就像一个响应链

//结论
//使用模块或插件是将代码的某些部分解耦的有效方法,我真的很喜欢钩子函数因为它们可以为应用程序中的几乎所有内容提供扩展点
//将其与动态模块加载器混合使用,您将在Vapor之上拥有一个完全可扩展的下一代后端解决方案
//您可以独立于模块使用已编译的核心系统以后可以仅升级整个组件的某些部分而无需接触其他部分




