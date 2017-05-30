[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JudoKit.svg)](https://img.shields.io/cocoapods/v/JudoKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Platform](https://img.shields.io/cocoapods/p/JudoKit.svg)](http://http://cocoadocs.org/docsets/Judo)
[![Twitter](https://img.shields.io/badge/twitter-@JudoPayments-orange.svg)](http://twitter.com/JudoPayments)

# Judo Swift SDK for iOS

The judo Swift SDK is a framework for integrating easy, fast and secure payments inside your app with [judo](https://www.judopay.com/). It contains an exhaustive in-app payments and security toolkit that makes integration simple and quick. If you are integrating your app in Objective-C, we highly recommend you to use the [judoKitObjC](https://github.com/judopay/JudoKitObjC) port.

Use our UI components for a seamless user experience for card data capture. Minimise your [PCI scope](https://www.pcisecuritystandards.org/pci_security/completing_self_assessment) with a UI that can be themed or customised to match the look and feel of your app.

##### **\*\*\*Due to industry-wide security updates, versions below 5.5.1 of this SDK will no longer be supported after 1st Oct 2016. For more information regarding these updates, please read our blog [here](http://hub.judopay.com/pci31-security-updates/).*****

## Requirements

Versions >= 6.2.5 require Xcode 8 and Swift 3. Version 6.2.4 is the last version to support Xcode 7.3.1 and Swift 2.2.

## Getting started

#### 1. Integration

Add `import JudoKit` to the top of the file where you want to use the SDK.

If you are integrating using Cocoapods, follow the steps below (if your integration is based on Carthage, then visit https://github.com/JudoPay/JudoKit/wiki/Carthage. If you are integrating the SDK manually then follow the guide here https://github.com/JudoPay/JudoKit/wiki/Manual-integration):

- You can install CocoaPods with the following command:

```bash
$ gem install cocoapods
```

- Add judo to your `Podfile` to integrate it into your Xcode project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'JudoKit', '~> 6.2'
```

- Then run the following command:

```bash
$ pod install
```

- Please make sure to always **use the newly generated `.xcworkspace`** file not not the projects `.xcodeproj` file.

- In your Xcode environment, go to your `Project Navigator` (blue project icon) called `Pods`, select the `JudoKit` target and open the tab called `Build Phases`.
- Add a new `Run Script Phase` and drag it above the `Compile Sources` build phase.
- In the shell script, paste the following line:

```bash
sh "${PODS_ROOT}/DeviceDNA/Framework/strip-frameworks-cocoapods.sh"
```

#### 2. Setup

You can set your token and secret here when initializing the session:

```swift
// initialize the SDK by setting it up with a token and a secret
var judoKit = JudoKit(token: "<TOKEN>", secret: "<SECRET>")
```

To instruct the SDK to communicate with the Sandbox, include the following lines in the ViewController where the payment should be initiated:

```swift
// setting the SDK to Sandbox Mode - once this is set, the SDK wil stay in Sandbox mode until the process is killed
self.judoKit.sandboxed(true)
```

When you are ready to go live you can remove this line.

#### 3. Make a payment

```swift
func paymentOperation() {
    guard let ref = Reference(consumerRef: "<CONSUMER_REFERENCE>") else { return }
    try! self.judoKit.invokePayment(judoId, amount: Amount(decimalNumber: 0.01, currency: currentCurrency), reference: ref, completion: { (response, error) -> () in
        self.dismiss(animated: true, completion: nil)
            
        if let error = error {
            if error.code == .userDidCancel {
                self.dismiss(animated: true, completion: nil)
                return
            }
                
            var errorTitle = "Error"
            if let errorCategory = error.category {
                errorTitle = errorCategory.stringValue()
            }
                
            self.alertController = UIAlertController(title: errorTitle, message: error.message, preferredStyle: .alert)
            self.alertController!.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.dismiss(animated: true, completion:nil)
                
            return // BAIL
        }
            
        if let resp = response, let receipt = resp.items.first {
            self.cardDetails = receipt.cardDetails
            self.paymentToken = receipt.paymentToken()
        }
            
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: "detailviewcontroller") as! DetailViewController
            
        viewController.response = response
        self.navigationController?.pushViewController(viewController, animated: true)
    })
}
```
**Note:** Please make sure that you are using a unique Consumer Reference for each different consumer.

## Next steps

Judo's Swift SDK supports a range of customization options. For more information on using judo for iOS see our [wiki documentation](https://github.com/JudoPay/JudoKit/wiki/) or [API reference](https://judopay.github.io/JudoKit).
