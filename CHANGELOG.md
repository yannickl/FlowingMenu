# Change log

#[Version 2.0.1](https://github.com/yannickl/FlowingMenu/releases/tag/2.0.1)
Released on 2016-10-10.

- Fixing the gesture priority [#9](https://github.com/yannickl/FlowingMenu/issues/9).

## [Version 2.0.0](https://github.com/yannickl/FlowingMenu/releases/tag/2.0.0)
Released on 2016-09-14.

**Swift 3 supports**

## [Version 1.1.0](https://github.com/yannickl/FlowingMenu/releases/tag/1.1.0)
Released on 2016-09-14.

**Swift 2.3 supports**

## [Version 1.0.0](https://github.com/yannickl/FlowingMenu/releases/tag/1.0.0)
Released on 2016-03-01.

- [ADD] Swift Package Manager support

## [Version 0.3.0](https://github.com/yannickl/FlowingMenu/releases/tag/0.3.0)
Released on 2016-01-24.

- [ADD] Tap to dismiss [#3](https://github.com/yannickl/FlowingMenu/issues/3)
- [FIX] Bug when Slide left to close [#5](https://github.com/yannickl/FlowingMenu/issues/5)

## [Version 0.2.0](https://github.com/yannickl/FlowingMenu/releases/tag/0.2.0)
Released on 2015-12-06.

- [REFACTORING] Adding the `FlowingMenuTransitionStatus` class to allow animation testing
- [RENAMING] Renaming `flowingMenuTransitionManagerNeedsPresentMenu:` to `flowingMenuNeedsPresentMenu:`
- [RENAMING] Renaming `flowingMenuTransitionManagerNeedsDismissMenu:` to `flowingMenuNeedsDismissMenu:`
- [RENAMING] Renaming `colorOfElasticShapeInFlowingMenuTransitionManager:` to `colorOfElasticShapeInFlowingMenu:`
- [RENAMING] Renaming `flowingMenuTransitionManager:widthOfMenuView:` to `flowingMenu:widthOfMenuView:`

## [Version 0.1.0](https://github.com/yannickl/FlowingMenu/releases/tag/0.1.0)
Released on 2015-12-04.

- `flowingMenuTransitionManager:widthOfMenuView:` delegate method to get the width menu
- `colorOfElasticShapeInFlowingMenuTransitionManager:` delegate method to get the color of the elastic shape
- `flowingMenuTransitionManagerNeedsPresentMenu:` and `flowingMenuTransitionManagerNeedsDismissMenu:` delegate methods to respond to interactive event
- `setInteractivePresentationView:` and `setInteractiveDismissView:` methods define views attached with gestures
- Cocoapods support
- Carthage support
