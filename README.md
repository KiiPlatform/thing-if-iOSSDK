[![Circle CI](https://circleci.com/gh/KiiPlatform/IoTCloud-iOSSDK/tree/master.svg?style=svg)](https://circleci.com/gh/KiiPlatform/IoTCloud-iOSSDK/tree/master)

iOS SDK for Kii IoT Cloud.

# Requirements

- iOS 8.0+
- Xcode 7.0+
- swift 2.0+

# Installation
IoTCloud-iOSSDK only provides dynamic framework, which are only available on iOS 8+

## Carthage[under development]

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

- Get the source code of IoTCloud-iOSSDK from Github.

```bash
$ git clone https://github.com/KiiPlatform/IoTCloud-iOSSDK.git
```

- Build IoTCloud-iOSSDK. If built successfully, a framework named `IoTCloudSDK.framework` can be found under folder `IoTCloud-iOSSDK/dist/`

```bash
$ cd IoTCloudSDK
$ make build
```

- Import the generated framework to your project.

### Download from Kii Developer Portal

- Download IoTCloudSDK from  [Kii Developer Portal](https://developer.kii.com/v2/downloads)
- Import the Downloaded IoTCloudSDK.framework to your project.

# Usage

Please check the [Documentation](http://documentation.kii.com/en/starts/iotsdk/) from Kii Cloud.

# Sample Project

There is a sample project `IoTCloudSDK/SampleProject.xcodeproj` in this repository using `IoTCloudSDK.framework`.

## Configure IoTCloudSDK.framework

Since the sample project uses `IoTCloudSDK`, you need to provide the framework for it. The path for the framework should be 'IoTCloudSDK/dist/IoTCloudSDK.framework'. Please confirm whether the framework existing in that path.

For the first time you need to generate one for it ( Please confirm [Build locally](#build-locally)).  

## Download the Latest KiiSDK.framework

Sample project uses KiiSDK to get the access token of KiiUser from Kii Cloud, so you should download it from [Kii Developer Portal](https://developer.kii.com/v2/downloads).

Then import it to Sample Project.

## Change Properties

KiiSDK and IoTCloudSDK need the appID and appKey. Please set the appropriate values in the file `IoTCloudSDK/Properties.plist`
# License
