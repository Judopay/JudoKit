[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/JudoKit.svg)](https://img.shields.io/cocoapods/v/JudoKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)
[![Build Status](https://travis-ci.org/JudoPay/JudoKit.svg)](http://travis-ci.org/JudoPay/JudoKit)

# judoKit Native SDK for iOS #

<p><img align="right" src="http://judopay.github.io/JudoKit/ressources/theme01.png" width="257" height="480"></p>

This is the official Judo iOS SDK. It is built on top of basic frameworks ([Judo](http://github.com/JudoPay/Judo-Swift), [JudoShield](https://github.com/judopay/judoshield)) combining them with additional tools to enable easy integration of payments into your App.

### What is this project for? ###

The JudoKit is a framework for creating easy payments inside your app with [JudoPay](https://www.judopay.com/). It contains an exhaustive toolbelt for everything to related to making payments.

## Integration

### Sign up for judopayments

- To use the Judo SDK, you'll need to [sign up](https://www.judopay.com/signup) and get your app token 
- the SDK has to be integrated in your project using one of the following methods

#### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.39 supports Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

add Judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JudoKit', '~> 5.5'
```

Then, run the following command:

```bash
$ pod install
```


#### Carthage

[Carthage](https://github.com/Carthage/Carthage) - decentralized dependency management.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

- To integrate Judo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JudoPay/JudoKit" >= 5.5
```

- execute the following command in your project folder. This should clone the project and build the JudoKit scheme

```bash
$ carthage bootstrap
```

- On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop `Judo.framework` and `JudoKit.framework` from the Carthage/Build folder and `JudoShield.framework` from the Carthage/Checkouts folder on disk.
- On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

```sh
/usr/local/bin/carthage copy-frameworks
```

and add the paths to the frameworks you want to use under “Input Files”, e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/JudoKit.framework
$(SRCROOT)/Carthage/Build/iOS/Judo.framework
$(SRCROOT)/Carthage/Checkouts/JudoShield/Framework/JudoShield.framework
```
### Manual Integration

You can integrate Judo into your project manually if you prefer not to use dependency management.

#### Adding the Framework

- Add JudoKit as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, changing into your project directory, and entering the following command:

```bash
$ git submodule add https://github.com/JudoPay/JudoKit
```

- as JudoKit has submodules you need to initialise them as well by cd-ing into the `JudoKit` folder and executing the following command

```bash
$ cd JudoKit
$ git submodule update
```
- open your project and select your application in the Project Navigator (blue project icon)
- Navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the '+' button in 'Embedded Binaries' section
- Click on 'Add Other...' and Navigate to the JudoShield/Framework Folder and add JudoSecure.Framework 
- Navigate to your projects folder and add `JudoKit.framework`
- in the project navigator
- Click on the `+` button under the "Linked Frameworks and Libraries" section.
- Select `Security.framework`, `CoreTelephony.framework` and `CoreLocation.framework` from the list presented
- Open the "Build Settings" panel.
- Search for 'Framework Search Paths' and add `$(PROJECT_DIR)/JudoKit/JudoShield/Framework`
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

For testing purposes you should set the app into sandboxed mode by calling the function `sandboxed(value: Bool)` on `JudoKit`

```swift
JudoKit.sandboxed(true)
```

When delivering your App to the AppStore make sure to remove the line.

#### Make a simple Payment

```swift
JudoKit.payment(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "consumer reference"), completion: { (response, error) -> () in
    self.dismissViewControllerAnimated(true, completion: nil)
    if let _ = error {
        // handle error
        return // BAIL
    }
    if let resp = response, transactionData = resp.items.first {
    // handle successful transaction
    }
    }, errorHandler: { (error) -> () in
        // if the user cancelled, this error is called
        if error == JudoError.UserDidCancel {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // handle other errors that may encounter
})
```

#### Make a simple PreAuth

```swift
JudoKit.preAuth(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "consumer reference"), completion: { (response, error) -> () in
    self.dismissViewControllerAnimated(true, completion: nil)
    if let _ = error {
        // handle error
        return // BAIL
    }
    if let resp = response, transactionData = resp.items.first {
    // handle successful transaction
    }
    }, errorHandler: { (error) -> () in
        // if the user cancelled, this error is called
        if error == JudoError.UserDidCancel {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // handle other errors that may encounter
})
```


#### Register a card

```swift
JudoKit.registerCard(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "payment reference"), completion: { (response, error) -> () in
    self.dismissViewControllerAnimated(true, completion: nil)
    if let _ = error {
        // handle error
        return // BAIL
    }
    if let resp = response, transactionData = resp.items.first {
    // handle successful transaction
    }
    }, errorHandler: { (error) -> () in
        // if the user cancelled, this error is called
        if error == JudoError.UserDidCancel {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // handle other errors that may encounter
})
```

#### Make a repeat payment

```swift
if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
    JudoKit.tokenPayment(judoID, amount: Amount(30, currentCurrency), reference: Reference(consumerRef: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
        self.dismissViewControllerAnimated(true, completion: nil)
        if let _ = error {
            // handle error
            return // BAIL
        }
        if let resp = response, transactionData = resp.items.first {
            // handle successful transaction
        }
        }, errorHandler: { (error) -> () in
            // if the user cancelled, this error is called
            if error == JudoError.UserDidCancel {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            // handle other errors that may encounter
        })
} else {
    // no card details available
}
```

#### Make a repeat preauth

```swift
if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
    JudoKit.tokenPreAuth(judoID, amount: Amount(30, currentCurrency), reference: Reference(consumerRef: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
        self.dismissViewControllerAnimated(true, completion: nil)
        if let _ = error {
            // handle error
            return // BAIL
        }
        if let resp = response, transactionData = resp.items.first {
            // handle successful transaction
        }
        }, errorHandler: { (error) -> () in
            // if the user cancelled, this error is called
            if error == JudoError.UserDidCancel {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            // handle other errors that may encounter
        })
} else {
    // no card details available
}
```

#### Theme Customisation

The JudoKit integrated UI Solution for making transactions has a simple method to customise the theme. The `JudoKit` class has a property that takes a `UIColor` instance and automatically adjusts the general look and feel for this color based on a light or dark theme.

```swift
JudoKit.tintColor = UIColor.greenColor()
```

This way you can achieve a number of very different looks in an instant

![Light Theme Image](http://judopay.github.io/JudoKit/ressources/theme01.png)
![Dark Theme Image](http://judopay.github.io/JudoKit/ressources/theme02.png)
