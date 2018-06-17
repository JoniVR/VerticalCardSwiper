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

class VerticalCardSwiperUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        XCUIApplication().launch()
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSwipeLeftSuccess() {
        
        let collectionView = XCUIApplication().collectionViews
        
        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = collectionView.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)
        
        // swipe cell away to left
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: -swipeOffset - 10, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        
        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertFalse(firstCell.exists)
    }
    
    func testSwipeRightSuccess() {
        
        let collectionView = XCUIApplication().collectionViews
        
        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = collectionView.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)
        
        // swipe cell away to right
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: swipeOffset + 10, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        
        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertFalse(firstCell.exists)
    }
    
    func testSwipeLeftFail() {
        
        let collectionView = XCUIApplication().collectionViews
        
        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = collectionView.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)
        
        // swipe cell away to left
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: -swipeOffset + 10, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        
        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertTrue(firstCell.exists)
    }
    
    func testSwipeRightFail() {
        
        let collectionView = XCUIApplication().collectionViews
        
        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = collectionView.cells.containing(.staticText, identifier: "Name: John Doe").element
        XCTAssertTrue(firstCell.exists)
        
        // swipe cell away to right
        let swipeOffset = firstCell.frame.width * 0.4 // 0.4 is the offset at which a card is swiped away
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: swipeOffset - 10, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        
        // Check if first cell doesn't exist anymore (after swiping away)
        XCTAssertTrue(firstCell.exists)
    }
}
