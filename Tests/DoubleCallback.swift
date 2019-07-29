import XCTest

class DoubleCallback: XCTestCase {
    
    func testDoubleTheFulfillment() {
        let promiseToCallBack = expectation(description: "calls back")
        let callBackDelay: TimeInterval = 1

        twiceAfter(seconds: callBackDelay) {
            print("i hear you calling me")
            promiseToCallBack.fulfill()
        }

        let afterCallBack = 2 * callBackDelay
        waitForExpectations(timeout: afterCallBack, handler: nil)
    }


    func testSafelyDoubleTheFulfillment() {
        weak var promiseToCallBack = expectation(description: "calls back")
        let callBackDelay: TimeInterval = 1

        twiceAfter(seconds: callBackDelay) {
            guard let promise = promiseToCallBack else {
                print("once was enough, thanks!")
                return
            }

            promise.fulfill()
            promiseToCallBack = nil
        }

        let afterCallBack = 2 * callBackDelay
        waitForExpectations(timeout: afterCallBack, handler: nil)
    }
}



func twiceAfter(seconds: TimeInterval, call closure: @escaping () -> Void) {
    after(seconds: seconds) { () -> Void in
        print("now once")
        closure()

        print("now twice")
        closure()

        print("wasn't that nice?")
    }
}
