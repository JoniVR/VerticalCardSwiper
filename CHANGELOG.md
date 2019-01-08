# Change Log

## [0.1.0-beta7](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta7) (Jan 8, 2019)

#### API breaking changes

- Moved `indexesForVisibleCards` to `VerticalCardSwiper`.

#### Enhancements

- Added `didEndScroll`  function to `VerticalCardSwiperDelegate`. (thanks @mkhakpaki)
- Added `scrollToCard` function to `VerticalCardSwiper`. [(#23)](https://github.com/JoniVR/VerticalCardSwiper/issues/23)
- Removed some force unwrapping in the code.

#### Bug fixes

- Fixed nil crash when doing a swipe gesture on an empty `VerticalCardSwiper`.
- Fixed wrong `indexesForVisibleCards` when only one card was present.
- Fixed wrong bottom contentInset calculation.

## [0.1.0-beta6](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta6) (Nov 15, 2018)

#### Enhancements

- Added `indexesForVisibleCards` to `VerticalCardSwiperView`. (thanks @williamsthing)
- Changed `didTapCard` to support unfocused cards. (thanks @williamsthing)

#### Bug fixes

 - Fixed `didTapCard` crash. (thanks @williamsthing)

## [0.1.0-beta5](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta5) (Nov 12, 2018)

#### Enhancements

- Added `didTapCard` and `didHoldCard` to `VerticalCardSwiperDelegate`. (thanks @williamsthing)

## [0.1.0-beta4](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta4) (Oct 20, 2018)

#### API breaking changes

- Migrated from Swift 4.1 to Swift 4.2.
- Renamed `CellSwipeDirection` to `SwipeDirection`.
- Removed unused `direction` parameter from `internal func endedPanAnimation(withDirection direction: PanDirection, angle: CGFloat)`.
- Removed `animateIn()` function from `VerticalCardSwiperView`.

#### Enhancements

- Added Shazam card stack effect (thanks @VladIacobIonut).
- Added  function `didDragCard(cell: CardCell, swipeDirection: SwipeDirection)` to `VerticalCardSwiperDelegate`.
- General stability and code improvements.

#### Bug fixes

- Fixed crash when swiping away all cards (reaching end).
- Fixed visual glitch that would sometimes occur when adding cards (preparation for future support).

## [0.1.0-beta3](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta3) (Jun 29, 2018)

#### Enhancements

- Added `didScroll` function to `VerticalCardSwiperDelegate`.
- Changed `init(frame: CGRect)` function to be `public` (instead of internal) inside `VerticalCardSwiper`.
- Added small spring animation to `resetToCenter` which results in a small bouncy effect depending on how far you drag.
- Changed some example code to use `init(frame: CGRect)`.

#### Bug fixes

- Fixed possible nil crash in rare occasions when swiping.
- Fixed animation glitch when scrolling cards while card was animating off screen.
- Fixed cards zPosition bug which caused bottom card to overlap top card in some occasions.

## [0.1.0-beta2](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta2) (Jun 26, 2018)

#### Enhancements

- Added `sizeForItem` function to `VerticalCardSwiperDelegate`.
- Added `cardSpacing` property to `VerticalCardSwiper`.
- Added `firstItemTransform` property to `VerticalCardSwiper`.
- Updated example.

## [0.1.0-beta1](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta1) (Jun 21, 2018)

#### API breaking changes

- renamed `CardSwiperView` to `VerticalCardSwiperView`.

#### Enhancements

- Added `willSwipeCardAway` function to `VerticalCardSwiperDelegate`.
- Added `reloadData()` function to `VerticalCardSwiper`.
- Added iPad support.
- Added changelog.
- Updated documentation.
- Cleaned up project.

## [0.1.0-alpha2](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-alpha2) (Jun 17, 2018)

#### API breaking changes

- Simplified `endedPanAnimation` function and made it internal instead of public. 

#### Enhancements

- Added UITests.
- Updated some documentation.

#### Bug fixes

- Fixed swipe bug where swiping left was easier (required less distance) than swiping right.

## [0.1.0-alpha1](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-alpha1) (Jun 12, 2018)

- Initial release.
- Cocoapods release.
