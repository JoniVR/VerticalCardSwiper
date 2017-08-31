//
//  ViewController.swift
//  ShazamDiscover
//
//  Created by Joni Van Roost on 11/07/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupScrollView()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 20 margin aan beide kanten
        let width = UIScreen.main.bounds.width - 40
    
        // 90 = 30 top spacing + 90 bottom spacing
        let height = collectionView.frame.height - 150
        
        let cellSize = CGSize(width: width, height: height)
        
        return cellSize
    }
}

extension ViewController {
    
    fileprivate func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        
        //collectionView.isPagingEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        let flowLayout =  ShazamDiscoverFlowLayout()
        // transform animatie die ervoor zorgt dat eerste cell scaled
        flowLayout.firstItemTransform = 0.05
        // afstand tussen cellen
        flowLayout.minimumLineSpacing = 40
        collectionView.collectionViewLayout = flowLayout
    }
    
    fileprivate func setupScrollView(){
        
        // inset instellen (spacing top en bottom)
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}
