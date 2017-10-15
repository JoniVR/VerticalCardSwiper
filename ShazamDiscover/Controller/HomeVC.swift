//
//  HomeVC.swift
//  ShazamDiscover
//
//  Created by Joni Van Roost on 11/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.animateIn()
    }
}

extension HomeVC {
    
    fileprivate func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        
        let flowLayout =  CardsCollectionViewFlowLayout()
        
        // MARK: sets the amount of cell scaling for the top visible cell.
        flowLayout.firstItemTransform = 0.05
        // MARK: distance between cells.
        flowLayout.minimumLineSpacing = 40
        
        collectionView.collectionViewLayout = flowLayout
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 400
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell
        
        cardCell?.setRandomBackgroundColor()
        return cardCell!
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // MARK: 20 margin on both sides
        let width = UIScreen.main.bounds.width - 40
        
        // MARK: full height - 40 spacing between cells and 80 spacing for the next cell.
        let height = collectionView.frame.height - 120
        
        let cellSize = CGSize(width: width, height: height)
        
        return cellSize
    }
}
