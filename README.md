[![Circle CI](https://circleci.com/gh/KiiPlatform/thing-if-iOSSDK/tree/master.svg?style=svg)](https://circleci.com/gh/KiiPlatform/thing-if-iOSSDK/tree/master)

iOS SDK for Kii Thing Interaction Framework.

# Requirements

- iOS 8.0+
- Xcode 8.0+
- swift 3.0+

# Installation
thing-if iOSSDK only provides dynamic framework, which are only available on iOS 8+

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build ThingIFSDK 0.8.0+.

To integrate ThingIFSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ThingIFSDK', '~> 0.8.0'
```

Then, run the following command:

```bash
$ pod install
```

## Carthage

**Note**: Please use 0.9.1+

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate thing-if iOSSDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "KiiPlatform/thing-if-iOSSDK" >= 0.8
```

## CocoaPods or Carthage

Using CocoaPods you can only integrate with released thing-if iOSSDK, and Carthage allow you to build other branch of this repository. 

# Sample Project

A sample project using thing-if iOSSDK can be found [here](https://github.com/KiiPlatform/thing-if-iOSSample).

# License

thing-if iOSSDK is released under the MIT license. See LICENSE for details.
