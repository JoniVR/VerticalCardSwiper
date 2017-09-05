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
    
    fileprivate var cardSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
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
        
        // volledige hoogte - 40 spacing tussen cellen en 80 ruimte voor volgende cell
        let height = collectionView.frame.height - 120
        
        let cellSize = CGSize(width: width, height: height)
        
        // cardSize var instellen op de cellSize
        cardSize = cellSize
        
        return cellSize
    }
}

extension ViewController {
    
    fileprivate func setupCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        // top spacing geven we mee aan de constraints v/d collectionview (anders buggy)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let flowLayout =  CardsCollectionViewFlowLayout()
        
        // transform animatie die ervoor zorgt dat eerste cell scaled
        flowLayout.firstItemTransform = 0.05
        // afstand tussen cellen
        flowLayout.minimumLineSpacing = 40
        
        collectionView.collectionViewLayout = flowLayout
    }
}

