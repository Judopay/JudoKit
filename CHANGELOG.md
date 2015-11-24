# Change Log
All notable changes to this project will be documented in this file.
'JudoKit' adheres to [Semantic Versioning](http://semver.org/).

- `5.4.x` Releases - [5.4.0](#540)
- `5.3.x` Releases - [5.3.0](#530)
- `5.2.x` Releases - [5.2.0](#520) | [5.2.1](#521)
- `5.1.x` Releases - [5.1.0](#510) | [5.1.1](#511) | [5.1.2](#512)
- `5.0.x` Releases - [5.0.0](#500) | [5.0.1](#501)
- `4.x` Releases and below are related to the [JudoSDK](https://github.com/JudoPay/Judo-ObjC) 

## [5.4.0](https://github.com/JudoPay/JudoKit/tag/5.4.0)
Released on 2015-11-26

#### Added
- UI Testing
- added resolution label to sample app
#### Updated
- Integrated Judo-Swift as a standalone Project instead of it being a 'subproject' inside JudoKit
- moved View related code into UIView subclass to make the JudoPayViewController lighter and easier to understand
- cardnetwork is now identified from backend response
- error handling now exposed to objc - updated tests and sample code to match
- adjusting swift sample and JudoKit for full objc compability
- using FormSheet layout style for the ViewController
- updated card logo size to match new cell size
- minor UI margin fix 
- added RegisterCard to TransactionType
- wording changes on objc sample
- renamed 'dismiss' to 'close'
#### Fixed
- loading view was not presented correctly when 3DS redirection to webview was happening
- an issue where Frameworks were not properly integrated within the Example Apps
- fixing an issue where 3DS would not work with HSBC due to the redirect url not being an actual http url
#### Removed


---
## [5.3.0](https://github.com/JudoPay/JudoKit/tag/5.3.0)
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
## [5.2.1](https://github.com/JudoPay/JudoKit/tag/5.2.1)
Released on 2015-10-20

#### Added
- ApplePay Example App

#### Changed
- big buttom payment button is not visible initially and pops up only when the payment is enabled
  - Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.2.0](https://github.com/JudoPay/JudoKit/tag/5.2.0)
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
## [5.1.2](https://github.com/JudoPay/JudoKit/tag/5.1.2)
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
## [5.1.1](https://github.com/JudoPay/JudoKit/tag/5.1.1)
Released on 2015-09-18

#### Changed
- version number bump in cocoapods podspec
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.1.0](https://github.com/JudoPay/JudoKit/tag/5.1.0)
Released on 2015-09-18

#### Added 
- ObjC compability
- Documentation/Comments
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.0.1](https://github.com/JudoPay/JudoKit/tag/5.0.1)
Released on 2015-09-15

#### Added
- new podspec
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

---
## [5.0.0](https://github.com/JudoPay/JudoKit/tag/5.0.0)
Released on 2015-09-15

#### Added
- Initial Release
	- Added by [Hamon Ben Riazy](https://github.com/ryce).
