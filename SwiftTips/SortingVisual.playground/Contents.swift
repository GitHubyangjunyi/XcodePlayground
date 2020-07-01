import UIKit
import XCPlayground


var arr = [14, 11, 20, 1, 3, 9, 4, 15, 6, 15, 6, 19, 2, 8, 7, 17, 12, 5, 10, 13, 18, 16]

func plot<T>(title: String, array: [T]) {
    for value in array {
        XCPCaptureValue(identifier: title, value: value)
    }
}

plot(title: "x", array: arr)
