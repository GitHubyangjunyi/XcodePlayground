import UIKit



let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Classic"]

let discontinuedIPods: Set = ["iPod mini", "iPod Classic", "iPod nano", "iPod shuffle"]

let currentIPods = iPods.subtracting(discontinuedIPods)


let touchscreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
let iPodsWithTouch = iPods.intersection(touchscreen)


var discontinued: Set = ["iBook", "Powerbook", "Power Mac"]
discontinued.formUnion(discontinuedIPods)
discontinued




























