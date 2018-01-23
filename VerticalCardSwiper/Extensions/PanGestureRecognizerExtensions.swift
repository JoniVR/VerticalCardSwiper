//
//  PanGestureRecognizerExtensions.swift
//  VerticalCardSwiper
//
//  Created by Joni Van Roost on 18/10/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

public enum PanDirection: Int {
    case Up
    case Down
    case Left
    case Right
    case None
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return self == .Up || self == .Down }
}

extension UIPanGestureRecognizer {
        
    /**
     This calculated var stores the direction of the gesture received by the `UIPanGestureRecognizer`.
     */
    public var direction: PanDirection? {
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
