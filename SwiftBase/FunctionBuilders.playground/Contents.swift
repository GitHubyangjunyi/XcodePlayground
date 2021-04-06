import UIKit

//函数构建器是Swift 5.1中首次引入的语言功能
//它为SwiftUI声明式DSL提供了支持使我们能够以一种简洁明了的方式构造异构用户界面层次结构
//函数构建器用于从函数的表达式语句收集部分结果并将它们组合成一个返回值的嵌入DSL
//函数构建器属性具有下划线表示该功能当前正在开发中
@_functionBuilder struct Builder {
    static func buildBlock(_ partialResults: String...) -> String {
        partialResults.reduce("", +)
    }
}

//该方法buildBlock()是强制性的,它必须是静态的并且必须恰好具有此名称,否则将在使用时看到编译错误
//定制函数构建器属性可以应用于
//不是一个协议要求的func/var或subscript声明,它将使函数构建器转换应用于函数的主体
//函数的闭包参数,包括协议要求,它将使函数构建器转换应用于作为相应参数传递的任何显式闭包的主体,除非闭包包含return语句

@Builder func abc() -> String {
    "Method: "
    "ABC"
}

struct Foo {
    @Builder var abc: String {
        "Getter: "
        "ABC"
    }

    subscript(_ anything: String) -> String {
        @Builder get {
            "Subscript: "
            "ABC"
        }
        set { /* nothing */ }
    }
}

print(abc())
print(Foo().abc)
print(Foo()[""])



//传递带有函数构建器注释的闭包作为参数的方法
//然后在acceptBuilder()启用了DSL语法的情况下调用该函数
func acceptBuilder(@Builder build: () -> String) {
    print(build())
}

acceptBuilder {
    "Closure argument: "
    "ABC"
}

//Swift函数构建器解决的问题类别是层次异构数据结构的构造
//生成结构化数据例如XML/JSON。
//生成GUI层次结构例如SwiftUI/HTML






@_functionBuilder
struct AttributedStringBuilder {
    
    //根据NSAttributedString字符串创建最终的结果
    static func buildBlock(_ components: NSAttributedString...) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")
        components.forEach(result.append)
        return result
    }
    
    //下面这些是构建器支持的表达式类型
    
    static func buildExpression(_ text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [:])
    }
    
    static func buildExpression(_ image: UIImage) -> NSAttributedString {
        let attachment = NSTextAttachment.init(image: image)
        return NSAttributedString(attachment: attachment)
    }
    
    static func buildExpression(_ attr: NSAttributedString) -> NSAttributedString {
        attr
    }
    
}

extension NSAttributedString {
    convenience init(@AttributedStringBuilder builder: () -> NSAttributedString) {
        self.init(attributedString: builder())
    }
    
    func withAttributes(_ attrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        copy.addAttributes(attrs, range: NSRange(location: 0, length: string.count))
        return copy
    }
}


//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    label.attributedText = NSAttributedString {
//    NSAttributedString {
//        "Folder "
//        UIImage(systemName: "folder")!
//        }
//
//        "\n"
//
//        NSAttributedString {
//            "Document "
//            UIImage(systemName: "doc")!.withRenderingMode(.alwaysTemplate)
//        }
//        .withAttributes([
//            .font: UIFont.systemFont(ofSize: 32),
//            .foregroundColor: UIColor.red
//        ])
//        }
//    }











