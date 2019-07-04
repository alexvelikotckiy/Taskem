<p align="center">
	<img src="Screenshots/app%20icon.png">
</p>

# Taskem #

[![Swift Version][swift-image]][swift-url]
![Platform][ios-image]
[![License][license-image]][license-url]
![Xcode][xcode-image]

Taskem is a way to browse and maintain your tasks and goals on any iPhone device.
Keep an eye on your tasks with the ability to view everything. The project’s goal is to show 
practices of using VIPER architecture and Unit Testing in iOS using swift 5. In addition,
the app has an example of code with Unit Test coverage.

# The App Overview #

<p align="center">
	<img src="Screenshots/Schedule%20White%20Swipes.png">
	<img src="Screenshots/Calendar%20Dark.png">
	<img src="Screenshots/Calendar%20White%203.png">
	<img src="Screenshots/Popup%20Dark.png">
</p>

## Key Features ##

### VIPER ###

This project's code follows the [VIPER][viper-url] 
pattern, first [introduced by Mutual Mobile][mutual mobile-url]. 
VIPER is an implementation of Clean Architecture to iOS apps.
The word VIPER is a backronym for View, Interactor, Presenter, Entity,
and Routing. Additionally, the app
uses ViewModels to represent screens data.

### Unit Testing ###

The app has an example of Unit Testing which includes more than 500+ test cases.
[Nimble][nimble-url] is a framework which was used in unit testing.
For the most of Test Doubles structures as mock, stub, dummy and spy was used 
code generation [utility][mock-generator-url].

### Firebase ###

[Firebase][firebase-url] is Google's real time NoSQL Backend as a Service (BaaS) platform that can ##
stream data to millions of users at the same time through the power of Websocket.

This app demonstrates basic actions which can be made without any backend code.

### Code generation ###

Also, for ease of coding, there were used code generation utilities:

- [Generamba][generamba-url] - generation of all VIPER skeletons,
- [Sourcery][sourcery-url] - creating auto generated Equatable protocol realizations,
- [Swiftgen][swiftgen-url] - conversion of images, colors into swift structures,
- [SwiftMockGeneratorForXcode][mock-generator-url] - utility for Test Doubles generation.

## Instalation ##

The project uses [CocoaPods][pods-url] and [Carthage][carthage-url] for dependencies management.
In case you don't use any of the mentioned above:

- ```sudo gem install cocoapods```
- ```brew install carthage``` or use another [method][carthage-install-url]

### Compilation ###

In order to compile Taskem you need to do the following:

- ```pod install```
- ```carthage update --platform iOS```

The app uses firebase services, so you have to create your own firebase project in the [Firebase Console][firebase-installation-url] and generate a ```.plist``` file. The projects has two types of these ```.plist``` files which are used in Production and Development schemes.

Also there are two files of color palettes. Which need to drop into ```~/Library/Colors``` folder.

- [```TaskemLists.clr```][license-url]
- [```TaskemMain.clr```][license-url]

For debugging use the Development scheme.

## Contributing ##

### Bug Reports & Feature Requests ###

Please use GitHub issues to report any bugs or file feature requests. If you want fix it yourself or suggest a new feature, feel free to send in a pull request. 

### Pull requests ###

Pull requests should include information about what has been changed. Also, try to include links to issues in order to better review the pull request.

## Contacts ##

- Email: <alexvelikotckiy@gmail.com>
- GitHub: [alexvelikotckiy][author-url]

## License ##

Taskem is available under the [MIT license][license-url]. 

[license-url]: LICENSE
[swift-url]: https://swift.org/
[viper-url]: https://www.ckl.io/blog/ios-project-architecture-using-viper/
[mutual mobile-url]: https://mutualmobile.com/resources/meet-viper-fast-agile-non-lethal-ios-architecture-framework/
[nimble-url]: https://github.com/Quick/Nimble
[generamba-url]: https://github.com/strongself/Generamba
[sourcery-url]: https://github.com/krzysztofzablocki/Sourcery
[swiftgen-url]: https://github.com/SwiftGen/SwiftGen
[mock-generator-url]: https://github.com/seanhenry/SwiftMockGeneratorForXcode
[pods-url]: https://cocoapods.org
[carthage-url]: https://github.com/Carthage/Carthage
[carthage-install-url]: https://github.com/Carthage/Carthage#installing-carthage
[firebase-url]: https://firebase.google.com
[firebase-installation-url]: https://console.firebase.google.com
[taskem-lists-palette-url]: TaskemLists.clr
[taskem-main-palette-url]: TaskemMain.clr
[author-url]: https://github.com/alexvelikotckiy

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[swift-image]: https://img.shields.io/badge/swift-5-orange.svg
[xcode-image]: https://img.shields.io/badge/xcode-10+-blue.svg
[ios-image]: http://img.shields.io/badge/iOS-12.0%2B-blue.svg
