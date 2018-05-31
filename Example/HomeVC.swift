//
//  HomeVC.swift
//  Example
//
//  Created by Joni Van Roost on 6/05/18.
//  Copyright © 2018 Joni Van Roost. All rights reserved.
//

import UIKit
import VerticalCardSwiper

class HomeVC: UIViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
    
    private var cardSwiper: VerticalCardSwiper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSwiper = view as? VerticalCardSwiper
        cardSwiper.delegate = self
        cardSwiper.datasource = self
    }
    
    func cardForItemAt(verticalCardSwiper: VerticalCardSwiper, cardForItemAt index: Int) -> CardCell {
        
        //TODO: clean up
        let cardCell = verticalCardSwiper.collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: IndexPath(row: index, section: 0)) as? CardCell
        
        cardCell!.setRandomBackgroundColor()
        
        return cardCell!
    }
    
    func numberOfCards(verticalCardSwiper: VerticalCardSwiper) -> Int {
        return 100
    }
    
    func didSwipeCardAway(card: CardCell, swipeDirection: CellSwipeDirection) {
        
    }
}
