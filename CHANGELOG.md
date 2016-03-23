# Change Log
All notable changes to this project will be documented in this file.
'JudoKit' adheres to [Semantic Versioning](http://semver.org/).

- `6.0.x` Releases - [6.0.0](#600) | [6.0.1](#601)
- `5.6.x` Releases - [5.6.0](#560)
- `5.5.x` Releases - [5.5.0](#550) | [5.5.1](#551) | [5.5.2](#552) | [5.5.3](#553) | [5.5.4](#554)
- `5.4.x` Releases - [5.4.0](#540)
- `5.3.x` Releases - [5.3.0](#530)
- `5.2.x` Releases - [5.2.0](#520) | [5.2.1](#521)
- `5.1.x` Releases - [5.1.0](#510) | [5.1.1](#511) | [5.1.2](#512)
- `5.0.x` Releases - [5.0.0](#500) | [5.0.1](#501)
- `4.x` Releases and below are related to the [JudoSDK](https://github.com/JudoPay/Judo-ObjC) 

## [6.0.1](https://github.com/JudoPay/JudoKit/releases/tag/6.0.1)
Released on 2016-03-30

#### Changed
- Falling back to a more secure method to detect a valid coordinate when making a transaction using the judo UI.
- Updated Selectors to conform to Swift 3.
- Simplified the security message position updating method.

#### Fixed
- Fixed the security code label for Amex cards (CID instead of CIDV).
- Fixed typos in the header documentation.

---
## [6.0.0](https://github.com/JudoPay/JudoKit/releases/tag/6.0.0)
Released on 2016-03-04

#### Added
- BRL is now a statically accessible from the Currency class.
- Theme object to make it easier to adjust colors, fonts and texts in the JudoKit Payment view.
- JudoPayViewController now needs a judo session to do all transactions.
- NSDate+Extension.swift for easier date handling.
- Hint label text for postcode input field.
- The SDK will now report back to the backend with information of whether a transaction is made with the out of the box UI.

#### Changed
- Removing all statically accessible methods and properties from JudoKit to favor creation of an instance that is taken care of by the project that is using JudoKit. This allows for cleaner usage of JudoKit in MVC environments.
- Hint text will only be shown when the field is completely empty after 5 seconds of being idle.
- Start and expiry dates now have a maximum/minimum allowed threshold of 10 years to the current date.
- Unified Postcode and billingcountry fields into one line instead of two.
- Fixed typos and wording on the fields errors and hints.
- Selecting 'other' when AVS is visible will immediately show the Pay button and without the necessity and ability to enter a post code.
- While making a repeat payment, the hint text for re-entering CV2 appears without delay

#### Fixed
- Example projects have been adjusted for new SDKs.
- Error text now properly behaves with the security text at the bottom of the input fields.
- Manipulating the card number and expiry date fields is now restricted for all token payments.
- Auto-advancing for Maestro cards when finished entering the card number.
- Wording when an incorrect card number is entered.
- An issue where adding '.' into the card number field would cause the app to crash.
- Wording on the hint text when a token payment is being made.
- The maestro input fields negative top and bottom constraints would lead to overlapping other fields.
- After the first correct entering of any input field fixed an unwanted animation.
- Removed an unused title label and fixed some issues around that.
- An issue where the security message would move down without any hint text shown.

---
## [5.6.0](https://github.com/JudoPay/JudoKit/releases/tag/5.6.0)
Released on 2016-02-18

#### Added
- Helper method to update the message position
```
public class JudoPayView: UIView {
...
func updateSecurityMessagePosition(toggleUp toggleUp: Bool)
...
}
```
- Helper method to identify whether a HintLabel instance is actively showing a text
```
public class HintLabel: UILabel {
...
public func isActive() -> Bool {
...
}
```

#### Fixed
- An issue with the security message not moving in sync with the hintlabel and errormessage appearing/disappearing

---
## [5.5.3](https://github.com/JudoPay/JudoKit/releases/tag/5.5.3)
Released on 2016-02-03

#### Added
- Security message option - new API to turn on or off a message that is shown to the user.

```
@objc public class JudoKit: NSObject {
...
    public static var showSecurityMessage: Bool = false
...
}
```

#### Changed
- Moved JudoPayInputDelegate extension to seperate file `JudoPayView+JudoPayInputDelegate`.

#### Updated
- Build configuration for JudoShield

---
## [5.5.2]()

#### NOT RELEASED DUE TO RELEASE ISSUE WITH COCOAPODS

---
## [5.5.1](https://github.com/JudoPay/JudoKit/releases/tag/5.5.1)
Released on 2016-01-29

#### Added
- Ability to pass a CardDetails object to prefill text fields when making a transaction
- Validation of card information when set from an external source
- Package file for future Swift package manager

#### Updated
- Secure Code Input Field hint label now shows a better description when doing a repeat (token) payment

#### Fixed
- Validation on every field at every entry

---
## [5.5.0](https://github.com/JudoPay/JudoKit/releases/tag/5.5.0)
Released on 2016-01-14

#### Added
- Hint label now shows errors in red color
- Modified acceptance of card networks to hard restrict networks and lengths that are not supported
- Version is now sent in the REST API Headers
- Duplicate transaction prevention - payment reference will be uniquely checked against previous transactions to block any duplication of the same transaction
- Validation methods for each input field

#### Updated
- SHA 256 SSL/TLS Certificate upgrade - an industry-wide security update to protect you against man-in-the-middle attacks
- Card input field will now let you enter the first incorrect number and stop you from entering anything after that
- Currency to allow only strongly typed currencies from a list
- Now accessing our latest API version 5
- New error handling model
- Spreading code to more files for better readability

#### Fixed
- Some issues where the card logo would not appear on repeat payments
- Some typos
- Expiry date was not correctly verified

---
## [5.4.0](https://github.com/JudoPay/JudoKit/releases/tag/5.4.0)
Released on 2015-11-26

#### Added
- UI Testing
- Added resolution label to sample app

#### Updated
- Integrated Judo-Swift as a standalone Project instead of it being a 'subproject' inside JudoKit
- Moved View related code into UIView subclass to make the JudoPayViewController lighter and easier to understand
- cardnetwork is now identified from backend response
- Error handling now exposed to objc - updated tests and sample code to match
- Adjusting Swift sample and JudoKit for full objc compability
- Using FormSheet layout style for the ViewController
- Updated card logo size to match new cell size
- Minor UI margin fix 
- Added RegisterCard to TransactionType
- Wording changes on objc sample
- Renamed 'dismiss' to 'close'

#### Fixed
- loading view was not presented correctly when 3DS redirection to webview was happening
- An issue where Frameworks were not properly integrated within the Example Apps
- Fixing an issue where 3DS would not work with HSBC due to the redirect url not being an actual http url


---
## [5.3.0](https://github.com/JudoPay/JudoKit/releases/tag/5.3.0)
Released on 2015-11-05

#### Added
- Ability to set side by side or animated floating atop titles
- Documentation in code and generated html
- Hint label that fades in when user is idle for 3 seconds
- tintColor that generates a theme for Judo Journey

#### Updated
- collected all constant strings in one place for easier title customisation
- payment snippet in readme
- more convenience inits instead of multiple designated inits in one class
- updated input field size and layout to fit 6+ sizes

#### Fixed
- margins for Card Information Input Fields

#### Changed
- updated Error Handling model and adjusted changes from Judo-Swift

#### Removed
- card number pattern detection logging onto the console
  - Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.2.1](https://github.com/JudoPay/JudoKit/releases/tag/5.2.1)
Released on 2015-10-20

#### Added
- ApplePay Example App

#### Changed
- big buttom payment button is not visible initially and pops up only when the payment is enabled
  - Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.2.0](https://github.com/JudoPay/JudoKit/releases/tag/5.2.0)
Released on 2015-10-01

#### Added
- ApplePay methods
- added static accessors
- different widths per inputView
- greyed out input for fields that have not been entered or activated
- red flash when entered wrong details

#### Changed
- Fixed Obj-C Sample App
- Fixed some bugs in the sample apps
- errorhandler now returns JudoErrors instead of NSErrors for easier handling in Swift
- Amount now only creates an object when an amount and a currency string has been passed
- switched to stacked view for AVS
- removed SharedInstance
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.1.2](https://github.com/JudoPay/JudoKit/releases/tag/5.1.2)
Released on 2015-09-22

#### Added
- ObjC sample app
- LaunchScreen for both sample apps
- App Icon for both sample apps

#### Changed
- renamed example app
- simplified protocols and input initialization
- moved error animation to view class
- created 3DS specific class for handling WebView
- created specific pay button
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.1.1](https://github.com/JudoPay/JudoKit/releases/tag/5.1.1)
Released on 2015-09-18

#### Changed
- version number bump in cocoapods podspec
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.1.0](https://github.com/JudoPay/JudoKit/releases/tag/5.1.0)
Released on 2015-09-18

#### Added 
- ObjC compability
- Documentation/Comments
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.0.1](https://github.com/JudoPay/JudoKit/releases/tag/5.0.1)
Released on 2015-09-15

#### Added
- new podspec
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.0.0](https://github.com/JudoPay/JudoKit/releases/tag/5.0.0)
Released on 2015-09-15

#### Added
- Initial Release
	- Added by [Hamon Ben Riazy](https://github.com/ryce).
