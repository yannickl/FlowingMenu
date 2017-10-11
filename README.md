# FlowingMenu

[![Supported Platforms](https://cocoapod-badges.herokuapp.com/p/FlowingMenu/badge.svg)](http://cocoadocs.org/docsets/FlowingMenu/) [![Version](https://cocoapod-badges.herokuapp.com/v/FlowingMenu/badge.svg)](http://cocoadocs.org/docsets/FlowingMenu/) [![Swift Package Manager compatible](https://img.shields.io/badge/SPM-%E2%9C%93-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager) [![Carthage compatible](https://img.shields.io/badge/Carthage-%E2%9C%93-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/yannickl/FlowingMenu.svg?branch=master)](https://travis-ci.org/yannickl/FlowingMenu) [![codecov.io](http://codecov.io/github/yannickl/FlowingMenu/coverage.svg?branch=master)](http://codecov.io/github/yannickl/FlowingMenu?branch=master) [![codebeat badge](https://codebeat.co/badges/5b519917-eedc-4b7b-8a2d-9dfeed597894)](https://codebeat.co/projects/github-com-yannickl-flowingmenu)

FlowingMenu provides an interactive transition manager to display menu with a flowing and bouncing effects. The Objective-C countepart is here https://github.com/yannickl/YLFlowingMenu.

<p align="center">
  <img src="http://yannickloriot.com/resources/flowingmenu.gif" alt="FlowingMenu" width="300"/>
</p>

<p align="center">
    <a href="#requirements">Requirements</a> • <a href="#usage">Usage</a> • <a href="#installation">Installation</a> • <a href="#contribution">Contribution</a> • <a href="#contact">Contact</a> • <a href="#license-mit">License</a>
</p>

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3.0+

## Usage

At first, import FlowingMenu:

```swift
import FlowingMenu
```

Then just add a `FlowingMenuTransitionManager` object that acts as `transitioningDelegate` of the view controller you want display:

```swift
let flowingMenuTransitionManager = FlowingMenuTransitionManager()

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  let vc                   = segue.destination
  vc.transitioningDelegate = flowingMenuTransitionManager
}
```

If you want interactive transition you will need to implement the `FlowingMenuDelegate` methods and defines the views which will interact with the gestures:

```swift
var menu: UIViewController?

override func viewDidLoad() {
  super.viewDidLoad()

  // Add the pan screen edge gesture to the current view
  flowingMenuTransitionManager.setInteractivePresentationView(view)

  // Add the delegate to respond to interactive transition events
  flowingMenuTransitionManager.delegate = self
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  let vc                   = segue.destination
  vc.transitioningDelegate = flowingMenuTransitionManager

  // Add the left pan gesture to the menu
  flowingMenuTransitionManager.setInteractiveDismissView(vc.view)

  // Keep a reference of the current menu
  menu = vc
}

// MARK: - FlowingMenu Delegate Methods

func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
  performSegue(withIdentifier: "PresentSegueName", sender: self)
}

func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
  menu?.performSegue(withIdentifier: "DismissSegueName", sender: self)
}
```

Have fun! :)

### For more information...

To go further, take a look at the documentation and the example project.

*Note: All contributions are welcome*

## Installation

#### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _FlowingMenu_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!
pod 'FlowingMenu', '~> 3.0.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import FlowingMenu` framework into your files.

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `FlowingMenu` into your Xcode project using Carthage, specify it in your `Cartfile` file:

```ogdl
github "yannickl/FlowingMenu" >= 3.0.0
```

#### Swift Package Manager
You can use [The Swift Package Manager](https://swift.org/package-manager) to install `FlowingMenu` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/yannickl/FlowingMenu.git", versions: "3.0.0" ..< Version.max)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

#### Manually

[Download](https://github.com/YannickL/FlowingMenu/archive/master.zip) the project and copy the `FlowingMenu` folder into your project to use it in.

## Contribution

Contributions are welcomed and encouraged *♡*.

## Contact

Yannick Loriot
 - [https://21.co/yannickl/](https://21.co/yannickl/)
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)

## License (MIT)

Copyright (c) 2015-present - Yannick Loriot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
