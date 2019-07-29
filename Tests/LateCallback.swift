import XCTest

class LateCallback: XCTestCase {
    let callBackDelay: TimeInterval = 2


    func xtestNotWaitingLongEnough() {
        let promiseToCallBack = expectation(description: "calls back")
        after(seconds: callBackDelay) { () -> Void in
            print("I knew you'd call!")
            promiseToCallBack.fulfill()
        }

        waitForExpectations(timeout: callBackDelay / 2) { error in
            print("Aww, we timed out: \(String(describing: error))")
        }
    }


    func testPreparedForNotWaitingLongEnough() {
        weak var promiseToCallBack = expectation(description: "calls back")
        after(seconds: callBackDelay) { () -> Void in
            guard let promise = promiseToCallBack else {
                print("too late, buckaroo")
                return
            }

            print("I knew you'd call!")
            promise.fulfill()
        }

        waitForExpectations(timeout: callBackDelay / 2) { error in
            print("Aww, we timed out: \(String(describing: error))")
        }
    }


    func testZzz() {
        print("Let's just wait a while…")
        let tillAfterCallBack = callBackDelay
        spin(forSeconds: tillAfterCallBack)
        print("Yawn, that was boring.")
    }
}



func after(seconds: TimeInterval, call closure: @escaping () -> Void) {
    let delay = DispatchTime.now() + seconds
    let ontoQueue = DispatchQueue.global(qos: .background)
    ontoQueue.asyncAfter(deadline: delay) {
        print("\(seconds): finished waiting")
        closure()
        print("\(seconds): all done here")
    }
}



func spin(forSeconds seconds: TimeInterval) {
    let afterCallBack = Date(timeIntervalSinceNow: seconds)
    RunLoop.main.run(until: afterCallBack)
}
