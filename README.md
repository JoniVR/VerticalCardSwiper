# VerticalCardSwiper
_A marriage between the Shazam Discover UI and Tinder, built with UICollectionView in Swift._

  ![example](https://github.com/JoniVR/VerticalCardSwiper/blob/development/example.gif)

[![Build Status](https://travis-ci.org/JoniVR/VerticalCardSwiper.svg?branch=master)](https://travis-ci.org/JoniVR/VerticalCardSwiper)
[![Version](https://img.shields.io/cocoapods/v/VerticalCardSwiper.svg?style=flat)](https://cocoapods.org/pods/VerticalCardSwiper)
[![License](https://img.shields.io/cocoapods/l/VerticalCardSwiper.svg?style=flat)](https://cocoapods.org/pods/VerticalCardSwiper)
[![Platform](https://img.shields.io/cocoapods/p/VerticalCardSwiper.svg?style=flat)](https://cocoapods.org/pods/VerticalCardSwiper)

## Project goal and information
The goal of this project is to recreate the Discover UI in Shazam (which I think is a great, fun way to display content) in combination with a Tinder style of swiping cards to the left/right.
The idea behind this is that in some cases, you don't want to swipe away cards, but keep them available for later on. This implementation allows for that. And it's a fun way to interact with content.

It's built with a `UICollectionView` and a custom flowLayout.

## Requirements
* iOS 9.0
* Swift 4

## Installation
VerticalCardSwiper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VerticalCardSwiper', '0.1.0-alpha1'
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
        
        cardSwiper = view as? VerticalCardSwiper
        cardSwiper.datasource = self
        
        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
    }
    
    func cardForItemAt(cardSwiperView: CardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let cardCell = cardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as! ExampleCardCell
                
        return cardCell
    }
    
    func numberOfCards(cardSwiperView: CardSwiperView) -> Int {
        return 100
    }
}
```

#### Properties
```swift
/// Indicates if side swiping on cards is enabled. Set to false if you don't want side swiping. Default value is `true`.
@IBInspectable public var isSideSwipingEnabled: Bool = true
/// The inset (spacing) at the top for the cards. Default is 40.
@IBInspectable public var topInset: CGFloat = 40
/// The inset (spacing) at each side of the cards. Default is 20.
@IBInspectable public var sideInset: CGFloat = 20
/// Sets how much of the next card should be visible. Default is 50.
@IBInspectable public var visibleNextCardHeight: CGFloat = 50
```

### Delegation
To handle swipe gestures, implement the `VerticalCardSwiperDelegate`.

```swift
class ViewController: UIViewController, VerticalCardSwiperDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
    }

    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection) {

        // handle swipe gestures
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
