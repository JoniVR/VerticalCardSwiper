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

/// The CardCell that the user can swipe away. Based on `UICollectionViewCell`.
open class CardCell: UICollectionViewCell {
    
    weak var delegate: CardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        
        self.layer.cornerRadius = 12
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        // make sure anchorPoint is correct when laying out subviews.
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        super.layoutSubviews()
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
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layer.transform = CATransform3DIdentity
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
        
        let swipePercentageMargin = self.bounds.width * 0.4
        let cardCenter = self.convert(CGPoint(x: self.bounds.midX, y: self.bounds.midY), to: self.superview)
        
        if (cardCenter.x > centerX + swipePercentageMargin || cardCenter.x < centerX - swipePercentageMargin){
            animateOffScreen(angle: angle)
        } else {
            self.resetToCenterPosition()
        }
    }
    
    /**
     Animates to card off the screen and calls the `didSwipeAway` function from the `CardDelegate`.
     - parameter angle: The angle that the card will rotate in (depends on direction). Positive means the card is swiped to the right, a negative angle means the card is swiped to the left.
    */
    fileprivate func animateOffScreen(angle: CGFloat){
        
        var direction: CellSwipeDirection = .None
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, angle, 0, 0, 1)
        
        // swipe left
        if angle < 0 {
            transform = CATransform3DTranslate(transform, -(self.frame.width * 2), 0, 1)
            direction = .Left
        }
        
        // swipe right
        if angle > 0 {
            transform = CATransform3DTranslate(transform, (self.frame.width * 2), 0, 1)
            direction = .Right
        }
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layer.transform = transform
        }){ (completed) in
            self.isHidden = true
            self.delegate?.didSwipeAway(cell: self, swipeDirection: direction)
        }
    }
    
    /**
     Prepares for reuse by resetting the anchorPoint back to the default value.
     This is necessary because in VerticalCardSwiperController we are manipulating the anchorPoint during dragging animation.
    */
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.isHidden = false
        // reset to default value (https://developer.apple.com/documentation/quartzcore/calayer/1410817-anchorpoint)
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
}
