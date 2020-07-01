import UIKit

let minutes = 60
let minuteInterval = 5

//开区间
for _ in stride(from: 0, to: minutes, by: minuteInterval) {
    //每5分钟渲染一个刻度线0, 5, 10, 15 ... 45, 50, 55
}

//闭区间
let hours = 12
let hourInterval = 3
for _ in stride(from: 3, through: hours, by: hourInterval) {
    //每3小时渲染一个刻度线3, 6, 9, 12
}

//for-where
for i in 1...100 where i % 3 == 0 {
    print(i)
}


