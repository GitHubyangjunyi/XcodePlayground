import UIKit

//结构体BlackjackCard用来模拟二十一点中的扑克牌点数
//Ace牌可以表示1或者11
//Ace牌的这一特征通过一个嵌套在Rank枚举中的结构体Values来表示
struct BlackjackCard {

    //嵌套的Rank枚举
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        
        struct Values {
            let first: Int
            let second: Int?
        }
        
        var values: Values {
            switch self {
                case .ace:
                    return Values(first: 1, second: 11)
                case .jack, .queen, .king:
                    return Values(first: 10, second: nil)
                default:
                    return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    //嵌套的Suit枚举
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    //BlackjackCard的属性和方法
    let rank: Rank
    let suit: Suit
    
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
theAceOfSpades.description


//在外部引用嵌套类型时在嵌套类型的类型名前加上其外部类型的类型名作为前缀
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue



