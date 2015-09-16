[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)

# JudoKit #

This is the official Judo iOS SDK. It is built on top of basic frameworks ([Judo](http://github.com/JudoPay/Judo-Swift), [JudoShield](https://github.com/judopay/judo-security)) combining them with additional tools to enable easy integration of payments into your App.

### What is this project for? ###

The JudoKit is a framework for creating easy payments inside your app with [JudoPay](https://www.judopay.com/). It contains an exhaustive toolbelt for everything to related to making payments.

## Integration

### Sign up for judopayments

- To use the Judo SDK, you'll need to [sign up](https://www.judopay.com/signup) and get your app token 
- the SDK has to be integrated in your project using one of the following methods

#### ~~CocoaPods~~

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

add Judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JudoKit', '~> 5.0.0'
```

Then, run the following command:

```bash
$ pod install
```


#### ~~Carthage~~

[Carthage](https://github.com/Carthage/Carthage) - decentralized dependency management.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

- To integrate Judo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JudoPay/JudoKit" >= 5.0.0
```

- On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.
- On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

```sh
/usr/local/bin/carthage copy-frameworks
```

and add the paths to the frameworks you want to use under “Input Files”, e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/Judo.framework
```
### Manual Integration

You can integrate Judo into your project manually if you prefer not to use dependency management.

#### Adding the Framework

- Add JudoSecure as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, changing into your project directory, and entering the following command:

```bash
$ git submodule add https://github.com/JudoPay/JudoKit
```

- Select your application project the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the '+' button in 'Embedded Binaries' section
- Click on 'Add Other...' and Navigate to the Judo-Security/Framework Folder and add JudoSecure.Framework 
- Navigate to your projects folder and add `Judo.framework` and `JudoKit.framework`
- in the project navigator
- Click on the `+` button under the "Linked Frameworks and Libraries" section.
- Select `Security.framework`, `CoreTelephony.framework` and `CoreLocation.framework` from the list presented
- Open the "Build Settings" panel.
- Search for 'Framework Search Paths' and add `$(PROJECT_DIR)/Judo-Security/Framework`
- Search for 'Runpath Search Paths' and make sure it contains '@executable_path/Frameworks'


### Further Setup

- add `import JudoKit` to the top of the file where you want to use the SDK.

- To instruct the SDK to communicate with the sandbox, include the following line  `JudoKit.sandboxed = true` When you are ready to go live you can remove this line. We would recommend to put this in the method `didFinishLaunchingWithOptions` in your AppDelegate

- You can also set your key and secret here if you do not wish to include it in all subsequent calls `JudoKit.setToken(token:, secret:)`


### Examples

#### Token and Secret
the token and secret are accessible from your JudoPay Account [here](https://portal.judopay.com/Developer) after you have created an App and either generated sandbox or live tokens. We recommend you to set this in your AppDelegate in the `didFinishLaunchingWithOptions` method

```swift
let token = "a3xQdxP6iHdWg1zy"
let secret = "2094c2f5484ba42557917aad2b2c2d294a35dddadb93de3c35d6910e6c461bfb"

JudoKit.setToken(token, secret: secret)

```

#### Make a simple Payment

```swift
JudoKit.sharedInstance.payment(judoID, amount: Amount(35.0, currentCurrency), reference: Reference(yourConsumerReference: "payment reference", yourPaymentReference: "consumer reference"), completion: { (response, error) -> () in
    if let _ = error {
    	// handle error
    } else {
        // handle success
	}
})
```


