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
        continueAfterFailure = false
        XCUIApplication().launch()
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testSwipeRight() {
        
        let collectionView = XCUIApplication().collectionViews
        
        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = collectionView/*@START_MENU_TOKEN@*/.staticTexts["Name: John Doe"]/*[[".cells.staticTexts[\"Name: John Doe\"]",".staticTexts[\"Name: John Doe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(firstCell.exists)
        
        // swipe cell away to right
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: 200, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        
        // Check if first cell with "Name: John Doe" doesn't exist anymore (after swiping away)
        XCTAssertFalse(collectionView.staticTexts["Name: John Doe"].exists)
    }
    
    func testSwipeLeft() {

        let collectionView = XCUIApplication().collectionViews
        
        // First check if the first cell actually exists and matches what we're looking for
        let firstCell: XCUIElement = collectionView/*@START_MENU_TOKEN@*/.staticTexts["Name: John Doe"]/*[[".cells.staticTexts[\"Name: John Doe\"]",".staticTexts[\"Name: John Doe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(firstCell.exists)
        
        // swipe cell away to left
        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let finishPoint = startPoint.withOffset(CGVector(dx: -200, dy: 0))
        startPoint.press(forDuration: 0, thenDragTo: finishPoint)
        
        // Check if first cell with "Name: John Doe" doesn't exist anymore (after swiping away)
        XCTAssertFalse(collectionView.staticTexts["Name: John Doe"].exists)
    }
}
