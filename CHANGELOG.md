# Change Log
All notable changes to this project will be documented in this file.
'Judo' adheres to [Semantic Versioning](http://semver.org/).

- `2.0.x` Releases - [2.0.0](#200)
- `1.6.x` Releases - [1.6.0](#160)
- `1.5.x` Releases - [1.5.0](#150) | [1.5.1](#151) | [1.5.2](#152)
- `1.4.x` Releases - [1.4.0](#140)
- `1.3.x` Releases - [1.3.0](#130)
- `1.2.x` Releases - [1.2.0](#120) | [1.2.1](#110)
- `1.1.x` Releases - [1.1.0](#110)
- `1.0.x` Releases - [1.0.0](#100)
- `0.2.x` Releases - [0.2.0](#020) | [0.2.1](#021)
- `0.1.x` Releases - [0.1.0](#010) | [0.1.3](#013) | [0.1.5](#015) | [0.1.6](#016)

## [2.0.0](https://github.com/JudoPay/Judo-Swift/releases/tag/2.0.0)
Released on 2016-03-04

#### Added
- Brazilian Real static accessor in `Currency`.
- AmountMissingError for an error that can occur in very rare cases when a payment or pre-auth is created without providing an amount.
- InvalidPostCodeError for an error that can occur when an invalid post code has been entered.

#### Changed
- Removed static accessors in favor of creating a session var in each project.
- Date fields now have an error message.
- Tests now run directly using the sandbox API.
- Removed API mocks from package.
- All functions and properties in `Judo` are not `static` anymore.
- We moved the endpoint method from `Judo` and placed it into the `Session` class which makes more sense as an origin for this variable.
- A new init() method that initializes your judo session with a given token and secret.
- Session is now no longer static and globally accessible - a single session instance will be created inside the Judo instance and then passed on for further use.

```swift
let myJudoSession = Judo("your token", secret: "your secret")
```
- In light of creating the judo session, the method which checks if a device is jailbroken has been moved into the initializer. It throws an exception in case the code is executed on a jailbroken device. If you need to restrict usage from jailbroken devices, use the following method instead:

```swift
let myJudoSession = try Judo("your token", secret: "your secret", allowJailbrokenDevices: true)
```

You can expect that the only exception that is thrown is the `JailbrokenDeviceDisallowedError` so you could also do the following:

```swift
let myJudoSession = try? Judo("your token", secret: "your secret", allowJailbrokenDevices: true)
```

In this case, if the code was executed on a jailbroken device, the myJudoSession optional will be nil.

#### Removed
- Amount entry from register card.

	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.6.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.6.0)
internally Released

#### Added
- Ability to Void a preAuth

a function has been added to `Judo`
```swift
static public func voidTransaction(receiptID: String, amount: Amount, paymentReference: String) throws -> VoidTransaction
```

This creates a new class `VoidTransaction` which 

- A parameter for setting initialRecurringPayment
```swift
public private (set) var initialRecurringPayment: Bool = false
```
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.5.2](https://github.com/JudoPay/Judo-Swift/releases/tag/1.5.2)
Released on 2016-02-03

#### Added
- The response parser will now remove commas from any amount strings - this is due to an issue with the API returning british formatted monetary values
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.5.1](https://github.com/JudoPay/Judo-Swift/releases/tag/1.5.1)
Released on 2016-01-29

#### Added
- Card number information to CardDetails object
- Package file for future Swift package manager
- 100% documented
- Updated documentation and added a lot of new snippets
- Response class now conforms to SequenceType, CollectionType, GeneratorType and ArrayLiteralConvertible
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.5.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.5.0)
Released on 2016-01-14

#### Added
- Ability to initialize an error with a code and message
- Duplicate transaction prevention - payment reference will be uniquely checked against previous transactions to block any duplication of the same transaction
- Bridging NSError value for errors that are not conforming to the JudoErrorDomain
- SDK version as dedicated field in HTTP Header for REST API calls
- NSCoding protocol to CardDetails to enable persisting in NSUserDefaults

#### Changed
- Updated currency to allow only strongly typed currencies
- Error handling model to match our latest API Version 5
- Modified Reference object to generate a unique payment reference by default

#### Fixed
- An issue with the cardNetwork that was not decoded in the correct type (int)
- An issue where errors of the NSURLErrorDomain were not passed through properly
- Some typos in licensing headers
- A bug where the generation of the formatted last four digits of the credit card number would result to nil if the card network was unknown
- A bug where the field message was not returned from the API
- Minor issue where the payload has not been set when initializing the error object
- Error handling model mock json and fixed minor issue
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.4.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.4.0)
Released on 2015-11-26

#### Added
- Added RegisterCard as a TransactionType
- Full accessibility from Objective C projects
- Cardnetwork now is parsed from response
- Mirrored card network enum from backend
- InvalidOperation error
- New transaction function that takes a transactiontype
- More helper methods to Card

#### Changed
- converting structs to classes and enums conforming to int for objc compability
- exposed JudoErrorCodes enum to objc

#### Fixed
- Fixed a bug where an optional value was force unwrapped when empty
- Fixing slashes in user agent header
- Fixed a bug where creation of PaymentToken would fail
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.3.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.3.0)
Released on 2015-11-05

#### Added
- Check for jailbroken devices
- Boolean that can be set to ignore or restrict transactions from jailbroken devices
- CV2 in PaymentToken struct for repeat payments

#### Removed
- Unnecessary variable for allowed card networks in judo

#### Changed
- Error Handling revisited, enhanced and prepared for upcoming backend release

#### Fixed
- User-Agent Header would always send judo version instead of judoKit version if that was used
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.2.1](https://github.com/JudoPay/Judo-Swift/releases/tag/1.2.1)
Released on 2015-10-20

#### Fixed
- fixed a bug where Apple Pay would not be processed
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.2.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.2.0)
Released on 2015-09-29

#### Added
- Added Judo-Swift-ApplePay
- Travis yml and configured shared scheme for CI integration
- Session tests to mock REST API and test without actual connection

#### Updated
- Amount can only be initialized when an amount and a currency string is passed
- Simplified implementation
- Post code titles for different countries
- Security code title defaults changed to be more descriptive and understandable

#### Fixed
- Tests
  - Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.1.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.1.0)
Released on 2015-09-18

#### Updated
- Simplified implementation
- Updated documentation
- Added more ways to initialize a Card Object
- Minimized lines of code in a few methods
- Created custom initializes instead of static methods

#### Fixed
- A few typo fixes
- Tests
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.0.0](https://github.com/JudoPay/Judo-Swift/releases/tag/1.0.0)
Released on 2015-09-15

#### Added
- Title function to card for security code
- Method that returns length of security code
- Method that generates payment token from response
- Country to card address detail info
- Maestro fields and AVS
- Card registration as a seperate class and endpoint
- 3DS Transaction Detection
- Ability to send deviceSignal to backend for fraud prevention
- Error TransactionResult
- Comments
- Errors

#### Fixed
- Card security code title
- Placeholder method to cardconfig
- Directing execution back on to main thread when it did not

#### Removed
- Unneccessary code
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.2.1](https://github.com/JudoPay/Judo-Swift/releases/tag/0.2.1)
Released on 2015-08-26

#### Updated
- New endpoints that conform to iOS9 ATS ([further info here](https://developer.apple.com/library/prerelease/mac/technotes/App-Transport-Security-Technote/index.html))
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.2.0](https://github.com/JudoPay/Judo-Swift/releases/tag/0.2.0)
Released on 2015-08-24

#### Added
- Adding default values overloading for optional parameters
- Adding missing card networks
- Added card specific errors
- Added missing constants
- Added string representation method to Card enum
- Adding cardnetwork constraints
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

#### Updated
- Setting deployment target
- Using NSDecimalNumber instead of Double for currency precision
- Moved card configuration to judo Base Module
- Moving functions to base SDK
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.6](https://github.com/JudoPay/Judo-Swift/releases/tag/0.1.6)
- Fixing tests - added pre-auth TransactionType and path correction
- Modifying accessors for module subclass access
- Created public initializers
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.5](https://github.com/JudoPay/Judo-Swift/releases/tag/0.1.5)
Released on 2015-08-03

#### Added
- Types as responses instead of JSON Dictionaries
- Pagination for Array type responses
- Responses are detected as list or single items with pagination information if available
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.3](https://bitbucket.org/judo/judo-swift/commits/tag/0.1.3)
Released on 2015-07-30

#### Updated
- Fixed podspec and CocoaPod issues
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.0](https://bitbucket.org/judo/judo-swift/commits/tag/0.1.0)
Released on 2015-07-30.

#### Added
- Initial release of Judo-Swift.
  - Added by [Hamon Ben Riazy](https://github.com/ryce).
