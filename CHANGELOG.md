# Change Log

## [2.3.0](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/2.3.0) (Oct 4, 2020)

#### Enhancements

- Added `cardForItem` function to `VerticalCardSwiper`.

#### Bug fixes

- Fixed scale animation to transform both x and y values ([#76](https://github.com/JoniVR/VerticalCardSwiper/pull/76)) - thanks [@elfanek](https://github.com/elfanek).

## [2.2.0](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/2.2.0) (Feb 23, 2020)

#### Enhancements

- Added `didCancelSwipe` function to `VerticalCardSwiperDelegate`.

#### Bug fixes

- Fixed `swipeCardAwayProgrammatically` not working correctly in some cases.

## [2.1.0](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/2.1.0) (Jan 31, 2020)

#### Enhancements

- Add `swipeCardAwayProgrammatically` function to `VerticalCardSwiper`.
- Add official Carthage support.
- Update SPM support to 5.1.

## [2.0.1](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/2.0.1) (Aug 19, 2019)

#### Bug fixes

- Fixed paging algorithm not accounting for zero velocity.

## [2.0.0](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/2.0.0) (Jun 21, 2019)

#### API breaking changes

- Renamed `VerticalCardSwiper` property `focussedIndex` to `focussedCardIndex`.
- Renamed `VerticalCardSwiper` property `isPreviousCardVisible` to `isStackingEnabled`.
- Refactored `VerticalCardSwiper` property `indexesForVisibleCards` to **include stacked cards**. ‼️

#### Enhancements

- Added `isStackOnBottom` property to `VerticalCardSwiper`. ([#48](https://github.com/JoniVR/VerticalCardSwiper/pull/48)) - thanks [@stfnhdr](https://github.com/stfnhdr)
- Added `stackedCardsCount` property to `VerticalCardSwiper`. ([#48](https://github.com/JoniVR/VerticalCardSwiper/pull/48)) - thanks [@stfnhdr](https://github.com/stfnhdr)

## [1.0.0](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/1.0.0) (Apr 9, 2019)

#### API breaking changes

- Migrated from `Swift 4.2` -> `Swift 5.0`.
- `scrollToCard(at: Int, animated: Bool) -> Bool` now returns a Boolean indicating if scrolling has failed or succeeded.

#### Bug fixes

- Fixed crash in `scrollToCard` when it was called before the view layout was properly set up. ([#37](https://github.com/JoniVR/VerticalCardSwiper/issues/37)) - thanks [@geniegeist](https://github.com/geniegeist)
- Fixed `CardCell` animation glitch when changing alpha. ([#43](https://github.com/JoniVR/VerticalCardSwiper/issues/43))

## [0.1.0](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0) (Mar 13, 2019)

#### Enhancements

- Added `insertCards` function to `VerticalCardSwiper`.
- Added `deleteCards` function to `VerticalCardSwiper`.
- Added `moveCard` function to `VerticalCardSwiper`.
- Added `focussedIndex` variable to `VerticalCardSwiper`.
- Improved UITests.
- Improved example.
- Cleaned up code and removed some force-unwrapping.
- Added [Swiftlint](https://github.com/realm/SwiftLint).

## [0.1.0-beta7](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta7) (Jan 8, 2019)

#### API breaking changes

- Moved `indexesForVisibleCards` to `VerticalCardSwiper`.

#### Enhancements

- Added `didEndScroll`  function to `VerticalCardSwiperDelegate`. - thanks [@mkhakpaki](https://github.com/mkhakpaki)
- Added `scrollToCard` function to `VerticalCardSwiper`. ([#23](https://github.com/JoniVR/VerticalCardSwiper/issues/23))
- Removed some force unwrapping in the code.

#### Bug fixes

- Fixed nil crash when doing a swipe gesture on an empty `VerticalCardSwiper`.
- Fixed wrong `indexesForVisibleCards` when only one card was present.
- Fixed wrong bottom contentInset calculation.

## [0.1.0-beta6](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta6) (Nov 15, 2018)

#### Enhancements

- Added `indexesForVisibleCards` to `VerticalCardSwiperView`. - thanks [@williamsthing](https://github.com/williamsthing)
- Changed `didTapCard` to support unfocused cards. - thanks [@williamsthing](https://github.com/williamsthing)

#### Bug fixes

 - Fixed `didTapCard` crash. (thanks @williamsthing)

## [0.1.0-beta5](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta5) (Nov 12, 2018)

#### Enhancements

- Added `didTapCard` and `didHoldCard` to `VerticalCardSwiperDelegate`. - thanks [@williamsthing](https://github.com/williamsthing)

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
