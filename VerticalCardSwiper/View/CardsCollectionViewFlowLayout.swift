//
//  VerticalCardSwiperFlowLayout.swift
//  VerticalCardSwiper
//
//  Created by Joni Van Roost on 12/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

class VerticalCardSwiperFlowLayout: UICollectionViewFlowLayout {
    
    /// This property sets the amount of scaling for the first item.
    public var firstItemTransform: CGFloat?
    /// This property enables paging per card. The default value is true.
    public var isPagingEnabled: Bool = true
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let items = NSArray (array: super.layoutAttributesForElements(in: rect)!, copyItems: true)
        var headerAttributes: UICollectionViewLayoutAttributes?
        
        items.enumerateObjects(using: { (object, index, stop) -> Void in
            let attributes = object as! UICollectionViewLayoutAttributes
            
            if attributes.representedElementKind == UICollectionElementKindSectionHeader {
                headerAttributes = attributes
            }
            else {
                self.updateCellAttributes(attributes, headerAttributes: headerAttributes)
            }
        })
        return items as? [UICollectionViewLayoutAttributes]
    }
    
    func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes, headerAttributes: UICollectionViewLayoutAttributes?) {
        let minY = collectionView!.bounds.minY + collectionView!.contentInset.top
        var maxY = attributes.frame.origin.y
        
        if let headerAttributes = headerAttributes {
            maxY -= headerAttributes.bounds.height
        }
        
        let finalY = max(minY, maxY)
        var origin = attributes.frame.origin
        let deltaY = (finalY - origin.y) / attributes.frame.height
        
        if let itemTransform = firstItemTransform {
            let scale = 1 - deltaY * itemTransform
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            // TODO: add card stack effect (like Shazam)
        }
        origin.y = finalY
        attributes.frame = CGRect(origin: origin, size: attributes.frame.size)
        attributes.zIndex = attributes.indexPath.row
    }
    
    // We invalidate the layout when a "bounds change" happens, for example when we scale the top cell. This forces the cells to be redrawn.
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // Cell paging
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // If the property `isPagingEnabled` is set to false, we don't enable paging and thus return the current contentoffset.
        guard isPagingEnabled else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalOffset = proposedContentOffset.y
        let contentInset = collectionView!.contentInset.top
        
        let targetRect = CGRect(origin: CGPoint(x: 0, y: verticalOffset), size: self.collectionView!.bounds.size)
        
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            // adjust for the contentInset
            let itemOffset = layoutAttributes.frame.origin.y - contentInset
            if (abs(itemOffset - verticalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - verticalOffset
            }
        }
        return CGPoint(x: proposedContentOffset.x, y: verticalOffset + offsetAdjustment)
    }
}

