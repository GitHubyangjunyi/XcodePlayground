import UIKit

import Foundation

class Location : NSObject, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Location(name: self.name, address:self.address);
    }

    var name:String;
    var address:String;

    init(name:String, address:String) {
        self.name = name; self.address = address;
    }
}

class Appointment : NSObject, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Appointment(name:self.name, day:self.day, place:self.place.copy() as! Location);
    }

    var name:String;
    var day:String;
    var place:Location;

    init(name:String, day:String, place:Location) {
        self.name = name; self.day = day; self.place = place;
    }

    func printDetails(label:String) {
        print("\(label) with \(name) on \(day) at \(place.name), "
            + "\(place.address)");
    }

}

var beerMeeting = Appointment(name: "Bob", day: "Mon",
    place: Location(name:"Joe's Bar", address: "123 Main St"));

var workMeeting = beerMeeting.copy() as! Appointment;

workMeeting.name = "Alice";
workMeeting.day = "Fri";
workMeeting.place.name = "Conference Rm 2";
workMeeting.place.address = "Company HQ";

beerMeeting.printDetails(label: "Social");
workMeeting.printDetails(label: "Work");




class Sum : NSObject, NSCopying {
    var resultsCache: [[Int]];
    var firstValue:Int;
    var secondValue:Int;
    
    init(first:Int, second:Int) {
        resultsCache = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 10)
        for i in 0..<10 {
            for j in 0..<10 {
                resultsCache[i][j] = i + j;
            }
        }
        self.firstValue = first;
        self.secondValue = second;
    }
    
    private init(first:Int, second:Int, cache:[[Int]]) {
        self.firstValue = first;
        self.secondValue = second;
        resultsCache = cache;
    }
    
    var Result:Int {
        get {
            return firstValue < resultsCache.count
                && secondValue < resultsCache[firstValue].count
                ? resultsCache[firstValue][secondValue]
                : firstValue + secondValue;
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Sum(first:self.firstValue,
            second: self.secondValue,
            cache: self.resultsCache);
    }
}

var prototype = Sum(first:0, second:9);
var calc1 = prototype.Result;
var clone = prototype.copy() as! Sum;
clone.firstValue = 3; clone.secondValue = 8;
var calc2 = clone.Result;

print("Calc1: \(calc1) Calc2: \(calc2)");




//对象切割问题
class Message : NSObject, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Message(to: self.to, subject: self.subject);
    }
    
    var to:String;
    var subject:String;
    
    init(to:String, subject:String) {
        self.to = to; self.subject = subject;
    }
}

class DetailedMessage : Message {
    var from:String;
    
    init(to: String, subject: String, from:String) {
        self.from = from;
        super.init(to: to, subject: subject);
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return DetailedMessage(to: self.to,
            subject: self.subject, from: self.from);
    }
}

class MessageLogger {
    var messages:[Message] = [];
    
    func logMessage(msg:Message) {
        messages.append(msg.copy() as! Message);
    }
    
    func processMessages(callback:(Message) -> Void) {
        for msg in messages {
            callback(msg);
        }
    }
}

var logger = MessageLogger();

var message = Message(to: "Joe", subject: "Hello");
logger.logMessage(msg: message);

message.to = "Bob";
message.subject = "Free for dinner?";
logger.logMessage(msg: message);

logger.logMessage(msg: DetailedMessage(to: "Alice", subject: "Hi!", from: "Joe"));


logger.processMessages(callback: {msg -> Void in
    if let detailed = msg as? DetailedMessage {
        print("Detailed Message - To: \(detailed.to) From: \(detailed.from)"
            + " Subject: \(detailed.subject)");
    } else {
        print("Message - To: \(msg.to) Subject: \(msg.subject)");
    }
});
