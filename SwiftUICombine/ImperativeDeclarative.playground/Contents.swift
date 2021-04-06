import UIKit

struct Student {
    let name: String
    let scores: [科⽬: Int]
}

enum 科⽬: String, CaseIterable {
    case 语⽂, 数学, 英语, 物理
}


let s1 = Student(name: "Jane", scores: [.语⽂: 86, .数学: 92, .英语: 73, .物理: 88])
let s2 = Student(name: "Tomy", scores: [.语⽂: 99, .数学: 52, .英语: 97, .物理: 36])
let s3 = Student(name: "Emma", scores: [.语⽂: 91, .数学: 92, .英语: 100, .物理: 99])

let students = [s1, s2, s3]

//指令式Imperative
var best: (Student, Double)?

for s in students {
    var totalScore = 0
    
    for key in 科⽬.allCases {
        totalScore += s.scores[key] ?? 0
    }
    let averageScore = Double(totalScore) / Double(科⽬.allCases.count)
    
    if let temp = best {
        if averageScore > temp.1 {
            best = (s, averageScore)
        }
    } else {
        best = (s, averageScore)
    }
}


if let best = best {
        print("最⾼平均分: \(best.1), 姓名: \(best.0.name)")
    } else {
        print("students 为空")
}



//声明式Declarative
func average(_ scores: [科⽬: Int]) -> Double {
    Double(scores.values.reduce(0, +)) / Double(科⽬.allCases.count)
}

//先将students映射为(Student, 平均分)的数组
let bestStudent = students.map { ($0, average($0.scores)) }.sorted { $0.1 > $1.1 }.first

if let best = bestStudent {
    print("最⾼平均分: \(best.1), 姓名: \(best.0.name)")
    } else {
    print("students 为空")
}


print("最⾼平均分: \(bestStudent!.1), 姓名: \(String(describing: bestStudent?.0.name))")







