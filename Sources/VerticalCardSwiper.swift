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
    
    /// Indicates if side swiping on cards is enabled. Default value is `true`.
    @IBInspectable public var isSideSwipingEnabled: Bool = true
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
    }
    
    /// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
    @IBInspectable public var firstItemTransform: CGFloat = 0.05 {
        willSet {
            flowLayout.firstItemTransform = newValue
        }
    }
    
    public weak var delegate: VerticalCardSwiperDelegate?
    public weak var datasource: VerticalCardSwiperDatasource? {
        didSet{
            numberOfCards = datasource?.numberOfCards(verticalCardSwiperView: self.verticalCardSwiperView) ?? 0
        }
    }
    
    /// The amount of cards in the collectionView.
    fileprivate var numberOfCards: Int = 0
    /// We use this horizontalPangestureRecognizer for the vertical panning.
    fileprivate var horizontalPangestureRecognizer: UIPanGestureRecognizer!
    /// Stores a `CGRect` with the area that is swipeable to the user.
    fileprivate var swipeAbleArea: CGRect!
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
    
    /// The collectionView where all the magic happens.
    public var verticalCardSwiperView: VerticalCardSwiperView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        
        setupCollectionView()
        setupGestureRecognizer()
    }
}

extension VerticalCardSwiper: CardDelegate {
    
    internal func willSwipeAway(cell: CardCell, swipeDirection: CellSwipeDirection) {
        
        if let index = verticalCardSwiperView.indexPath(for: cell)?.row {
            self.delegate?.willSwipeCardAway?(card: cell, index: index, swipeDirection: swipeDirection)
        }
    }
    
    internal func didSwipeAway(cell: CardCell, swipeDirection direction: CellSwipeDirection) {
        
        if let indexPathToRemove = verticalCardSwiperView.indexPath(for: cell){
            
            self.numberOfCards -= 1
            swipedCard = nil
            
            self.verticalCardSwiperView.performBatchUpdates({
                self.verticalCardSwiperView.deleteItems(at: [indexPathToRemove])
            }) { [weak self] (finished) in
                if finished {
                    self?.verticalCardSwiperView.collectionViewLayout.invalidateLayout()
                    self?.delegate?.didSwipeCardAway(card: cell, index: indexPathToRemove.row ,swipeDirection: direction)
                }
            }
        }
    }
    
    fileprivate func setupCardSwipeDelegate() {
        swipedCard?.delegate = self
    }
}

extension VerticalCardSwiper: UIGestureRecognizerDelegate {
    
    /// We set up the `horizontalPangestureRecognizer` and attach it to the `collectionView`.
    fileprivate func setupGestureRecognizer(){
        
        horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        horizontalPangestureRecognizer.maximumNumberOfTouches = 1
        horizontalPangestureRecognizer.delegate = self
        verticalCardSwiperView.addGestureRecognizer(horizontalPangestureRecognizer)
        verticalCardSwiperView.panGestureRecognizer.maximumNumberOfTouches = 1
    }
    
    /**
     This function is called when a pan is detected inside the `collectionView`.
     We also take care of detecting if the pan gesture is inside the `swipeAbleArea` and we animate the cell if necessary.
     - parameter sender: The `UIPanGestureRecognizer` that detects the pan gesture. In this case `horizontalPangestureRecognizer`.
     */
    @objc fileprivate func handlePan(sender: UIPanGestureRecognizer){
        
        guard isSideSwipingEnabled else {
            return
        }
        
        /// The taplocation relative to the superview.
        let location = sender.location(in: self)
        /// The taplocation relative to the collectionView.
        let locationInCollectionView = sender.location(in: verticalCardSwiperView)
        /// The translation of the finger performing the PanGesture.
        let translation = sender.translation(in: self)
        /// The 'PanDirection' the user swipes in.
        let direction = sender.direction
                
        if swipeAbleArea.contains(location) && !verticalCardSwiperView.isScrolling {
            if let swipedCardIndex = verticalCardSwiperView.indexPathForItem(at: locationInCollectionView) {
                /// The card that is swipeable inside the SwipeAbleArea.
                swipedCard = verticalCardSwiperView.cellForItem(at: swipedCardIndex) as? CardCell
            }
        }
        
        if swipedCard != nil && !verticalCardSwiperView.isScrolling {
            
            /// The angle we pass for the swipe animation.
            let maximumRotation: CGFloat = 1.0
            let rotationStrength = min(translation.x / swipedCard.frame.width, maximumRotation)
            let angle = (CGFloat(Double.pi) / 10.0) * rotationStrength
            
            switch (sender.state) {
                
            case .began:
                
                let initialTouchPoint = location
                let newAnchorPoint = CGPoint(x: initialTouchPoint.x / swipedCard.bounds.width, y: initialTouchPoint.y / swipedCard.bounds.height)
                let oldPosition = CGPoint(x: swipedCard.bounds.size.width * swipedCard.layer.anchorPoint.x, y: swipedCard.bounds.size.height * swipedCard.layer.anchorPoint.y)
                let newPosition = CGPoint(x: swipedCard.bounds.size.width * newAnchorPoint.x, y: swipedCard.bounds.size.height * newAnchorPoint.y)
                swipedCard.layer.anchorPoint = newAnchorPoint
                swipedCard.layer.position = CGPoint(x: swipedCard.layer.position.x - oldPosition.x + newPosition.x, y: swipedCard.layer.position.y - oldPosition.y + newPosition.y)
                break
                
            case .changed:
                
                swipedCard.animateCard(angle: angle, horizontalTranslation: translation.x)
                break
                
            case .ended:
                
                swipedCard.endedPanAnimation(withDirection: direction!, angle: angle)
                swipedCard = nil
                break
                
            default:
                
                swipedCard.resetToCenterPosition()
                swipedCard = nil
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGestureRec = gestureRecognizer as? UIPanGestureRecognizer {
            
            // When a horizontal pan is detected, we make sure to disable the collectionView.panGestureRecognizer so that it doesn't interfere with the sideswipe.
            if panGestureRec == horizontalPangestureRecognizer, panGestureRec.direction!.isX {
                return false
            }
        }
        return true
    }
}

extension VerticalCardSwiper: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /**
     Reloads all of the data for the VerticalCardSwiperView.
     
     Call this method sparingly when you need to reload all of the items in the VerticalCardSwiper. This causes the VerticalCardSwiperView to discard any currently visible items (including placeholders) and recreate items based on the current state of the data source object. For efficiency, the VerticalCardSwiperView only displays those cells and supplementary views that are visible. If the data shrinks as a result of the reload, the VerticalCardSwiperView adjusts its scrolling offsets accordingly.
    */
    public func reloadData(){
        verticalCardSwiperView.reloadData()
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
        verticalCardSwiperView.register(cellClass, forCellWithReuseIdentifier: identifier)
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
        verticalCardSwiperView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.numberOfCards
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return (datasource?.cardForItemAt(verticalCardSwiperView: verticalCardSwiperView, cardForItemAt: indexPath.row))!
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll?(verticalCardSwiperView: verticalCardSwiperView)
    }
    
    fileprivate func setupCollectionView(){
        
        verticalCardSwiperView = VerticalCardSwiperView(frame: self.frame, collectionViewLayout: flowLayout)
        verticalCardSwiperView.decelerationRate = UIScrollViewDecelerationRateFast
        verticalCardSwiperView.backgroundColor = UIColor.clear
        setCardSwiperInsets()
        verticalCardSwiperView.showsVerticalScrollIndicator = false
        verticalCardSwiperView.delegate = self
        verticalCardSwiperView.dataSource = self
        
        self.numberOfCards = datasource?.numberOfCards(verticalCardSwiperView: verticalCardSwiperView) ?? 0
        
        self.addSubview(verticalCardSwiperView)
        
        verticalCardSwiperView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalCardSwiperView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalCardSwiperView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            verticalCardSwiperView.topAnchor.constraint(equalTo: self.topAnchor),
            verticalCardSwiperView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    fileprivate func setCardSwiperInsets(){
        
        verticalCardSwiperView.contentInset = UIEdgeInsets(top: topInset, left: sideInset, bottom: topInset + flowLayout.minimumLineSpacing + visibleNextCardHeight, right: sideInset)
    }
}

extension VerticalCardSwiper: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellWidth: CGFloat!
        var cellHeight: CGFloat!
        let xInsets = sideInset * 2
        let yInsets = cardSpacing + visibleNextCardHeight + topInset
        
        // get size from delegate if the sizeForItem function is called.
        if let customSize = delegate?.sizeForItem?(verticalCardSwiperView: verticalCardSwiperView, index: indexPath.row) {
            // set custom sizes and make sure sizes are not negative, if they are, don't subtract the insets.
            cellWidth = customSize.width - (customSize.width - xInsets > 0 ? xInsets : 0)
            cellHeight = customSize.height - (customSize.height - yInsets > 0 ? yInsets : 0)
        } else {
            cellWidth = collectionView.frame.size.width - xInsets
            cellHeight = collectionView.frame.size.height - yInsets
        }
        
        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        flowLayout.cellHeight = cellHeight
        
        if swipeAbleArea == nil {
            // Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: self.frame.width, height: cellHeight)
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
