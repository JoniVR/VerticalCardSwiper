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

/**
 The VerticalCardSwiper is a subclass of `UIView` that has a `VerticalCardSwiperView` embedded.
 
 To use this, you need to implement the `VerticalCardSwiperDatasource`.
 
 If you want to handle actions like cards being swiped away, implement the `VerticalCardSwiperDelegate`.
 */
public class VerticalCardSwiper: UIView {

    /// The collectionView where all the magic happens.
    public var verticalCardSwiperView: VerticalCardSwiperView!

    /// Indicates if side swiping on cards is enabled. Default is `true`.
    @IBInspectable public var isSideSwipingEnabled: Bool = true {
        willSet {
            if newValue {
                horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            } else {
                verticalCardSwiperView.removeGestureRecognizer(horizontalPangestureRecognizer)
            }
        }
    }

    /// The inset (spacing) at the top for the cards. Default is 40.
    @IBInspectable public var topInset: CGFloat = 40 {
        didSet {
            setCardSwiperInsets()
        }
    }
    /// The inset (spacing) at each side of the cards. Default is 20.
    @IBInspectable public var sideInset: CGFloat = 20 {
        didSet {
            setCardSwiperInsets()
        }
    }
    /// Sets how much of the next card should be visible. Default is 50.
    @IBInspectable public var visibleNextCardHeight: CGFloat = 50 {
        didSet {
            setCardSwiperInsets()
        }
    }
    /// Vertical spacing between CardCells. Default is 40.
    @IBInspectable public var cardSpacing: CGFloat = 40 {
        willSet {
            flowLayout.minimumLineSpacing = newValue
        }
        didSet {
            setCardSwiperInsets()
        }
    }
    /// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
    @IBInspectable public var firstItemTransform: CGFloat = 0.05 {
        willSet {
            flowLayout.firstItemTransform = newValue
        }
    }
    /// Allows you to make the previous card visible or not visible (stack effect). Default is `true`.
    @IBInspectable public var isPreviousCardVisible: Bool = true {
        willSet {
            flowLayout.isPreviousCardVisible = newValue
        }
    }

    /**
     Returns an array of indexes (as Int) that are currently visible in the `VerticalCardSwiperView`.
     This does not include cards that are behind the card that is in focus.
     - returns: An array of indexes (as Int) that are currently visible.
     */
    public var indexesForVisibleCards: [Int] {

        let lowestIndex = self.verticalCardSwiperView.indexPathsForVisibleItems.min()?.row ?? 0

        // when first card is focussed, return as usual.
        if self.verticalCardSwiperView.visibleCells.count <= 2 && lowestIndex == 0 {
            return self.verticalCardSwiperView.indexPathsForVisibleItems.map({$0.row}).sorted()
        }

        var indexes: [Int] = []
        // Add each visible cell except the lowest one and return
        for cellIndexPath in self.verticalCardSwiperView.indexPathsForVisibleItems where cellIndexPath.row != lowestIndex {
            indexes.append(cellIndexPath.row)
        }
        return indexes.sorted()
    }

    /// The currently focussed card index.
    public var focussedIndex: Int? {
        let center = self.convert(self.verticalCardSwiperView.center, to: self.verticalCardSwiperView)
        if let indexPath = self.verticalCardSwiperView.indexPathForItem(at: center) {
            return indexPath.row
        }
        return nil
    }

    public weak var delegate: VerticalCardSwiperDelegate?
    public weak var datasource: VerticalCardSwiperDatasource?

    /// We use this tapGestureRecognizer for the tap recognizer.
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    /// We use this tapGestureRecognizer for the tap recognizer.
    fileprivate var longPressGestureRecognizer: UILongPressGestureRecognizer!
    /// We use this horizontalPangestureRecognizer for the vertical panning.
    fileprivate var horizontalPangestureRecognizer: UIPanGestureRecognizer!
    /// Stores a `CGRect` with the area that is swipeable to the user.
    fileprivate var swipeAbleArea: CGRect?
    /// The `CardCell` that the user can (and is) moving.
    fileprivate var swipedCard: CardCell! {
        didSet {
            setupCardSwipeDelegate()
        }
    }

    /// The flowlayout used in the collectionView.
    fileprivate lazy var flowLayout: VerticalCardSwiperFlowLayout = {
        let flowLayout = VerticalCardSwiperFlowLayout()
        flowLayout.firstItemTransform = firstItemTransform
        flowLayout.minimumLineSpacing = cardSpacing
        flowLayout.isPagingEnabled = true
        return flowLayout
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /**
     Inserts new cards at the specified indexes.

     Call this method to insert one or more new cards into the cardSwiper.
     You might do this when your data source object receives data for new items or in response to user interactions with the cardSwiper.
     - parameter indexes: An array of integers at which to insert the new card. This parameter must not be nil.
     */
    public func insertCards(at indexes: [Int]) {
        performUpdates {
            self.verticalCardSwiperView.insertItems(at: indexes.map { (index) -> IndexPath in
                return convertIndexToIndexPath(for: index)
            })
        }
    }

    /**
     Deletes cards at the specified indexes.

     Call this method to delete one or more new cards from the cardSwiper.
     You might do this when you remove the items from your data source object or in response to user interactions with the cardSwiper.
     - parameter indexes: An array of integers at which to delete the card. This parameter must not be nil.
     */
    public func deleteCards(at indexes: [Int]) {
        performUpdates {
            self.verticalCardSwiperView.deleteItems(at: indexes.map { (index) -> IndexPath in
                return self.convertIndexToIndexPath(for: index)
            })
        }
    }

    /**
     Moves an item from one location to another in the collection view.

     Use this method to reorganize existing cards. You might do this when you rearrange the items within your data source object or in response to user interactions with the cardSwiper. The cardSwiper updates the layout as needed to account for the move, animating cards into position as needed.

     - parameter atIndex: The index of the card you want to move. This parameter must not be nil.
     - parameter toIndex: The index of the card’s new location. This parameter must not be nil.
     */
    public func moveCard(at atIndex: Int, to toIndex: Int) {
        self.verticalCardSwiperView.moveItem(at: convertIndexToIndexPath(for: atIndex), to: convertIndexToIndexPath(for: toIndex))
    }

    private func commonInit() {
        setupVerticalCardSwiperView()
        setupConstraints()
        setCardSwiperInsets()
        setupGestureRecognizer()
    }

    private func performUpdates(updateClosure: () -> Void) {
        UIView.performWithoutAnimation {
            self.verticalCardSwiperView.performBatchUpdates({
                updateClosure()
            }, completion: { [weak self] _ in
                self?.verticalCardSwiperView.collectionViewLayout.invalidateLayout()
            })
        }
    }
}

extension VerticalCardSwiper: CardDelegate {

    internal func willSwipeAway(cell: CardCell, swipeDirection: SwipeDirection) {
        self.verticalCardSwiperView.isUserInteractionEnabled = false

        if let index = self.verticalCardSwiperView.indexPath(for: cell)?.row {
            self.delegate?.willSwipeCardAway?(card: cell, index: index, swipeDirection: swipeDirection)
        }
    }

    internal func didSwipeAway(cell: CardCell, swipeDirection direction: SwipeDirection) {
        if let indexPathToRemove = self.verticalCardSwiperView.indexPath(for: cell) {
            swipedCard = nil
            self.verticalCardSwiperView.performBatchUpdates({
                self.verticalCardSwiperView.deleteItems(at: [indexPathToRemove])
            }, completion: { [weak self] _ in
                self?.verticalCardSwiperView.collectionViewLayout.invalidateLayout()
                self?.verticalCardSwiperView.isUserInteractionEnabled = true
                self?.delegate?.didSwipeCardAway?(card: cell, index: indexPathToRemove.row, swipeDirection: direction)
            })
        }
    }

    internal func didDragCard(cell: CardCell, swipeDirection: SwipeDirection) {
        if let index = self.verticalCardSwiperView.indexPath(for: cell)?.row {
            self.delegate?.didDragCard?(card: cell, index: index, swipeDirection: swipeDirection)
        }
    }

    fileprivate func setupCardSwipeDelegate() {
        self.swipedCard?.delegate = self
    }
}

extension VerticalCardSwiper: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if let panGestureRec = horizontalPangestureRecognizer {
            // When a horizontal pan is detected, we make sure to disable the collectionView.panGestureRecognizer so that it doesn't interfere with the sideswipe.
            if let direction = panGestureRec.direction, direction.isX {
                return false
            }
        }
        return true
    }

    /// We set up the `horizontalPangestureRecognizer` and attach it to the `collectionView`.
    fileprivate func setupGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        verticalCardSwiperView.addGestureRecognizer(tapGestureRecognizer)

        longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(handleHold))
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0.125
        longPressGestureRecognizer.cancelsTouchesInView = false
        verticalCardSwiperView.addGestureRecognizer(longPressGestureRecognizer)

        horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        horizontalPangestureRecognizer.maximumNumberOfTouches = 1
        horizontalPangestureRecognizer.delegate = self
        verticalCardSwiperView.addGestureRecognizer(horizontalPangestureRecognizer)
        verticalCardSwiperView.panGestureRecognizer.maximumNumberOfTouches = 1
    }

    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        if let delegate = delegate {
            if let wasTapped = delegate.didTapCard {
                /// The taplocation relative to the collectionView.
                let locationInCollectionView = sender.location(in: verticalCardSwiperView)

                if let tappedCardIndex = verticalCardSwiperView.indexPathForItem(at: locationInCollectionView) {
                    wasTapped(verticalCardSwiperView, tappedCardIndex.row)
                }
            }
        }
    }

    @objc fileprivate func handleHold(sender: UILongPressGestureRecognizer) {
        if let delegate = delegate {
            if let wasHeld = delegate.didHoldCard {
                /// The taplocation relative to the collectionView.
                let locationInCollectionView = sender.location(in: verticalCardSwiperView)

                if let swipedCardIndex = verticalCardSwiperView.indexPathForItem(at: locationInCollectionView) {
                    wasHeld(verticalCardSwiperView, swipedCardIndex.row, sender.state)
                }
            }
        }
    }

    /**
     This function is called when a pan is detected inside the `collectionView`.
     We also take care of detecting if the pan gesture is inside the `swipeAbleArea` and we animate the cell if necessary.
     - parameter sender: The `UIPanGestureRecognizer` that detects the pan gesture. In this case `horizontalPangestureRecognizer`.
     */
    @objc fileprivate func handlePan(sender: UIPanGestureRecognizer) {

        guard isSideSwipingEnabled else { return }

        /// The taplocation relative to the superview.
        let location = sender.location(in: self)
        /// The taplocation relative to the collectionView.
        let locationInCollectionView = sender.location(in: verticalCardSwiperView)
        /// The translation of the finger performing the PanGesture.
        let translation = sender.translation(in: self)

        if let swipeArea = swipeAbleArea, swipeArea.contains(location) && !verticalCardSwiperView.isScrolling {
            if let swipedCardIndex = verticalCardSwiperView.indexPathForItem(at: locationInCollectionView) {
                /// The card that is swipeable inside the SwipeAbleArea.
                self.swipedCard = self.verticalCardSwiperView.cellForItem(at: swipedCardIndex) as? CardCell
            }
        }

        if swipedCard != nil && !verticalCardSwiperView.isScrolling {
            /// The angle we pass for the swipe animation.
            let maximumRotation: CGFloat = 1.0
            let rotationStrength = min(translation.x / self.swipedCard.frame.width, maximumRotation)
            let angle = (CGFloat(Double.pi) / 10.0) * rotationStrength

            switch sender.state {
            case .began, .changed:
                swipedCard.animateCard(angle: angle, horizontalTranslation: translation.x)
            case .ended:
                swipedCard.endedPanAnimation(angle: angle)
                swipedCard = nil
            default:
                self.swipedCard.resetToCenterPosition()
                self.swipedCard = nil
            }
        }
    }
}

extension VerticalCardSwiper: UICollectionViewDelegate, UICollectionViewDataSource {

    /**
     Reloads all of the data for the VerticalCardSwiperView.
     
     Call this method sparingly when you need to reload all of the items in the VerticalCardSwiper. This causes the VerticalCardSwiperView to discard any currently visible items (including placeholders) and recreate items based on the current state of the data source object. For efficiency, the VerticalCardSwiperView only displays those cells and supplementary views that are visible. If the data shrinks as a result of the reload, the VerticalCardSwiperView adjusts its scrolling offsets accordingly.
     */
    public func reloadData() {
        verticalCardSwiperView.reloadData()
    }

    /**
     Scrolls the collection view contents until the specified item is visible.
     If you want to scroll to a specific card from the start, make sure to call this function in `viewDidLayoutSubviews`
     instead of functions like `viewDidLoad` as the underlying collectionView needs to be loaded first for this to work.
     - parameter index: The index of the item to scroll into view.
     - parameter animated: Specify true to animate the scrolling behavior or false to adjust the scroll view’s visible content immediately.
     */
    public func scrollToCard(at index: Int, animated: Bool) {

        /**
         scrollToItem & scrollRectToVisible were giving issues with reliable scrolling,
         so we're using setContentOffset for the time being.
         See: https://github.com/JoniVR/VerticalCardSwiper/issues/23
         */
        guard index >= 0 && index < verticalCardSwiperView.numberOfItems(inSection: 0) else { return }

        let y = CGFloat(index) * (flowLayout.cellHeight + flowLayout.minimumLineSpacing) - topInset
        let point = CGPoint(x: verticalCardSwiperView.contentOffset.x, y: y)
        verticalCardSwiperView.setContentOffset(point, animated: animated)
    }

    /**
     Register a class for use in creating new CardCells.
     Prior to calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view,
     you must use this method or the register(_:forCellWithReuseIdentifier:) method
     to tell the collection view how to create a new cell of the given type.
     If a cell of the specified type is not currently in a reuse queue,
     the VerticalCardSwiper uses the provided information to create a new cell object automatically.
     If you previously registered a class or nib file with the same reuse identifier,
     the class you specify in the cellClass parameter replaces the old entry.
     You may specify nil for cellClass if you want to unregister the class from the specified reuse identifier.
     - parameter cellClass: The class of a cell that you want to use in the VerticalCardSwiper
     identifier
     - parameter identifier: The reuse identifier to associate with the specified class. This parameter must not be nil and must not be an empty string.
     */
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.verticalCardSwiperView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    /**
     Register a nib file for use in creating new collection view cells.
     Prior to calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view,
     you must use this method or the register(_:forCellWithReuseIdentifier:) method
     to tell the collection view how to create a new cell of the given type.
     If a cell of the specified type is not currently in a reuse queue,
     the collection view uses the provided information to create a new cell object automatically.
     If you previously registered a class or nib file with the same reuse identifier,
     the object you specify in the nib parameter replaces the old entry.
     You may specify nil for nib if you want to unregister the nib file from the specified reuse identifier.
     - parameter nib: The nib object containing the cell object. The nib file must contain only one top-level object and that object must be of the type UICollectionViewCell.
     identifier
     - parameter identifier: The reuse identifier to associate with the specified nib file. This parameter must not be nil and must not be an empty string.
     */
    public func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.verticalCardSwiperView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfCards(verticalCardSwiperView: verticalCardSwiperView) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return datasource?.cardForItemAt(verticalCardSwiperView: verticalCardSwiperView, cardForItemAt: indexPath.row) ?? CardCell()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScroll?(verticalCardSwiperView: self.verticalCardSwiperView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.didEndScroll?(verticalCardSwiperView: verticalCardSwiperView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.didEndScroll?(verticalCardSwiperView: verticalCardSwiperView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.didEndScroll?(verticalCardSwiperView: verticalCardSwiperView)
    }

    fileprivate func setupVerticalCardSwiperView() {
        verticalCardSwiperView = VerticalCardSwiperView(frame: self.frame, collectionViewLayout: flowLayout)
        verticalCardSwiperView.decelerationRate = UIScrollView.DecelerationRate.fast
        verticalCardSwiperView.backgroundColor = UIColor.clear
        verticalCardSwiperView.showsVerticalScrollIndicator = false
        verticalCardSwiperView.delegate = self
        verticalCardSwiperView.dataSource = self
        self.addSubview(verticalCardSwiperView)
    }

    fileprivate func setupConstraints() {
        verticalCardSwiperView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.verticalCardSwiperView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.verticalCardSwiperView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.verticalCardSwiperView.topAnchor.constraint(equalTo: self.topAnchor),
            self.verticalCardSwiperView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

    fileprivate func setCardSwiperInsets() {
        let bottomInset = visibleNextCardHeight + flowLayout.minimumLineSpacing
        verticalCardSwiperView.contentInset = UIEdgeInsets(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset)
    }
}

extension VerticalCardSwiper: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSize = calculateItemSize(for: indexPath.row)

        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        flowLayout.cellHeight = itemSize.height

        if swipeAbleArea == nil {
            // Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            self.swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: self.frame.width, height: itemSize.height)
        }
        return itemSize
    }

    fileprivate func calculateItemSize(for index: Int) -> CGSize {

        let cellWidth: CGFloat!
        let cellHeight: CGFloat!
        let xInsets = sideInset * 2
        let yInsets = cardSpacing + visibleNextCardHeight + topInset

        // get size from delegate if the sizeForItem function is called.
        if let customSize = delegate?.sizeForItem?(verticalCardSwiperView: verticalCardSwiperView, index: index) {
            // set custom sizes and make sure sizes are not negative, if they are, don't subtract the insets.
            cellWidth = customSize.width - (customSize.width - xInsets > 0 ? xInsets : 0)
            cellHeight = customSize.height - (customSize.height - yInsets > 0 ? yInsets : 0)
        } else {
            cellWidth = verticalCardSwiperView.frame.size.width - xInsets
            cellHeight = verticalCardSwiperView.frame.size.height - yInsets
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
