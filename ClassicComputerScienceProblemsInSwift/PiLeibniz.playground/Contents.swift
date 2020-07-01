import UIKit

func calclulatePi(nTerms: UInt) -> Double {
    let numerator: Double = 4
    var denominator: Double = 1
    var operation: Double = -1
    var pi: Double = 0
    for _ in 0 ..< nTerms {
        pi += operation * (numerator / denominator)
        denominator += 2
        operation *= -1
    }
    return abs(pi)
}

print("\(calclulatePi(nTerms: 5))")
print("\(calclulatePi(nTerms: 10))")
print("\(calclulatePi(nTerms: 20))")

print("\(calclulatePi(nTerms: 2000))")

print("\(calclulatePi(nTerms: 20000))")

print("\(calclulatePi(nTerms: 200000))")

