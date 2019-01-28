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

import Foundation

/// This datasource is used for providing data to the `VerticalCardSwiper`.
public protocol VerticalCardSwiperDatasource: class {

    /**
     Sets the number of cards for the `UICollectionView` inside the VerticalCardSwiperController.
     - parameter verticalCardSwiperView: The `VerticalCardSwiperView` where we set the amount of cards.
     - returns: an `Int` with the amount of cards we want to show.
     */
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int

    /**
     Asks your data source object for the cell that corresponds to the specified item in the `VerticalCardSwiper`.
     Your implementation of this method is responsible for creating, configuring, and returning the appropriate `CardCell` for the given item.
     - parameter verticalCardSwiperView: The `VerticalCardSwiperView` that will display the `CardCell`.
     - parameter index: The that the `CardCell` should be shown at.
     - returns: A CardCell object. The default value is an empty CardCell object.
    */
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell
}
