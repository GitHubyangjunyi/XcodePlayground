import UIKit

var jsonString = """
{
    "menu": {
        "id": "file",
        "value": "File",
        "popup": {
            "menuitem": [
                {"value": "New", "onclick": "CreateNewDoc()"},
                {"value": "Open", "onclick": "OpenDoc()"},
                {"value": "Close", "onclick": "CloseDoc()"}
            ]
        }
    }
}
"""


let json = try! JSONSerialization.jsonObject(with: jsonString.data(using: .utf8, allowLossyConversion: true)!, options: [])

if let jsonDic = json as? NSDictionary {
    if let menu = jsonDic["menu"] as? [String: Any] {
        if let popup: Any = menu["popup"] {
            if let popupDic = popup as? [String: Any] {
                if let menuItems: Any = popupDic["menuitem"] {
                    if let menuItemsArr = menuItems as? [Any] {
                        if let item0 = menuItemsArr[0] as? [String: Any] {
                            if let value: Any = item0["value"] {
                                print(value)
                            }
                        }
                    }
                }
            }
        }
    }
}


if let jsonDic = json as? NSDictionary,
   let menu = jsonDic["menu"] as? [String: Any],
   let popup = menu["popup"],
   let popupDic = popup as? [String: Any],
   let menuItems = popupDic["menuitem"],
   let menuItemsArr = menuItems as? [Any],
   let item0 = menuItemsArr[0] as? [String: Any],
   let value = item0["value"] {
    print(value)
}



struct MenuItem: Codable {
    let value: String
    let onClick: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case onClick = "onclick"
    }
}

struct Popup: Codable {
    let menuItem: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case menuItem = "menuitem"
    }
}

struct Menu: Codable {
    let id: String
    let value: String
    let popup: Popup
}

struct Obj: Codable {
    let menu: Menu
}

//只要类型中的所有成员实现了Codable那么这个类型自动满足Codable
//如果JSON中的key和类型中的变量名不一致的话还需要在对应类中声明CodingKeys枚举并用合适的键值覆盖对应的默认值
//上例中Popup和MenuItem都属于这种情况


let jsonData = jsonString.data(using: .utf8, allowLossyConversion: true)!

do {
    let obj = try JSONDecoder().decode(Obj.self, from: jsonData)
    let value = obj.menu.popup.menuItem[0].value
    print(value)
} catch {
    print(error)
}




