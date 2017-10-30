//
//  HomeVC.swift
//  VerticalCardSwiper
//
//  Created by Joni Van Roost on 11/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    /** We use this horizontalPangestureRecognizer for the vertical panning. */
    fileprivate var horizontalPangestureRecognizer: UIPanGestureRecognizer!
    /** Stores a `CGRect` with the area that is swipeable to the user. */
    fileprivate var swipeAbleArea: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizer()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.animateIn()
    }
}

extension HomeVC: UIGestureRecognizerDelegate {
    
    /** We set up the `horizontalPangestureRecognizer` and attach it to the `collectionView`. */
    fileprivate func setupGestureRecognizer(){
        
        horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        horizontalPangestureRecognizer.maximumNumberOfTouches = 1
        collectionView.panGestureRecognizer.maximumNumberOfTouches = 1
        collectionView.addGestureRecognizer(horizontalPangestureRecognizer)
        horizontalPangestureRecognizer.delegate = self
    }
    
    /**
     This function is called when a pan is detected inside the `collectionView`.
     We also take care of detecting if the pan gesture is inside the `swipeAbleArea` and we animate the cell if necessary.
     - parameter sender: The `UIPanGestureRecognizer` that detects the pan gesture. In this case `horizontalPangestureRecognizer`.
    */
    @objc fileprivate func handlePan(sender: UIPanGestureRecognizer){
        
        let velocity = sender.velocity(in: collectionView)
        let translation = sender.translation(in: collectionView)
        let location = sender.location(in: self.view)
        let direction = sender.direction
        
        // TODO: remove debug code
        print("LOCATION: \(location.debugDescription)")
        print("TRANSLATION: \(translation.debugDescription)")
        print("VELOCITY: \(velocity.debugDescription)")
        print("DIRECTION: \(direction!)")
        
        if swipeAbleArea.contains(location) {
            
            switch direction! {
                
            case .Left:
                
                // TODO: Animation code
                print("⬅️⬅️⬅️")
                break
                
            case .Right:
                
                // TODO: Animation code
                print("➡️➡️➡️")
                break
                
            default:
                
                // MARK: temp debug code
                if direction == .Up { print("⬆️⬆️⬆️") }
                if direction == .Down { print("⬇️⬇️⬇️") }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGestureRec = gestureRecognizer as? UIPanGestureRecognizer {
            
            // MARK: When a horizontal pan is detected, we make sure to disable the collectionView.panGestureRecognizer so that it doesn't interfere with the sideswipe.
            if panGestureRec == horizontalPangestureRecognizer {
                
                if panGestureRec.direction!.isX {
                    return false
                } else {
                    return true
                }
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
        
        let flowLayout =  VerticalCardSwiperFlowLayout()
        
        flowLayout.firstItemTransform = 0.05
        flowLayout.minimumLineSpacing = 40
        flowLayout.isPagingEnabled = true
        collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 400
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
        
        // MARK: 20 margin on both sides
        let cellWidth = collectionView.bounds.width - 40
        
        // MARK: full height - 40 spacing between cells and 80 spacing for the next cell.
        let cellHeight = collectionView.frame.size.height - 120
        
        if swipeAbleArea == nil {
            
            // MARK: Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: view.frame.width, height: cellHeight)
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
