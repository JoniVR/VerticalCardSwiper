//
//  CardCell.swift
//  VerticalCardSwiper
//
//  Created by Joni Van Roost on 11/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
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
        
        var transform = CGAffineTransform()
        
        transform = CGAffineTransform(translationX: horizontalTranslation, y: 0)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.transform = transform.concatenating(CGAffineTransform(rotationAngle: angle))
        })
    }
}
