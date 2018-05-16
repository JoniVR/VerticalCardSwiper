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
    private var items: [String] = ["Hello mom","This is a test", "A pretty boring test", "I'm not very create atm"]
    
    func numberOfCards(verticalCardSwiper: UICollectionView) -> Int {
        
        return items.count
    }
    
    func cardForItemAt(verticalCardSwiper: UICollectionView, cardForItemAt index: Int) -> CardCell {
        
        let cardCell = verticalCardSwiper.dequeueReusableCell(withReuseIdentifier: "CardCell", for: IndexPath(row: index, section: 0)) as? CardCell
        cardCell!.setRandomBackgroundColor()
        
        
        return cardCell!
    }
    
    func didSwipeCardAway(card: CardCell, swipeDirection: CellSwipeDirection) {
        
        print("SWIPED AWAY!!!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper = view as? VerticalCardSwiper
        cardSwiper.delegate = self
        cardSwiper.datasource = self
    }
}
