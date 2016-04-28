[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JudoKit.svg)](https://img.shields.io/cocoapods/v/JudoKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)
[![Build Status](https://travis-ci.org/JudoPay/JudoKit.svg)](http://travis-ci.org/JudoPay/JudoKit)

# judoKit Swift iOS SDK

This is the official judoKit iOS SDK written in Swift. It incorporates our mobile specific security toolkit, [judoShield](https://github.com/judopay/judoshield), with additional modules to enable easy native integration of payments. If you are integrating your app in Objective-C, we highly recommend you to use the [judoKitObjC](https://github.com/judopay/JudoKitObjC) port.

Use our UI components for a seamless user experience for card data capture. Minimise your [PCI scope](https://www.pcisecuritystandards.org/pci_security/completing_self_assessment) with a UI that can be themed or customised to match the look and feel of your app.

##### **\*\*\*Due to industry-wide security updates, versions below 5.5.1 of this SDK will no longer be supported after 1st Oct 2016. For more information regarding these updates, please read our blog [here](http://hub.judopay.com/pci31-security-updates/).*****

### What is this project for?

judoKit is a framework for integrating easy, fast and secure payments inside your app with [judo](https://www.judopay.com/). It contains an exhaustive in-app payments and security toolkit that makes integration simple and quick.

## Requirements

This SDK requires Xcode 7.3 and Swift 2.2.

## Getting started

### Integrating CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

- You can install it with the following command:

```bash
$ gem install cocoapods
```

- Add judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JudoKit', '~> 6.1'
```

- Then run the following command:

```bash
$ pod install
```

- Please make sure to always **use the newly generated `.xcworkspace`** file not not the projects `.xcodeproj` file.

### Initial setup

- Add `import JudoKit` to the top of the file where you want to use the SDK.

- You can set your key and secret here when initializing the session:

```swift
// initialize the SDK by setting it up with a token and a secret
var judoKitSession = JudoKit(token: token, secret: secret)
```

- To instruct the SDK to communicate with the Sandbox, include the following lines in the ViewController where the payment should be initiated:

```swift
// setting the SDK to Sandbox Mode - once this is set, the SDK wil stay in Sandbox mode until the process is killed
self.judoKitSession.sandboxed(true)
```

- When you are ready to go live you can remove this line.

### Invoking a payment screen

```swift
myJudoKitSession.invokePayment(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "consumer reference"), completion: { (response, error) -> () in
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

## Next steps

JudoKit supports a range of customization options. For more information on using judo for iOS see our [wiki documentation](https://github.com/JudoPay/JudoKit/wiki/).