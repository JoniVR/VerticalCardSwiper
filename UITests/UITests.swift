// MIT License
//
// Copyright (c) 2017 Joni Van Roost
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest

class UITests: XCTestCase {

    var cv: XCUIElementQuery!
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        XCUIDevice.shared.orientation = .portrait
        cv = app.collectionViews
    }

    override func tearDown() {
        super.tearDown()
        cv = nil
        app = nil
    }

    func testSwipeLeftSuccess() {

        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)

        // swipe cell away to left
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: -swipeOffset - 30, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)

        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertFalse(firstCell.exists)
    }

    func testSwipeRightSuccess() {

        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)

        // swipe cell away to right
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: swipeOffset + 30, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)

        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertFalse(firstCell.exists)
    }

    func testSwipeLeftFail() {

        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)

        // swipe cell away to left
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: -swipeOffset, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)

        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertTrue(firstCell.exists)
    }

    func testSwipeRightFail() {

        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)

        // swipe cell away to right
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: swipeOffset, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)

        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertTrue(firstCell.exists)
    }

    func testAddCards() {

        app.navigationBars["Example.ExampleView"].buttons["+5"].tap()

        let firstCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: testUser1").element

        let secondCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: testUser2").element

        XCTAssertTrue(firstCell.exists)
        XCTAssertTrue(secondCell.exists)
    }

    func testRemoveCards() {

        app.navigationBars["Example.ExampleView"].buttons["-5"].tap()

        let firstCell: XCUIElement = cv.cells.containing(.staticText, identifier: "Name: John Doe").element

        XCTAssertFalse(firstCell.exists)
    }

    func testEmptyCards() {

        let button = app.navigationBars["Example.ExampleView"].buttons["-5"]

        // tap "-5" multiple times to remove all cards
        repeatTimes(times: 5) {
            button.tap()
        }

        XCTAssertEqual(cv.cells.count, 0)

        // try swiping on empty VerticalCardSwiper to cause crash
        cv.element.swipeRight()
        cv.element.swipeLeft()
    }

    func testScrollProgramaticallySuccess() {
        let downButton = app.navigationBars["Example.ExampleView"].buttons["down"]
        let upButton = app.navigationBars["Example.ExampleView"].buttons["up"]
        let firstCell = cv.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.isHittable)
        repeatTimes(times: 3) {
            downButton.tap()
        }
        XCTAssertFalse(firstCell.exists)
        repeatTimes(times: 3) {
            upButton.tap()
        }
        XCTAssertTrue(firstCell.isHittable)
    }

    func testSwipeCardProgramaticallySuccess() {
        let firstCell = cv.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)
        let rightButton = app.navigationBars["Example.ExampleView"].buttons["right"]
        rightButton.tap()
        XCTAssertFalse(firstCell.exists)
        let secondCell = cv.cells.containing(.staticText, identifier: "Name: Chuck Norris").element
        XCTAssertTrue(secondCell.exists)
        let leftButton = app.navigationBars["Example.ExampleView"].buttons["left"]
        leftButton.tap()
        XCTAssertFalse(secondCell.exists)
        // test if it works after cancelling a manual swipe
        let thirdCell = cv.cells.containing(.staticText, identifier: "Name: Bill Gates").element
        let swipeOffset = thirdCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = thirdCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: swipeOffset, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        rightButton.tap()
        XCTAssertFalse(thirdCell.exists)
    }
}

extension XCTestCase {
    fileprivate func repeatTimes(times: Int, action: () -> Void) {
        for _ in 0..<times {
            action()
        }
    }
}
