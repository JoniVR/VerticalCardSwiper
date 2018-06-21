# Change Log

## [0.1.0-beta1](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-beta1) (Jun 21, 2018)

#### API breaking changes

- renamed `CardSwiperView` to `VerticalCardSwiperView`.

#### Enhancements

- Added `willSwipeCardAway(cell: CardCell, swipeDirection: CellSwipeDirection)` to `VerticalCardSwiperDelegate`
- Added `reloadData()` to `VerticalCardSwiper`
- Added iPad support
- Added changelog
- Updated documentation
- Cleaned up project

## [0.1.0-alpha2](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-alpha2) (Jun 17, 2018)

#### API breaking changes

- Simplified `endedPanAnimation` and made it internal instead of public. 

#### Enhancements

- Added UITests
- Updated some documentation

#### Bug fixes

- Fixed swipe bug where swiping left was easier (required less distance) than swiping right.

## [0.1.0-alpha1](https://github.com/JoniVR/VerticalCardSwiper/releases/tag/0.1.0-alpha1) (Jun 12, 2018)

- Initial release
- Cocoapods release
