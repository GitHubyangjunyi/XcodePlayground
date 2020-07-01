import UIKit

var someInts = [Int]()

var threeDoubles = Array(repeating: 0.0, count: 3)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles

var shoppingList: [String] = ["Eggs", "Milk"]

shoppingList.append("Flour")
shoppingList += ["Baking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
shoppingList[4...6] = ["Bananas", "Apples"]
//shoppingList现在有6项
shoppingList
shoppingList.insert("Maple Syrup", at: 0)
shoppingList
let mapleSyrup = shoppingList.remove(at: 0)
shoppingList
let apples = shoppingList.removeLast()
shoppingList

for item in shoppingList {
    print(item)
}

for (index, value) in shoppingList.enumerated() {
    print("Item \(String(index + 1)): \(value)")
}


