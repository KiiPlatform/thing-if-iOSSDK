[![Circle CI](https://circleci.com/gh/KiiPlatform/IoTCloud-iOSSDK/tree/master.svg?style=svg)](https://circleci.com/gh/KiiPlatform/IoTCloud-iOSSDK/tree/master)

iOS SDK for Kii IoT Cloud.

# Requirements

- iOS 8.0+
- Xcode 7.0+
- swift 2.0+

# Installation
IoTCloud-iOSSDK only provides dynamic framework, which are only available on iOS 8+

## Carthage

**Note**: Please use 0.9.1+

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate IoTCloud-iOSSDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "KiiPlatform/IoTCloud-iOSSDK" >= 0.8
```
## Manually

### Build Locally

If you would like to build framework from the branch other than master, you can build the framework locally.

- Clone the source code of IoTCloud-iOSSDK from Github.

```bash
$ git clone https://github.com/KiiPlatform/IoTCloud-iOSSDK.git
```

- Build IoTCloud-iOSSDK locally. If built successfully, a framework named `ThingIFSDK.framework` can be found under folder `IoTCloud-iOSSDK/dist/`

```bash
$ cd ThingIFSDK
$ make build
```

- Import the generated framework to your project.

### Download from Kii Developer Portal

- Download ThingIFSDK from  [Kii Developer Portal](https://developer.kii.com/v2/downloads)
- Import the Downloaded ThingIFSDK.framework to your project.

# Usage

Please check the [Documentation](http://documentation.kii.com/en/starts/iotsdk/) from Kii Cloud.

# Sample Project

A sample project using ThingIFSDK can be found [here](https://github.com/KiiPlatform/IoTCloud-iOSSample).

# License
