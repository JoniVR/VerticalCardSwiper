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

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// We use this horizontalPangestureRecognizer for the vertical panning.
    fileprivate var horizontalPangestureRecognizer: UIPanGestureRecognizer!
    /// Stores a `CGRect` with the area that is swipeable to the user.
    internal var swipeAbleArea: CGRect!
    /// Stores the center point of the swipeAbleArea/collectionView.
    internal var centerX: CGFloat!
    /// The amount of cards in the collectionView.
    internal var numberOfCards = 400
    /// Indicates if side swiping on cards is enabled. Default value is `true`.
    public var isSideSwipingEnabled = true
    /// The `CardCell` that the user can (and is) moving.
    internal var swipedCard: CardCell! {
        didSet{
            setupCardSwipeDelegate()
        }
    }
    /// The flowlayout used in the collectionView.
    internal lazy var flowLayout: VerticalCardSwiperFlowLayout = {
        let flowLayout = VerticalCardSwiperFlowLayout()
        flowLayout.firstItemTransform = 0.05
        flowLayout.minimumLineSpacing = 40
        flowLayout.isPagingEnabled = true
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSideSwipingEnabled {
            setupGestureRecognizer()
        }
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.animateIn()
    }
}

extension HomeVC: CardCellSwipeDelegate {
    
    /// Sets up the CardCellSwipeDelegate.
    fileprivate func setupCardSwipeDelegate() {
        
        swipedCard?.delegate = self
    }
    
    func didSwipeAway(cell: CardCell) {
        if let indexPathToRemove = collectionView.indexPath(for: cell){
            numberOfCards -= 1
            swipedCard = nil
            
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPathToRemove])
            }) { [weak self](finished) in
                if finished {
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
    }
}

extension HomeVC: UIGestureRecognizerDelegate {
    
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
        let location = sender.location(in: self.view)
        /// The taplocation relative to the collectionView.
        let locationInCollectionView = sender.location(in: collectionView)
        /// The translation of the finger performing the PanGesture.
        let translation = sender.translation(in: self.view)
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /**
     In this function we setup the collectionView.
     This includes delegate, datasource, insets, adding the horizontalPangestureRecognizer, setting the flowlayout
     */
    fileprivate func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.numberOfCards
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell
        
        cardCell!.setRandomBackgroundColor()
        
        return cardCell!
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 20 margin on both sides
        let cellWidth = collectionView.bounds.width - 40
        
        // full height - 40 spacing between cells and 80 spacing for the next cell.
        let cellHeight = collectionView.frame.size.height - 120
        
        if swipeAbleArea == nil {
            // Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: view.frame.width, height: cellHeight)
            centerX = swipeAbleArea.width/2
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
