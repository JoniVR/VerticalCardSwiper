<h1 align="center"> VerticalCardSwiper </h1>

<div align="center">
    A marriage between the Shazam Discover UI and Tinder, built with UICollectionView in Swift.
</div>

<br />

<div align="center">
    <!-- build status -->
    <a href="https://travis-ci.org/JoniVR/VerticalCardSwiper">
        <img src="https://travis-ci.org/JoniVR/VerticalCardSwiper.svg?branch=master"  alt="build status">
    </a>
    <!-- version -->
    <a href="https://cocoapods.org/pods/VerticalCardSwiper">
        <img src="https://img.shields.io/cocoapods/v/VerticalCardSwiper.svg?style=flat"  alt="cocoapods version">
    </a>
    <!-- license -->
    <a href="https://cocoapods.org/pods/VerticalCardSwiper">
        <img alt="GitHub" src="https://img.shields.io/github/license/JoniVR/VerticalCardSwiper.svg">   
    </a>
    <!-- platform -->
    <a href="https://cocoapods.org/pods/VerticalCardSwiper">
        <img src="https://img.shields.io/cocoapods/p/VerticalCardSwiper.svg?style=flat?"  alt="platform">
    </a>
</div>

<br />
  
<div align="center">
  <img src="./example.gif" alt="example">
</div>

## Project goal and information
The goal of this project is to recreate the Discover UI in Shazam (which I think is a great, fun way to display content) in combination with a Tinder style of swiping cards to the left/right.
The idea behind this is that in some cases, you don't want to swipe away cards, but keep them available for later on. This implementation allows for that. And it's a fun way to interact with content.

It's built with a `UICollectionView` and a custom flowLayout.

## Requirements
* iOS 9.0
* Swift 4.2

## Installation
VerticalCardSwiper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VerticalCardSwiper'
```

## Example
To try out `VerticalCardSwiper`

```ruby
pod try VerticalCardSwiper
```

or open the project and run the Example.

## Usage
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
        
        let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as! ExampleCardCell
                
        return cardCell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 100
    }
}
```

#### Properties
```swift
/// Indicates if side swiping on cards is enabled. Set to false if you don't want side swiping. Default is `true`.
@IBInspectable public var isSideSwipingEnabled: Bool = true
/// Allows you to make the previous card visible or not visible (stack effect). Default is `true`.
@IBInspectable public var isPreviousCardVisible: Bool = true
/// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
@IBInspectable public var firstItemTransform: CGFloat = 0.05
/// The inset (spacing) at the top for the cards. Default is 40.
@IBInspectable public var topInset: CGFloat = 40
/// The inset (spacing) at each side of the cards. Default is 20.
@IBInspectable public var sideInset: CGFloat = 20
/// Sets how much of the next card should be visible. Default is 50.
@IBInspectable public var visibleNextCardHeight: CGFloat = 50
/// Vertical spacing between CardCells. Default is 40.
@IBInspectable public var cardSpacing: CGFloat = 40
/** 
 Returns an array of indexes (as Int) that are currently visible in the `VerticalCardSwiperView`.
 This does not include cards that are behind the card that is in focus.
*/
public var indexesForVisibleCards: [Int]
```

#### Other
##### Just like with a regular `UICollectionView`, you can reload the data by calling
```swift
cardSwiper.reloadData()
```

##### Get the current focussed card index
```swift
cardSwiper.focussedIndex
```

##### Scroll to a specifc card by calling
```swift
cardSwiper.scrollToCard(at: Int, animated: Bool)
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
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection) {
    
        // called right before the card animates off the screen (optional).
    }

    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection) {

        // handle swipe gestures (optional).
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

## Features
- [x] Shazam Discover UI with paging
- [x] Tinder-style swiping
- [x] Option to disable side swiping
- [x] Code documentation in README.md file
- [x] Cocoapods support
- [ ] Carthage support
- [ ] Diff support

## Author
Joni Van Roost, joni.VR@hotmail.com

## License
VerticalCardSwiper is available under the MIT license. See the LICENSE file for more info.

## More
Feel free to submit a pull request, open an issue or fork this project. Any help is always appreciated.
