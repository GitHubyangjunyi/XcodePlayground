import UIKit

var letters = Set<Character>()

letters.insert("a")
letters = []

var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]

var favoriteGenres1: Set = ["Rock", "Classical", "Hip hop"]

if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}
//打印“It's too funky in here.”

for genre in favoriteGenres.sorted() {
    print("\(genre)")
}
//Classical
//Hip hop
//Jazz

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

//合并
oddDigits.union(evenDigits).sorted()
//[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
//交集
oddDigits.intersection(evenDigits).sorted()
//[]
//减去
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
//[1, 9]
//不相交的值
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
//[1, 2, 9]


let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

//是不是子集
houseAnimals.isSubset(of: farmAnimals)
//true
//是不是父集
farmAnimals.isSuperset(of: houseAnimals)
//true
//是否没有交集
farmAnimals.isDisjoint(with: cityAnimals)
//true
