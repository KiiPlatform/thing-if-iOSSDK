[![Circle CI](https://circleci.com/gh/KiiPlatform/thing-if-iOSSDK/tree/master.svg?style=svg)](https://circleci.com/gh/KiiPlatform/thing-if-iOSSDK/tree/master)

iOS SDK for Kii Thing Interaction Framework.

# Requirements

- iOS 8.0+
- Xcode 7.0+
- swift 2.0+

# Installation
thing-if iOSSDK only provides dynamic framework, which are only available on iOS 8+

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
## Manually

### Build Locally

If you would like to build framework from the branch other than master, you can build the framework locally.

- Clone the source code of thing-if iOSSDK from Github.

```bash
$ git clone https://github.com/KiiPlatform/thing-if-iOSSDK.git
```

- Build thinf-if iOSSDK locally. If built successfully, a framework named `ThingIFSDK.framework` can be found under folder `ThingIFSDK/dist/`

```bash
$ cd ThingIFSDK
$ make build
```

- Import the generated framework to your project.

# Sample Project

A sample project using thing-if iOSSDK can be found [here](https://github.com/KiiPlatform/thing-if-iOSSample).

# License
