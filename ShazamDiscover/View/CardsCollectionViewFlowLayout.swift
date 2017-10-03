//
//  CardsCollectionViewFlowLayout.swift
//  ShazamDiscover
//
//  Created by Joni Van Roost on 12/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

class CardsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: this property sets the amount of scaling for the first item.
    var firstItemTransform: CGFloat?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let items = NSArray (array: super.layoutAttributesForElements(in: rect)!, copyItems: true)
        var headerAttributes: UICollectionViewLayoutAttributes?
        
        items.enumerateObjects(using: { (object, idex, stop) -> Void in
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
    
    // MARK: behavior for header
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
    
    // MARK: we invalidate the layout when a "bounds change" happens, for example when we scale the top cell. This forces the cells to be redrawn.
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // MARK: cell paging
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalOffset = proposedContentOffset.y
        
        let targetRect = CGRect(origin: CGPoint(x: 0, y: proposedContentOffset.y), size: self.collectionView!.bounds.size)
        
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            // MARK: we adjust for the contentInset
            let itemOffset = layoutAttributes.frame.origin.y - (collectionView?.contentInset.top)!
            if (abs(itemOffset - verticalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - verticalOffset
            }
        }
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
    }
}

