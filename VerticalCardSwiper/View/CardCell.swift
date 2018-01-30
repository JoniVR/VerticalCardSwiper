//
//  CardCell.swift
//  VerticalCardSwiper
//
//  Created by Joni Van Roost on 11/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

/**
 This delegate is used for delegating card actions.
*/
protocol CardCellSwipeDelegate: class {
    
    /**
     Called when a CardCell is swiped away.
     - parameter cell: The CardCell that is being swiped away.
    */
    func didSwipeAway(cell: CardCell)
}

class CardCell: UICollectionViewCell {
    
    weak var delegate: CardCellSwipeDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 12
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /**
     We use this function to calculate and set a random backgroundcolor.
     */
    public func setRandomBackgroundColor(){
        
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        self.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    /**
     This function animates the card. The animation consists of a rotation and translation.
     - parameter angle: The angle the card rotates while animating.
     - parameter horizontalTranslation: The horizontal translation the card animates in.
     */
    public func animateCard(angle: CGFloat, horizontalTranslation: CGFloat){
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        transform = CATransform3DTranslate(transform, horizontalTranslation, 0, 1)
        layer.transform = transform
    }
    
    /**
     Resets the CardCell back to the center of the CollectionView.
    */
    public func resetToCenterPosition(){
        
        let anchorPoint = self.layer.anchorPoint
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, 0, 0, 0, 1)
        transform = CATransform3DTranslate(transform, anchorPoint.x, anchorPoint.y, 1)
    
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layer.transform = transform
        })
    }
    
    /**
     Called when the pan gesture is ended.
     Handles what happens when the user stops swiping a card.
     If a certain treshold of the screen is swiped, the `animateOffScreen` function is called,
     if the threshold is not reached, the card will be reset to the center by calling `resetToCenterPosition`.
     - parameter direction: The direction of the pan gesture.
     - parameter centerX: The center X point of the swipeAbleArea/collectionView.
     - parameter angle: The angle of the animation, depends on the direction of the swipe.
    */
    public func endedPanAnimation(withDirection direction: PanDirection, centerX: CGFloat, angle: CGFloat){
        
        let swipePercentageMargin = self.bounds.width * 0.3
        let cardCenter = self.convert(CGPoint(x: self.bounds.midX, y: self.bounds.midY), to: self.superview)
        
        if (cardCenter.x > centerX + swipePercentageMargin || cardCenter.x < centerX - swipePercentageMargin){
            animateOffScreen(withDirection: direction, angle: angle)
        } else {
            self.resetToCenterPosition()
        }
    }
    
    /**
     Animates to card off the screen and calls the `didSwipeAway` function from the `CardCellSwipeDelegate`.
     - parameter direction: The direction that the card was swiped (and will be animated) in.
     - parameter angle: The angle that the card will rotate in (depends on direction).
    */
    fileprivate func animateOffScreen(withDirection direction: PanDirection, angle: CGFloat){
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)

        if direction == .Left {
            transform = CATransform3DTranslate(transform, -(self.frame.width * 2), 0, 1)
        }
        if direction == .Right {
            transform = CATransform3DTranslate(transform, (self.frame.width * 2), 0, 1)
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.layer.transform = transform
        })
        delegate?.didSwipeAway(cell: self) 
    }
    
    /**
     Prepares for reuse by resetting the anchorPoint back to the default value. This is necessary because in HomeVC we are manipulating the anchorPoint during dragging animation.
    */
    override func prepareForReuse() {
        super.prepareForReuse()
        // reset to default value (https://developer.apple.com/documentation/quartzcore/calayer/1410817-anchorpoint)
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
}
