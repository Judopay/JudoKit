[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JudoKit.svg)](https://img.shields.io/cocoapods/v/JudoKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)
[![Build Status](https://travis-ci.org/JudoPay/JudoKit.svg)](http://travis-ci.org/JudoPay/JudoKit)

# judoKit iOS SDK

This is the official judo iOS SDK. It incorporates our mobile specific security toolkit, [judoShield](https://github.com/judopay/judoshield), with additional modules to enable easy native integration of payments. If you are writing your app in Objective-C, we highly recommend you to use the [judoKitObjC](https://github.com/judopay/JudoKitObjC) port.

##### **\*\*\*Due to industry-wide security updates, versions below 5.5.1 of this SDK will no longer be supported after 1st Oct 2016. For more information regarding these updates, please read our blog [here](http://hub.judopay.com/pci31-security-updates/).*****

### What is this project for?

judoKit is a framework for integrating easy, fast and secure payments inside your app with [judo](https://www.judopay.com/). It contains an exhaustive in-app payments and security toolkit that makes integration simple and quick.

## Integration

### Sign up to judo's platform

- To use judo's SDK, you'll need to [sign up](https://www.judopay.com/signup) and get your app token. 
- the SDK has to be integrated in your project using one of the following methods:

#### CocoaPods

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

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) - decentralized dependency management.

- You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

- To integrate judo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JudoPay/JudoKit" >= 6.1
```

- Execute the following command in your project folder. This should clone the project and build the judoKit scheme:

```bash
$ carthage bootstrap
```

- On your application targets’ 'General' settings tab, in the 'Embedded Binaries' section, drag and drop `JudoKit.framework` from the Carthage/Build folder and `JudoShield.framework` from the `Carthage/Checkouts` folder on disk.
- On your application targets’ 'Build Phases' settings tab, click the '+' icon and choose 'New Run Script Phase'. Create a Run Script with the following contents:

```sh
/usr/local/bin/carthage copy-frameworks
```

- And add the paths to the frameworks you want to use under 'Input Files', e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/JudoKit.framework
$(SRCROOT)/Carthage/Checkouts/JudoShield/Framework/JudoShield.framework
```

### Manual integration

- You can integrate judo into your project manually if you prefer not to use dependency management.

#### Adding the Framework

- Add judoKit as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, changing into your project directory, and entering the following command:

```bash
$ git submodule add https://github.com/JudoPay/JudoKit
```

- As judoKit has submodules, you need to initialize them as well by cd-ing into the `JudoKit` folder and executing the following command:

```bash
$ cd JudoKit
$ git submodule update --init --recursive
```
- Open your project and select your application in the Project Navigator (blue project icon).
- Drag and drop the `JudoKit.xcodeproj` project file inside the `JudoKit` folder into your project (just below the blue project icon inside Xcode).
- Navigate to the target configuration window and select the application target under the 'Targets' heading in the sidebar.
- In the tab bar at the top of that window, open the 'General' panel.
- Click on the '+' button in 'Embedded Binaries' section.
- Click on 'Add Other...' and navigate to the `JudoKit/JudoShield/Framework` Folder and add `JudoShield.Framework`.
- Click on the same '+' button and add `JudoKit.framework` under the judoKit project from the `Products` folder.
- In the project navigator, click on the '+' button under the 'Linked Frameworks and Libraries' section.
- Select `Security.framework`, `CoreTelephony.framework` and `CoreLocation.framework` from the list presented.
- Open the 'Build Settings' panel.
- Search for `Framework Search Paths` and add `$(PROJECT_DIR)/JudoKit/JudoShield/Framework`.
- Search for `Runpath Search Paths` and make sure it contains `@executable_path/Frameworks`.


### Further setup

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

### Examples

#### Token and Secret
- The token and secret are accessible from your judo dashboard [here](https://portal.judopay.com/Developer) after you have created an app, and you can either generate sandbox or live tokens.

```swift
let token = "a3xQdxP6iHdWg1zy"
let secret = "2094c2f5484ba42557917aad2b2c2d294a35dddadb93de3c35d6910e6c461bfb"

let myJudoKitSession = JudoKit(token: token, secret: secret)

```

- For testing purposes, you should set the app into sandboxed mode by calling the function `sandboxed(value: Bool)` on `JudoKit`:

```swift
myJudoKitSession.sandboxed(true)
```

- When you are ready to submit your app to the App Store, make sure to remove this line.

#### Make a simple Payment

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

#### Make a simple Pre-authorization

```swift
myJudoKitSession.invokePreAuth(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "consumer reference"), completion: { (response, error) -> () in
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
myJudoKitSession.invokeRegisterCard(judoID, amount: Amount(42, currentCurrency), reference: Reference(consumerRef: "payment reference"), completion: { (response, error) -> () in
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

#### Make a repeat Payment

```swift
if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
    myJudoKitSession.invokeTokenPayment(judoID, amount: Amount(30, currentCurrency), reference: Reference(consumerRef: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
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

#### Make a repeat Pre-authorization

```swift
if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
    myJudoKitSession.invokeTokenPreAuth(judoID, amount: Amount(30, currentCurrency), reference: Reference(consumerRef: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
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

judoKit is capable of detecting and accepting a huge array of Card Networks and Card lengths. Maestro, for example, used to have cards with 19 digits, while most major Card Networks have 16 digit card numbers. To be capable of accepting all major Card Networks, a `Card.Configuration` object defines a specific accepted Card Network and Card Length. This is used as shown below.

- The default value for accepted networks are Visa and MasterCard with a length of 16 digits:

```swift
let defaultCardConfigurations = [Card.Configuration(.Visa, 16), Card.Configuration(.MasterCard, 16)]
```

- In case you want to add the capability of accepting AMEX you need to add the following:

```swift
judoKitSession.theme.acceptedCardNetworks = [Card.Configuration(.Visa, 16), Card.Configuration(.MasterCard, 16), Card.Configuration(.AMEX, 15)]
```

- Any other card configuration that is available can be added for the UI to accept the specific Card Network. **BE AWARE** you do need to configure your account with judo for any other Card Network transactions to be processed successfully.

## Customizing payment page theme

![lighttheme1](http://judopay.github.io/JudoKit/ressources/lighttheme1.png "Light Theme Example Image")
![lighttheme2](http://judopay.github.io/JudoKit/ressources/lighttheme2.png "Light Theme Example Image")
![darktheme1](http://judopay.github.io/JudoKit/ressources/darktheme2.png "Dark Theme Example Image")

judoKit comes with our new customizable, stacked UI. Note that if you have implemented with our Objective-C repository, you will have to use this Swift framework in your Objective-C project to use the new customizable UI. To do this, replace the legacy 'judoPay' implementation in your app with the 'judoKit' implementation.

### Theme class

- The following parameters can be accessed through `JudoKit.theme`.

#### General configuration

```swift
/// A tint color that is used to generate a theme for the judo payment form
public var tintColor: UIColor = UIColor(red: 30/255, green: 120/255, blue: 160/255, alpha: 1.0)

/// Set the address verification service to true to prompt the user to input his country and post code information
public var avsEnabled: Bool = false

/// a boolean indicating whether a security message should be shown below the input
public var showSecurityMessage: Bool = false

/// An array of accepted card configurations (card network and card number length)
public var acceptedCardNetworks: [Card.Configuration] = [Card.Configuration(.AMEX, 15), Card.Configuration(.Visa, 16), Card.Configuration(.MasterCard, 16), Card.Configuration(.Maestro, 16)]

```

#### Button titles

```swift 

/// the title for the payment button
public var paymentButtonTitle = "Pay"
/// the title for the button when registering a card
public var registerCardButtonTitle = "Add card"
/// the title for the back button of the navigation controller
public var registerCardNavBarButtonTitle = "Add"
/// the title for the back button
public var backButtonTitle = "Back"

```

#### Page titles

```swift

/// the title for a payment
public var paymentTitle = "Payment"
/// the title for a card registration
public var registerCardTitle = "Add card"
/// the title for a refund
public var refundTitle = "Refund"
/// the title for an authentication
public var authenticationTitle = "Authentication"

```

#### Loading titles

```swift

/// when a register card transaction is currently running
public var loadingIndicatorRegisterCardTitle = "Adding card..."
/// the title of the loading indicator during a transaction
public var loadingIndicatorProcessingTitle = "Processing payment..."
/// the title of the loading indicator during a redirect to a 3DS webview
public var redirecting3DSTitle = "Redirecting..."
/// the title of the loading indicator during the verification of the transaction
public var verifying3DSPaymentTitle = "Verifying payment"
/// the title of the loading indicator during the verification of the card registration
public var verifying3DSRegisterCardTitle = "Verifying card"

```

#### Input field configuration

```swift

/// the height of the input fields
public var inputFieldHeight: CGFloat = 48

```

#### Security message

```swift

/// the message that is shown below the input fields the ensure safety when entering card information
public var securityMessageString = "Your card details are encrypted using SSL before transmission to our secure payment service provider. They will not be stored on this device or on our servers."

/// the text size of the security message
public var securityMessageTextSize: CGFloat = 12

```

#### Colors

```swift
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

