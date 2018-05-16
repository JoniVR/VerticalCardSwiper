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

public class VerticalCardSwiper: UIView {
    
    /// Indicates if side swiping on cards is enabled. Default value is `true`.
    @IBInspectable public var isSideSwipingEnabled: Bool = true
    /// The amount of cards in the collectionView.
    @IBInspectable public var numberOfCards: Int = 0
    /// The inset (spacing) at the top for the cards.
    @IBInspectable public var topInset: CGFloat = 40
    /// The inset (spacing) at each side of the cards.
    @IBInspectable public var sideInset: CGFloat = 20
    /// Sets how much of the next card should be visible.
    @IBInspectable public var visibleNextCardHeight: CGFloat = 50
    
    public weak var delegate: VerticalCardSwiperDelegate? {
        didSet {
            
        }
    }
    public weak var datasource: VerticalCardSwiperDatasource?
    
    /// We use this horizontalPangestureRecognizer for the vertical panning.
    fileprivate var horizontalPangestureRecognizer: UIPanGestureRecognizer!
    /// Stores a `CGRect` with the area that is swipeable to the user.
    fileprivate var swipeAbleArea: CGRect!
    /// Stores the center point of the swipeAbleArea/collectionView.
    fileprivate var centerX: CGFloat!
    /// The `CardCell` that the user can (and is) moving.
    fileprivate var swipedCard: CardCell! {
        didSet {
            setupCardSwipeDelegate()
        }
    }
    
    /// The flowlayout used in the collectionView.
    fileprivate lazy var flowLayout: VerticalCardSwiperFlowLayout = {
        let flowLayout = VerticalCardSwiperFlowLayout()
        flowLayout.firstItemTransform = 0.05
        flowLayout.minimumLineSpacing = 40
        flowLayout.isPagingEnabled = true
        return flowLayout
    }()
    
    /// The collectionView where all the magic happens.
    fileprivate var collectionView: UICollectionView!
    
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
        
        //assert(delegate != nil, "Please implement and assign the VerticalCardSwiperDelegate")
        //assert(datasource != nil, "Please implement and assign the VerticalCardSwiperDatasource")
        
        if isSideSwipingEnabled {
            setupGestureRecognizer()
        }
    }
}

extension VerticalCardSwiper: CardDelegate {
    
    /// Sets up the VerticalCardSwiperDelegate.
    fileprivate func setupCardSwipeDelegate() {
        
        swipedCard?.delegate = self
    }
    
    public func didSwipeAway(cell: CardCell, swipeDirection direction: CellSwipeDirection) {
        
        if let indexPathToRemove = collectionView.indexPath(for: cell){
            
            self.numberOfCards -= 1
            swipedCard = nil
            
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPathToRemove])
            }) { [weak self] (finished) in
                if finished {
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                    self?.delegate?.didSwipeCardAway(card: cell, swipeDirection: direction)
                }
            }
        }
    }
}

extension VerticalCardSwiper: UIGestureRecognizerDelegate {
    
    /// We set up the `horizontalPangestureRecognizer` and attach it to the `collectionView`.
    fileprivate func setupGestureRecognizer(){
        
        horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        horizontalPangestureRecognizer.maximumNumberOfTouches = 1
        horizontalPangestureRecognizer.delegate = self
        collectionView.addGestureRecognizer(horizontalPangestureRecognizer)
        collectionView.panGestureRecognizer.maximumNumberOfTouches = 1
    }
    
    /**
     This function is called when a pan is detected inside the `collectionView`.
     We also take care of detecting if the pan gesture is inside the `swipeAbleArea` and we animate the cell if necessary.
     - parameter sender: The `UIPanGestureRecognizer` that detects the pan gesture. In this case `horizontalPangestureRecognizer`.
     */
    @objc fileprivate func handlePan(sender: UIPanGestureRecognizer){
        
        /// The taplocation relative to the superview.
        let location = sender.location(in: self)
        /// The taplocation relative to the collectionView.
        let locationInCollectionView = sender.location(in: collectionView)
        /// The translation of the finger performing the PanGesture.
        let translation = sender.translation(in: self)
        /// The 'PanDirection' the user swipes in.
        let direction = sender.direction
        
        if swipeAbleArea.contains(location) && !collectionView.isScrolling {
            if let swipedCardIndex = collectionView.indexPathForItem(at: locationInCollectionView) {
                /// The card that is swipeable inside the SwipeAbleArea.
                swipedCard = collectionView.cellForItem(at: swipedCardIndex) as! CardCell
            }
        }
        
        if swipedCard != nil && !collectionView.isScrolling {
            
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
                
                swipedCard.endedPanAnimation(withDirection: direction!, centerX: centerX, angle: angle)
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
            } else {
                return true
            }
        }
        return false
    }
}

extension VerticalCardSwiper: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /**
     In this function we setup the collectionView.
     This includes delegate, datasource, insets, adding the horizontalPangestureRecognizer, setting the flowlayout
     */
    fileprivate func setupCollectionView(){
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: topInset + flowLayout.minimumLineSpacing + visibleNextCardHeight, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datasource!.numberOfCards(verticalCardSwiper: collectionView)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //TODO: clean up
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell
        cardCell!.setRandomBackgroundColor()
        
        if (datasource == nil) { return cardCell! }
        
        return datasource!.cardForItemAt(verticalCardSwiper: collectionView, cardForItemAt: indexPath.row)
    }
}

extension VerticalCardSwiper: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.size.width - (sideInset * 2)
        let cellHeight = collectionView.frame.size.height - flowLayout.minimumLineSpacing - visibleNextCardHeight - topInset
        
        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        flowLayout.cellHeight = cellHeight
        
        if swipeAbleArea == nil {
            // Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: self.frame.width, height: cellHeight)
            centerX = swipeAbleArea.width/2
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

