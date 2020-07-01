import UIKit
import Foundation

struct ComparessedGene {
    let length: Int
    private let bitVector: CFMutableBitVector
    
    init(original: String) {
        length = original.count
        bitVector = CFBitVectorCreateMutable(kCFAllocatorDefault, length * 2)
        CFBitVectorSetCount(bitVector, length * 2)
        compress(gene: original)
    }
    
    private func compress(gene: String) {
        for (index, nucleotide) in gene.uppercased().enumerated() {
            let nStart = index * 2
            switch nucleotide {
            case "A":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "C":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            case "G":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "T":
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            default:
                print("Unexpected character \(nucleotide) at \(index)")
            }
            
        }
    }

    func decompress() -> String {
        var gnen: String = ""
        for index in 0..<length {
            let nStart = index * 2
            let firstBit = CFBitVectorGetBitAtIndex(bitVector, nStart)
            let secondBit = CFBitVectorGetBitAtIndex(bitVector, nStart + 1)
            switch (firstBit, secondBit) {
            case (0, 0):
                gnen += "A" //00
            case (0, 1):
                gnen += "C" //01
            case (1, 0):
                gnen += "G" //10
            case (1, 1):
                gnen += "T" //11
            default:
                break
            }
        }
        return gnen
    }
}

print(ComparessedGene(original: "ATGAATGCC"))
print(ComparessedGene(original: "ATGAATGCC").decompress())

