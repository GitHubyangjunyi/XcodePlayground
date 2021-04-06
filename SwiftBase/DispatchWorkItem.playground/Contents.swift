import UIKit


func asyncBlock(id: Int) {
    print("async block #\(id) start")
    Thread.sleep(forTimeInterval: 2)
    print("async block #\(id) end")
}


let queue = DispatchQueue(label: "Test dispatch queue", attributes: .concurrent)
let group = DispatchGroup()

// 1
//queue.async(group: group) {
//    asyncBlock(id: 1)
//}
//
//queue.async(group: group) {
//    asyncBlock(id: 2)
//}
//
//group.notify(queue: queue) {
//    asyncBlock(id: 3)
//}


// 2
//group.enter()
//queue.async {
//    asyncBlock(id: 1)
//    group.leave()
//}
//
//group.enter()
//queue.async {
//    asyncBlock(id: 2)
//    group.leave()
//}
//
//queue.async {
//    group.wait()
//    asyncBlock(id: 3)
//}


// 3
//queue.async {
//    asyncBlock(id: 1)
//}
//
//queue.async {
//    asyncBlock(id: 2)
//}
//
//queue.async(flags: .barrier) {
//    asyncBlock(id: 3)
//}



// 4
//queue.async {
//    asyncBlock(id: 1)
//}
//
//queue.async {
//    asyncBlock(id: 2)
//}
//
//let dispatchWorkItem = DispatchWorkItem(qos: .default, flags: .barrier) {
//    asyncBlock(id: 3)
//}
//
//queue.async(execute: dispatchWorkItem)


// 5
//let semaphore = DispatchSemaphore(value: 2)
//
//queue.async {
//    semaphore.wait()
//    asyncBlock(id: 1)
//    semaphore.signal()
//}
//
//queue.async {
//    semaphore.wait()
//    asyncBlock(id: 2)
//    semaphore.signal()
//}
//
//queue.async {
//    semaphore.wait()
//    asyncBlock(id: 3)
//    semaphore.signal()
//}
//

// 6
//let operationQueue = OperationQueue()
//let block1 = BlockOperation {
//    asyncBlock(id: 1)
//}
//
//let block2 = BlockOperation {
//    asyncBlock(id: 2)
//}
//
//let block3 = BlockOperation {
//    asyncBlock(id: 3)
//}
//
//block3.addDependency(block1)
//block3.addDependency(block2)
//
//operationQueue.addOperations([block1, block2, block3], waitUntilFinished: false)


// 7
let operationQueue = OperationQueue()
let block1 = BlockOperation {
    asyncBlock(id: 1)
}

let block2 = BlockOperation {
    asyncBlock(id: 2)
}

let block4 = BlockOperation {
    asyncBlock(id: 4)
}


operationQueue.addOperations([block1, block2], waitUntilFinished: false)
// 屏障之前提交的任务都将执行
operationQueue.addBarrierBlock {
    asyncBlock(id: 3)
}
// 屏障之后提交的任务等待屏障执行之后执行
operationQueue.addOperations([block4], waitUntilFinished: false)








