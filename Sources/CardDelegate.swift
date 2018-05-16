//
//  VerticalCardSwiperDelegate.swift
//  Example
//
//  Created by Joni Van Roost on 7/05/18.
//  Copyright © 2018 Joni Van Roost. All rights reserved.
//

import Foundation

/// This delegate is used for delegating `CardCell` actions.
internal protocol CardDelegate: class {
    
    /**
     Called when a CardCell is swiped away.
     - parameter cell: The CardCell that is being swiped away.
     - parameter swipeDirection: The direction the card is swiped in. This can be Left, Right or None.
     */
    func didSwipeAway(cell: CardCell, swipeDirection: CellSwipeDirection)
}
