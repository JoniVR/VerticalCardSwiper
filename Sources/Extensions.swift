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

import UIKit

internal extension UIPanGestureRecognizer {
    
    /**
     This calculated var stores the direction of the gesture received by the `UIPanGestureRecognizer`.
     */
    internal var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let vertical = fabs(velocity.y) > fabs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return PanDirection.None
        }
    }
}

internal extension UICollectionView {
    
    /// A `Bool` that indicates if the `UICollectionView` is currently scrolling.
    internal var isScrolling: Bool {
        return (self.isDragging || self.isTracking || self.isDecelerating)
    }
    
    /**
     This function animates the cards from the bottom on first load.
     You should use this function inside `viewDidAppear`.
    */
    internal func animateIn() {
        var counter: Double = 1
        for cell in visibleCells {
            
            cell.transform = CGAffineTransform(translationX: 0, y: bounds.height + cell.bounds.height)
            
            UIView.animate(withDuration: 0.6, delay: 0.3 * counter, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                counter -= 1
            }, completion: nil)
        }
    }
}
