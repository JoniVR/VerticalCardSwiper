<h1 align="center"> VerticalCardSwiper </h1>

<div align="center">
    A marriage between the Shazam Discover UI and Tinder, built with UICollectionView in Swift.
</div>

<br/>

<div align="center">
    <!-- build status -->
    <a href="https://github.com/JoniVR/VerticalCardSwiper/actions">
        <img src="https://github.com/JoniVR/VerticalCardSwiper/workflows/build/badge.svg" alt="build status">
    </a>
    <!-- pod version -->
    <a href="https://cocoapods.org/pods/VerticalCardSwiper">
        <img src="https://img.shields.io/cocoapods/v/VerticalCardSwiper.svg?style=flat"  alt="cocoapods version">
    </a>
    <!-- carthage compatible -->
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"  alt="Carthage compatible">
    </a>
    <!-- license -->
    <a href="https://github.com/JoniVR/VerticalCardSwiper/blob/master/LICENSE">
        <img alt="GitHub" src="https://img.shields.io/github/license/JoniVR/VerticalCardSwiper.svg">
    </a>
    <!-- platform -->
    <a href="https://cocoapods.org/pods/VerticalCardSwiper">
        <img src="https://img.shields.io/cocoapods/p/VerticalCardSwiper.svg?style=flat?" alt="platform">
    </a>
    <a href="https://swift.org/blog/swift-5-released/">
        <img src="https://img.shields.io/badge/swift-5.0-brightgreen.svg" alt="swift5.0">
    </a>
</div>

<br/>
  
<div align="center">
  <img src="./example.gif" alt="example">
</div>

## Table of Contents
* Project goal
* Key Features
* System Requirements
* Installation
* Example
* Code Documentation / Usage
    * Code Explanation
    * Delegation
    * Customization
* Contribution Guidelines
* Credits
* Contact Info
* License
* Contributers


## Project goal
The goal of this project is to recreate the Discover UI in Shazam incorporating the swipe action on the Tinder application. This project allows a deck of cards to not only be swiped left and right but also up and down to save them for later use.

It's built with a `UICollectionView` and a custom flowLayout.


## Key Features
- [x] Shazam Discover UI with paging
- [x] Tinder-style swiping
- [x] Option to disable side swiping
- [x] Set custom number of stacked cards
- [x] Code documentation in README.md file
- [x] Cocoapods support
- [x] Carthage support
- [x] SPM support
- [ ] Diff support


## System Requirements
* iOS 9.0+
* Swift 5

## Installation
This project needs to be installed with both CocoaPods and Carthage.

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.

Carthage allows frameworks to be added to the Cocoa application.

### CocoaPods
Install [CocoaPods](https://cocoapods.org) if it's not already installed.

Then, add the following line to your Podfile:
```ruby
pod 'VerticalCardSwiper'
```

### Carthage
Install [Carthage](https://github.com/Carthage/Carthage) if it's not already installed.

Then, add the following line to your Podfile:
```ruby
github "JoniVR/VerticalCardSwiper"
```

## Example
To run the project `VericalCardSwiper` enter the following into Ruby

```ruby
pod try VerticalCardSwiper
```

or open the project folder, go to Example folder and double click on `ExampleCardCell.swift`, or `ExampleViewController.swift`.

## Code Documentation / Usage
This section explains the different functions and classes present in the code and their use cases.

`VerticalCardSwiper` behaves a lot like a standard `UICollectionView`. 
To use it inside your `UIViewController`:

```swift
import VerticalCardSwiper

class ExampleViewController: UIViewController, VerticalCardSwiperDatasource {
    
    private var cardSwiper: VerticalCardSwiper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSwiper = VerticalCardSwiper(frame: self.view.bounds)
        view.addSubview(cardSwiper)
        
        cardSwiper.datasource = self
        
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            return cardCell
        }
        return CardCell()
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 100
    }
}
```

#### Code Explanation
```swift
/// Indicates if side swiping on cards is enabled. Set to false if you don't want side swiping. Default is `true`.
@IBInspectable public var isSideSwipingEnabled: Bool = true
/// Allows you to enable/disable the stacking effect. Default is `true` (enabled).
@IBInspectable public var isStackingEnabled: Bool = true
/// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
@IBInspectable public var firstItemTransform: CGFloat = 0.05
/// The inset (spacing) at the top for the cards. Default is 40.
@IBInspectable public var topInset: CGFloat = 40
/// The inset (spacing) at each side of the cards. Default is 20.
@IBInspectable public var sideInset: CGFloat = 20
/// Sets how much of the next card should be visible. Default is 50.
@IBInspectable public var visibleNextCardHeight: CGFloat = 50
/// Vertical spacing between the focussed card and the bottom (next) card. Default is 40.
@IBInspectable public var cardSpacing: CGFloat = 40
/// Allows you to set the view to Stack at the Top or at the Bottom. Default is true.
@IBInspectable public var isStackOnBottom: Bool = true
/// Sets how many cards of the stack are visible in the background
@IBInspectable public var stackedCardsCount: Int = 1
/** 
 Returns an array of indexes (as Int) that are currently visible in the `VerticalCardSwiperView`.
 This includes cards that are stacked (behind the focussed card).
*/
public var indexesForVisibleCards: [Int]
```

##### Just like with a regular `UICollectionView`, you can reload the data by calling
```swift
cardSwiper.reloadData()
```

##### Get the current focussed card index
```swift
cardSwiper.focussedCardIndex
```

##### Scroll to a specifc card by calling
```swift
cardSwiper.scrollToCard(at: Int, animated: Bool) -> Bool
```

##### Get a card at a specified index
```swift
cardSwiper.cardForItem(at: Int) -> CardCell?
```

##### Swipe a card away programatically
```swift
cardSwiper.swipeCardAwayProgrammatically(at: Int, to: SwipeDirection, withDuration: TimeInterval = 0.3) -> Bool
```

##### Moving/Deleting/Inserting cards at runtime
Make sure to update your datasource first, otherwise an error will occur.
```swift
cardSwiper.moveCard(at: Int, to: Int)
cardSwiper.deleteCards(at: [Int])
cardSwiper.insertCards(at: [Int])
```

### Delegation
To handle swipe gestures, implement the `VerticalCardSwiperDelegate`.

```swift
class ViewController: UIViewController, VerticalCardSwiperDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
    
        // called right before the card animates off the screen (optional).
    }

    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {

        // handle swipe gestures (optional).
    }
    
    func didCancelSwipe(card: CardCell, index: Int) {
        
        // Called when a card swipe is cancelled (when the threshold wasn't reached)
    }
    
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
    
        // Allows you to return custom card sizes (optional).
        return CGSize(width: verticalCardSwiperView.frame.width * 0.75, height: verticalCardSwiperView.frame.height * 0.75)
    }
    
    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
    
        // Tells the delegate when the user scrolls through the cards (optional).
    }
    
    func didEndScroll(verticalCardSwiperView: VerticalCardSwiperView) {
    
        // Tells the delegate when scrolling through the cards came to an end (optional).
    }
    
    func didDragCard(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
    
        // Called when the user starts dragging a card to the side (optional).
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
    
        // Tells the delegate when the user taps a card (optional).
    }
    
    func didHoldCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int, state: UIGestureRecognizer.State) {
    
        // Tells the delegate when the user holds a card (optional).
    }
}
```

### Customization
Subclass the `CardCell` to customize the cards.
```swift
class ExampleCardCell: CardCell {

}
```

## Contribution Guidelines
Maintaining this repo is a collaborative effort. One can support the project by writing documentation, helping to fix bugs and submitting code.

Forking the repository
* On GitHub.com, navigate to the respository
* In the top-right corner of the page, click Fork
* Select "Copy the DEFAULT branch only"
* Click Create Fork

Cloning the repository
* Navigate to the forked repository on your github account
* Above the list of files, click <> Code
* Copy the URL of the repository
* Open Git Bash
* In Git Bash, navigate to a folder to save the file.
* Enter git clone enterURL
* Press Enter. The local clone will be created in the folder.

Modify the necessary files and create a Pull Request.

The pull request will be reviewed and approved if acceptable. Otherwise, an explanation will be left in the comments.

## Credits
The UI features in the following two apps inspired the creation of this project.

Shazam: https://www.shazam.com/apps

Tinder: https://tinder.com/

## Contact Info
Author: Joni Van Roost, joni.VR@hotmail.com

## License
VerticalCardSwiper is available under the MIT license. See the LICENSE file for more info.

## Contributers
A big thank you to all the [contributors](https://github.com/JoniVR/VerticalCardSwiper/graphs/contributors)! 
