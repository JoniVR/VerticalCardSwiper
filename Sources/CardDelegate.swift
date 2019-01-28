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

/// This delegate is used for delegating `CardCell` actions.
internal protocol CardDelegate: class {

    /**
     Called right before a CardCell is swiped away.
     - parameter cell: The CardCell that is being swiped away.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    func willSwipeAway(cell: CardCell, swipeDirection: SwipeDirection)

    /**
     Called when a CardCell is swiped away.
     - parameter cell: The CardCell that is being swiped away.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    func didSwipeAway(cell: CardCell, swipeDirection: SwipeDirection)

    /**
     Called while the user is dragging a card to a side.
     
     You can use this to add some custom features to a card when it enters a certain `swipeDirection` (like overlays).
     - parameter card: The CardCell that the user is currently dragging.
     - parameter swipeDirection: The direction in which the card is being dragged.
     */
    func didDragCard(cell: CardCell, swipeDirection: SwipeDirection)
}
