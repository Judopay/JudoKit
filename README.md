[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/JudoKit.svg)](https://img.shields.io/cocoapods/v/JudoKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)
[![Build Status](https://travis-ci.org/JudoPay/JudoKit.svg)](http://travis-ci.org/JudoPay/JudoKit)

# judoKit Native SDK for iOS

This is the official judo iOS SDK. It is built on top of basic frameworks ([Judo](http://github.com/JudoPay/Judo-Swift), [JudoShield](https://github.com/judopay/judoshield)) combining them with additional tools to enable easy integration of payments into your app. It works for both Swift and Obj-C projects.

##### **\*\*\*Due to industry-wide security updates, versions below 5.5.1 of this SDK will no longer be supported after 1st Oct 2016. For more information regarding these updates, please read our blog [here](http://hub.judopay.com/pci31-security-updates/).*****

### What is this project for?

judoKit is a framework for creating easy payments inside your app with [judoPay](https://www.judopay.com/). It contains an exhaustive toolbelt for everything to related to making payments.

## Integration

**Be aware that bit code must be disabled when you submit your Archive to the App Store**

### Sign up to judo's platform

- To use judo's SDK, you'll need to [sign up](https://www.judopay.com/signup) and get your app token. 
- the SDK has to be integrated in your project using one of the following methods:

#### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.39 supports Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

add judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JudoKit', '~> 5.5.3'
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

- To integrate judo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JudoPay/JudoKit" >= 5.5.3
```

- execute the following command in your project folder. This should clone the project and build the judoKit scheme.

```bash
$ carthage bootstrap
```

- On your application targets’ “General” settings tab, in the “Embedded Binaries" section, drag and drop `Judo.framework` and `JudoKit.framework` from the Carthage/Build folder and `JudoShield.framework` from the Carthage/Checkouts folder on disk.
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

### Manual integration

You can integrate judo into your project manually if you prefer not to use dependency management.

#### Adding the Framework

- Add judoKit as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, changing into your project directory, and entering the following command:

```bash
$ git submodule add https://github.com/JudoPay/JudoKit
```

- as judoKit has submodules you need to initialize them as well by cd-ing into the `JudoKit` folder and executing the following command:

```bash
$ cd JudoKit
$ git submodule update --init --recursive
```
- Open your project and select your application in the Project Navigator (blue project icon).
- Drag and drop the `JudoKit.xcodeproj` project file inside the JudoKit folder into your project (just below the blue project icon inside Xcode).
- Drag and drop the `Judo.xcodeproj` project file inside the JudoKit/Judo-Swift folder into your project (just below the blue project icon inside Xcode).
- Navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the '+' button in 'Embedded Binaries' section.
- Click on 'Add Other...' and Navigate to the JudoKit/JudoShield/Framework Folder and add JudoShield.Framework.
- Click on the same '+' button and add `JudoKit.framework` under the JudoKit project from the `Products` folder and `Judo.framework` from the Judo project under the `Products` folder **make sure not to add the Judo.framework file from the JudoKit project, these two have to be from each of the projects product folder**.
- In the project navigator, click on the `+` button under the "Linked Frameworks and Libraries" section.
- Select `Security.framework`, `CoreTelephony.framework` and `CoreLocation.framework` from the list presented.
- Open the "Build Settings" panel.
- Search for 'Framework Search Paths' and add `$(PROJECT_DIR)/JudoKit/JudoShield/Framework`.
- Search for 'Runpath Search Paths' and make sure it contains '@executable_path/Frameworks'.


### Further setup

- Add `import JudoKit` to the top of the file where you want to use the SDK.

- To instruct the SDK to communicate with the sandbox, include the following line  `JudoKit.sandboxed = true`. When you are ready to go live you can remove this line. We would recommend to put this in the method `didFinishLaunchingWithOptions` in your AppDelegate.

- You can also set your key and secret here if you do not wish to include it in all subsequent calls `JudoKit.setToken(token:, secret:)`.


### Examples

#### Token and Secret
The token and secret are accessible from your judoPay account [here](https://portal.judopay.com/Developer) after you have created an app, and you can either generate sandbox or live tokens. We recommend you to set this in your AppDelegate in the `didFinishLaunchingWithOptions` method.

```swift
let token = "a3xQdxP6iHdWg1zy"
let secret = "2094c2f5484ba42557917aad2b2c2d294a35dddadb93de3c35d6910e6c461bfb"

JudoKit.setToken(token, secret: secret)

```

For testing purposes, you should set the app into sandboxed mode by calling the function `sandboxed(value: Bool)` on `JudoKit`.

```swift
JudoKit.sandboxed(true)
```

When delivering your App to the App Store, make sure to remove the line.

#### Make a simple payment

```swift
JudoKit.payment(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "consumer reference"), completion: { (response, error) -> () in
    self.dismissViewControllerAnimated(true, completion: nil)
    if let error = error {
        // if the user cancelled, this error is passed
        if error == JudoError.UserDidCancel {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // handle error
        return // BAIL
    }
    if let resp = response, transactionData = resp.items.first {
    // handle successful transaction
    }
})
```

#### Make a simple pre-authorization

```swift
JudoKit.preAuth(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "consumer reference"), completion: { (response, error) -> () in
    self.dismissViewControllerAnimated(true, completion: nil)
    if let error = error {
        // if the user cancelled, this error is passed
        if error == JudoError.UserDidCancel {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // handle error
        return // BAIL
    }
    if let resp = response, transactionData = resp.items.first {
    // handle successful transaction
    }
})
```


#### Register a card

```swift
JudoKit.registerCard(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "payment reference"), completion: { (response, error) -> () in
    self.dismissViewControllerAnimated(true, completion: nil)
    if let error = error {
        // if the user cancelled, this error is passed
        if error == JudoError.UserDidCancel {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // handle error
        return // BAIL
    }
    if let resp = response, transactionData = resp.items.first {
    // handle successful transaction
    }
})
```

#### Make a repeat payment

```swift
if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
    JudoKit.tokenPayment(judoID, amount: Amount(30, currentCurrency), reference: Reference(consumerRef: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
        self.dismissViewControllerAnimated(true, completion: nil)
        if let error = error {
            // if the user cancelled, this error is passed
            if error == JudoError.UserDidCancel {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            // handle error
            return // BAIL
        }
        if let resp = response, transactionData = resp.items.first {
            // handle successful transaction
        }
    })
} else {
    // no card details available
}
```

#### Make a repeat pre-authorization

```swift
if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
    JudoKit.tokenPreAuth(judoID, amount: Amount(30, currentCurrency), reference: Reference(consumerRef: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
        self.dismissViewControllerAnimated(true, completion: nil)
        if let error = error {
            // if the user cancelled, this error is passed
            if error == JudoError.UserDidCancel {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            // handle error
            return // BAIL
        }
        if let resp = response, transactionData = resp.items.first {
            // handle successful transaction
        }
    })
} else {
    // no card details available
}
```

## Card acceptance configuration

judoKit is capable of detecting and accepting a huge array of Card Networks and Card lengths. Maestro as an example used to have cards with 19 digits while most cards have 16 digit card numbers. To be capable of using all kinds of cards, a `Card.Configuration` object defines a specific accepted card network and card length. This is used as shown below:

The default value for accepted networks are Visa and MasterCard cards with a length of 16 digits.

```swift
let defaultCardConfigurations = [Card.Configuration(.Visa, 16), Card.Configuration(.MasterCard, 16)]
```

In case you want to add the capability of accepting AMEX you need to add this as following:

```swift
JudoKit.acceptedCardNetworks = [Card.Configuration(.Visa, 16), Card.Configuration(.MasterCard, 16), Card.Configuration(.AMEX, 15)]
```

Any other card configuration that is available can be added for the UI to accept the card. **BE AWARE** you do need to configure your account with Judo Payments for any other Card Type payments to be processed successfully.

## Customizing payments page theme

![lighttheme1](http://judopay.github.io/JudoKit/ressources/lighttheme1.png "Light Theme Example Image")
![lighttheme2](http://judopay.github.io/JudoKit/ressources/lighttheme2.png "Light Theme Example Image")
![darktheme1](http://judopay.github.io/JudoKit/ressources/darktheme2.png "Dark Theme Example Image")

judoKit comes with our new customisable, stacked UI. Note that if you have implemented with our Objective-C repository, you will have to use this Swift framework in your Obj-C project to use the new customisable UI. To do this, replace the legacy 'judoPay' implementation in your app with the 'judoKit' implementation.

### Manual integration & Carthage

For manual integration and usage of Carthage, you need to create a fork of the existing judoKit repository on GitHub.

### CocoaPods

If you need to make changes to the Theme while using CocoaPods, you need to unlock the source code files from judoKit inside your Pods project. With these changes, make sure you track your CocoaPods inside your git (or other versioning system).

### Theme classes

To customize colors, have a look at the `UIColor+Judo.swift` file. To customize strings, have a look at the `JudoPayView.swift` file.

#### `UIColor+Judo.swift`

```
func judoDarkGrayColor()
func judoInputFieldTextColor()
func judoLightGrayColor()
func judoInputFieldBorderColor()
func judoContentViewBackgroundColor()
func judoButtonColor()
func judoButtonTitleColor()
func judoLoadingBackgroundColor()
func judoRedColor()
func judoLoadingBlockViewColor()
func judoInputFieldBackgroundColor()
```

#### `JudoPayView.swift`

```
// Buttons
let kPaymentButtonTitle = "Pay"
let kRegisterCardButtonTitle = "Add card"
let kRegisterCardNavBarButtonTitle = "Add"

let kBackButtonTitle = "Back"

// Titles
let kPaymentTitle = "Payment"
let kRegisterCardTitle = "Add card"
let kRefundTitle = "Refund"
let kAuthenticationTitle = "Authentication"

// Loading
let kLoadingIndicatorRegisterCardTitle = "Adding card..."
let kLoadingIndicatorProcessingTitle = "Processing payment..."
let kRedirecting3DSTitle = "Redirecting..."
let kVerifying3DSPaymentTitle = "Verifying payment"
let kVerifying3DSRegisterCardTitle = "Verifying card"

// InputFields
let inputFieldHeight: CGFloat = 48
```

