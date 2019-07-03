# MGSwipeCards
![Swift-Version](https://img.shields.io/badge/Swift-4.1-orange.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/MGSwipeCards.svg)
![license](https://img.shields.io/cocoapods/l/MGSwipeCards.svg)
![CocoaPods](https://img.shields.io/cocoapods/p/MGSwipeCards.svg)

🔥 A modern swipeable card framework inspired by Tinder and built with Facebook's Pop animation library.

![Tinder Demo](https://raw.githubusercontent.com/mac-gallagher/MGSwipeCards/master/Images/swipe_example.gif)

# Features
- [x] Maximum customizability - create your own card template!
- [x] Accurate swipe recognition based on velocity and card position
- [x] Programmatic swiping
- [x] Animated undo and card stack reordering
- [x] Smooth overlay view transitions
- [x] Dynamic card loading using data source/delegate pattern

***

- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Contributing](#contributing)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
   - [MGCardStackView](#mgcardstackview)
      - [Useful Methods](#useful-methods)
      - [Data source & delegates](#data-source-&-delegates)
      - [MGCardStackViewOptions](#mgcardstackviewoptions)
   - [MGSwipeCard](#mgswipecard)
      - [Card Appearance](#card-appearance)
      - [MGSwipeCardOptions](#mgswipecardoptions)
- [Sources](#sources)
- [Author](#author)
- [License](#license)

# Example
To run the example project, clone the repo and run the `MGSwipeCards-Example` target. 

The example project uses the Tinder-inspired framework [PopBounceButton](<https://github.com/mac-gallagher/PopBounceButton>), make sure to check it out!

# Requirements
* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

# Installation

### CocoaPods
MGSwipeCards is available through [CocoaPods](<https://cocoapods.org/>). To install it, simply add the following line to your `Podfile`:

	pod 'MGSwipeCards'

### Manual
1. Download and drop the `MGSwipeCards` directory into your project. 
2. Install Facebook's [Pop](<https://github.com/facebook/pop>) library.

# Contributing
- If you **found a bug**, open an issue and tag as bug.
- If you **have a feature request**, open an issue and tag as feature.
- If you **want to contribute**, submit a pull request.
	- In order to submit a pull request, please fork this repo and submit a pull request from your forked repo.
	- Have a detailed message as to what your pull request fixes/enhances/adds.

# Quick Start
1. Create your own card by subclassing `MGSwipeCard`. Our card simply displays an image.

    ```swift
    class SampleCard: MGSwipeCard {
    
        var model: SampleCardModel? {
            didSet {
                self.setContentView(UIImageView(model.image))
            }
        }
    
    }
    
    struct SampleCardModel {
        var image: UIImage
    }
    ```

2. Add a `MGCardStackView` to your view and implement to the protocol `MGCardStackViewDataSource` (make sure to set your card stack's `dataSource` property).

    ```swift
    class ViewController: UIViewController {
    
        let cardStack = MGCardStackView()
        
        var cardModels: [SampleCardModel] {
            var models = [SampleCardModel]()
        
            let model1 = SampleCardModel(image: UIImage(named: "cardImage1"))
            let model2 = SampleCardModel(image: UIImage(named: "cardImage2"))
            let model3 = SampleCardModel(image: UIImage(named: "cardImage3"))
                
            models.append(model1)
            models.append(model2)
            models.append(model3)
        
            return models
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(cardStack)
            cardStack.frame = view.safeAreaLayoutGuide.bounds.insetBy(dx: 10, dy: 50)
            cardStack.dataSource = self
        }
        
    }

    //MARK: - Data Source Methods
	
        extension ViewController: MGCardStackViewDataSource {

	     func numberOfCards() -> Int {
		      return cards.count
         }
        
	     func card(forItemAtIndex index: Int) -> MGSwipeCard {
	         let card = SampleCard()
	         card.model = models[index]
	         return card
	     }
	
    }
    ```
    
3. Happy swiping!

# Architecture
There are two major components in the `MGSwipeCards` framework. The first is the `MGCardStackView` which displays the cards. It is responsible for managing the lifetime of the cards and handling all animations. The second component is the cards themselves. Each draggable `MGSwipeCard` contains the swipe logic and is responsible for notifying the card stack of a registered swipe.

## `MGCardStackView`
To use a `MGCardStackView`, add it to your view and implement the `MGCardStackViewDataSource` protocol. Once the card stack's data source is set, the cards you provided will automatically be loaded. `MGCardStackView` exposes the following variables:

```swift
var delegate: MGCardStackViewDelegate?
var dataSource: MGCardStackViewDataSource?
var options: MGCardStackViewOptions
var currentCardIndex: Int
```

### Useful Methods
The following methods can be accessed from within `MGCardStackView`.

#### Swipe
Performs a swipe programmatically in the given direction. Any delegate methods are called as usual.

```swift
func swipe(withDirection direction: SwipeDirection)
```

![Shift](https://raw.githubusercontent.com/mac-gallagher/MGSwipeCards/master/Images/swipe.gif)

#### Undo
Restores the card stack to its state before the last swipe.

```swift
func undoLastSwipe()
```

![Shift](https://raw.githubusercontent.com/mac-gallagher/MGSwipeCards/master/Images/undo.gif)

#### Shift
Shifts the card stack's cards by the given distance. Any previously swiped cards are skipped over.

```swift
func shift(withDistance distance: Int = 1, animated: Bool)
```

![Shift](https://raw.githubusercontent.com/mac-gallagher/MGSwipeCards/master/Images/shift.gif)

### Data source & delegates
To populate your card stack, you must conform your view controller to the `MGCardStackViewDataSource` protocol and implement the following required functions:

```swift
func numberOfCards(in cardStack: MGCardStackView) -> Int
func cardStack(_ cardStack: MGCardStackView, cardForIndexAt index: Int) -> MGSwipeCard
```
Once your card stack's `dataSource` property is set, your card stack will automatically be populated. 

To react to swipes and other related events, you must conform your view controller to the `MGCardStackViewDelegate` protocol. The protocol contains the following (optional) methods:

```swift
func didSwipeAllCards(_ cardStack: MGCardStackView)
func additionalOptions(_ cardStack: MGCardStackView) -> MGCardStackViewOptions
func cardStack(_ cardStack: MGCardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection)
func cardStack(_ cardStack: MGCardStackView, didUndoSwipeOnCardAt index: Int, from direction: SwipeDirection)
func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int)
func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int, tapCorner: UIRectCorner)
```

**NOTE:** The `didSwipeCardAt` and `didSwipeAllCards ` methods are called regardless if a card was swiped programmatically or by the user.

### `MGCardStackViewOptions`
All of the animations in `MGCardStackView` can be adjusted. Simply create a new instance of `MGCardStackViewOptions` and attach it to your card stack using the `additionalOptions ` delegate method.

The following properties of `MGCardStackViewOptions` are available:

```swift
var backgroundCardScaleFactor: CGFloat = 0.95
var backgroundCardResetAnimationDuration: TimeInterval = 0.3
var backgroundCardScaleAnimationDuration: TimeInterval = 0.4
var forwardShiftAnimationInitialScaleFactor: CGFloat = 0.98
var backwardShiftAnimationInitialScaleFactor: CGFloat = 1.02
var cardOverlayFadeInOutDuration: TimeInterval = 0.15
var cardUndoAnimationDuration: TimeInterval = 0.2
var cardSwipeAnimationMaximumDuration: TimeInterval = 0.8
var cardResetAnimationSpringBounciness: CGFloat = 12.0
var cardResetAnimationSpringSpeed: CGFloat = 20.0
```

Additionally, `MGCardStackViewOptions` manages the following UI-related properties:

```swift
var cardStackInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
var numberOfVisibleCards: Int = 2
```

The default options work great for a quick implementation.

## `MGSwipeCard`
The `MGSwipeCard` is a UIView with added gesture recognizers to handle swipe recognition and achieve the visual drag effect. It is also responsible for informing its parent card stack of a registered (or cancelled) swipe. To use a `MGSwipeCard `, you first need to subclass it. In the initialization methods, set your card's appearance using the methods outlined in the section below.

Each `MGSwipeCard` exposes the following properties:

```swift
var swipeDirections = SwipeDirection.allDirections
var activeDirection: SwipeDirection?
var options = MGSwipeCardOptions.defaultOptions
var delegate: MGSwipeCardDelegate?
var touchPoint: CGPoint?
var contentView: UIView?
var footerView: UIView?
var footerIsTransparent = false
var footerHeight: CGFloat = 100
```

### Card Appearance
Each `MGSwipeCard` consists of three UI components: its *content view*, *footer view*, and *overlay view(s)*.

The *content view* is the card's primary view. You can include your own card template here. The content view is set with

```swift 
func setContentView(_ content: UIView?)
```

The card's *footer view* is set just below the card's content view. To have the card's content continue past the footer view, set `isFooterTransparent` is to `true`. The footer's height is modified with `footerHeight`. The card's footer is set with 

```swift 
func setFooterView(_ footer: UIView?)
```

An *overlay view* is a view whose alpha value reacts to the user's dragging. The overlays are laid out above the card's footer, regardless if the footer is transparent or not. The card's overlays are set with

```swift 
func setOverlay(forDirection direction: SwipeDirection, overlay: UIView?)
```

### `MGSwipeCardOptions`
The swipe recognition settings can be modified via `MGSwipeCardOptions`, which exposes the following properties:

```swift
var minimumSwipeSpeed: CGFloat = 1600
var minimumSwipeMargin: CGFloat = 0.5
var maximumRotationAngle: CGFloat = CGFloat.pi / 10
```
The default options work and should feel natural.

# Sources
- [Pop](<https://github.com/facebook/pop>): Facebook's iOS animation framework.
- *"Building a Tinder-esque Card Interface"* by Phill Farrugia (on [Medium](https://medium.com/@phillfarrugia/building-a-tinder-esque-card-interface-5afa63c6d3db))

# Author
Mac Gallagher, jmgallagher36@gmail.com

# License
MGSwipeCards is available under the [MIT License](LICENSE), see LICENSE for more infomation.