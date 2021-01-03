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

/// Custom `UICollectionViewFlowLayout` that provides the flowlayout information like paging and `CardCell` movements.
internal class VerticalCardSwiperFlowLayout: UICollectionViewFlowLayout {

    /// This property sets the amount of scaling for the first item.
    internal var firstItemTransform: CGFloat?
    /// This property enables paging per card. Default is true.
    internal var isPagingEnabled: Bool = true
    /// Stores the height of a CardCell.
    internal var cellHeight: CGFloat?
    /// Allows you to enable/disable the stacking effect. Default is `true`.
    internal var isStackingEnabled: Bool = true
    /// Allows you to set the view to Stack at the Top or at the Bottom. Default is `true`.
    internal var isStackOnBottom: Bool = true
    /// Sets how many cards of the stack are visible in the background. Default is 1.
    internal var stackedCardsCount: Int = 1

    internal override func prepare() {
        super.prepare()

        assert(collectionView?.numberOfSections == 1, "Number of sections should always be 1.")
        assert(collectionView?.isPagingEnabled == false, "Paging on the collectionview itself should never be enabled. To enable cell paging, use the isPagingEnabled property of the VerticalCardSwiperFlowLayout instead.")
    }

    internal override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, let cellHeight = cellHeight else { return nil }

        let y = collectionView.bounds.minY - cellHeight * CGFloat(stackedCardsCount)
        let newRect = CGRect(x: 0, y: y < 0 ? 0 : y, width: collectionView.bounds.maxX, height: collectionView.bounds.maxY)
        let items = NSArray(array: super.layoutAttributesForElements(in: newRect)!, copyItems: true)

        for object in items {
            if let attributes = object as? UICollectionViewLayoutAttributes {
                self.updateCellAttributes(attributes)
            }
        }
        return items as? [UICollectionViewLayoutAttributes]
    }

    internal override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        if self.collectionView?.numberOfItems(inSection: 0) == 0 { return nil }

        if let attr = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            self.updateCellAttributes(attr)
            return attr
        }
        return nil
    }

    internal override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // attributes for swiping card away
        return self.layoutAttributesForItem(at: itemIndexPath)
    }

    internal override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // attributes for adding card
        return self.layoutAttributesForItem(at: itemIndexPath)
    }

    // We invalidate the layout when a "bounds change" happens, for example when we scale the top cell. This forces a layout update on the flowlayout.
    internal override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // Cell paging
    internal override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard
            let collectionView = self.collectionView,
            let cellHeight = cellHeight,
            isPagingEnabled
        else {
            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            return latestOffset
        }

        // Page height used for estimating and calculating paging.
        let pageHeight = cellHeight + self.minimumLineSpacing

        // Make an estimation of the current page position.
        let approximatePage = collectionView.contentOffset.y/pageHeight

        // Determine the current page based on velocity.
        let currentPage = velocity.y == 0.0 ? round(approximatePage) : (velocity.y < 0.0 ? floor(approximatePage) : ceil(approximatePage))

        // Create custom flickVelocity.
        let flickVelocity = velocity.y * 0.3

        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

        // Calculate newVerticalOffset.
        let newVerticalOffset = ((currentPage + flickedPages) * pageHeight) - collectionView.contentInset.top

        return CGPoint(x: proposedContentOffset.x, y: newVerticalOffset)
    }

    /**
     Updates the attributes.
     Here manipulate the zIndex of the cards here, calculate the positions and do the animations.
     
     Below we'll briefly explain how the effect of scrolling a card to the background instead of the top is achieved.
     Keep in mind that (x,y) coords in views start from the top left (x: 0,y: 0) and increase as you go down/to the right,
     so as you go down, the y-value increases, and as you go right, the x value increases.
     
     The two most important variables we use to achieve this effect are cvMinY and cardMinY.
     * cvMinY (A): The top position of the collectionView + inset. On the drawings below it's marked as "A".
     This position never changes (the value of the variable does, but the position is always at the top where "A" is marked).
     * cardMinY (B): The top position of each card. On the drawings below it's marked as "B". As the user scrolls a card,
     this position changes with the card position (as it's the top of the card).
     When the card is moving down, this will go up, when the card is moving up, this will go down.
     
     We then take the max(cvMinY, cardMinY) to get the highest value of those two and set that as the origin.y of the card.
     By doing this, we ensure that the origin.y of a card never goes below cvMinY, thus preventing cards from scrolling upwards.
     
     ```
     +---------+   +---------+
     |         |   |         |
     | +-A=B-+ |   |  +-A-+  | ---> The top line here is the previous card
     | |     | |   | +--B--+ |      that's visible when the user starts scrolling.
     | |     | |   | |     | |
     | |     | |   | |     | |  |  As the card moves down,
     | |     | |   | |     | |  v  cardMinY ("B") goes up.
     | +-----+ |   | |     | |
     |         |   | +-----+ |
     | +--B--+ |   | +--B--+ |
     | |     | |   | |     | |
     +-+-----+-+   +-+-----+-+
     ```
     
     - parameter attributes: The attributes we're updating.
     */
    fileprivate func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes) {

        guard let collectionView = collectionView else { return }

        let cvMinY = collectionView.bounds.minY + collectionView.contentInset.top
        let cardMinY = attributes.frame.minY
        var origin = attributes.frame.origin
        let cardHeight = attributes.frame.height

        let finalY = max(cvMinY, cardMinY)

        let deltaY = (finalY - cardMinY) / cardHeight
        transformAttributes(attributes: attributes, deltaY: deltaY)

        attributes.alpha = 1 - (deltaY - CGFloat(stackedCardsCount))

        // Set the attributes frame position to the values we calculated
        origin.x = collectionView.frame.width/2 - attributes.frame.width/2 - collectionView.contentInset.left
        origin.y = finalY
        attributes.frame = CGRect(origin: origin, size: attributes.frame.size)
        attributes.zIndex = attributes.indexPath.row
    }

    // Creates and applies a CGAffineTransform to the attributes to recreate the effect of the card going to the background.
    fileprivate func transformAttributes(attributes: UICollectionViewLayoutAttributes, deltaY: CGFloat) {

        if let itemTransform = firstItemTransform {
            let top = isStackOnBottom ? deltaY : deltaY * -1
            let scale = 1 - deltaY * itemTransform
            let translationScale = CGFloat((attributes.zIndex + 1) * 10)
            var t = CGAffineTransform.identity

            let calculatedScale = scale > 0 ? scale : 0
            t = t.scaledBy(x: calculatedScale, y: 1)
            if isStackingEnabled {
                t = t.translatedBy(x: 0, y: top * translationScale)
            }
            attributes.transform = t
        }
    }
}
