# Change Log
All notable changes to this project will be documented in this file.
'Judo' adheres to [Semantic Versioning](http://semver.org/).

- `1.3.x` Releases - [1.3.0](#130)
- `1.2.x` Releases - [1.2.0](#120) | [1.2.1](#110)
- `1.1.x` Releases - [1.1.0](#110)
- `1.0.x` Releases - [1.0.0](#100)
- `0.2.x` Releases - [0.2.0](#020) | [0.2.1](#021)
- `0.1.x` Releases - [0.1.0](#010) | [0.1.3](#013) | [0.1.5](#015) | [0.1.6](#016)

## [1.3.0](https://github.com/JudoPay/Judo-Swift/tag/1.3.0)
Planned Release Date 2015-11-05

#### Added
- check for Jailbroken device
- boolean that can be set to ignore or restrict transactions from Jailbroken devices
- cv2 in PaymentToken struct for repeat payments

#### Removed
- unecessary variable for allowed card networks in Judo

#### Changed
- Error Handling revisited, enhanced and prepared for upcoming backend release

#### Fixed
- User-Agent Header would always send Judo Version instead of JudoKit version if that was used
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.2.1](https://github.com/JudoPay/Judo-Swift/tag/1.2.1)
Released on 2015-10-20

#### Fixed
- fixed a bug where ApplePay would not be processed
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.2.0](https://github.com/JudoPay/Judo-Swift/tag/1.2.0)
Released on 2015-09-29

#### Added
- Added Judo-Swift-ApplePay
- Travis yaml and configured shared scheme for CI integration
- session tests to mock restapi and test without actual connection

#### Updated
- Amount can only be initialized when an amount and a currency string is passed
- simplified implementation
- Post Code titles for different countries
- security code title defaults changed to be more descriptive and understandable

#### Fixed
- Tests
  - Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.1.0](https://github.com/JudoPay/Judo-Swift/tag/1.1.0)
Released on 2015-09-18

#### Updated
- simplified implementation
- updated documentation
- added more ways to initialize a Card Object
- minimized lines of code in a few methods
- created custom initializes instead of static methods

#### Fixed
- a few typo fixes
- Tests
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [1.0.0](https://github.com/JudoPay/Judo-Swift/tag/1.0.0)
Released on 2015-09-15

#### Added
- title function to card for security code
- method that returns length of security code
- method that generates payment token from response
- country to card address detail info
- Maestro Fields and AVS
- card registration as a seperate class and endpoint
- 3DS Transaction Detection
- ability to send deviceSignal to backend for fraud prevention
- Error TransactionResult
- comments
- Errors

#### Fixed
- card security code title
- placeholder method to cardconfig
- directing execution back on to main thread when it did not

#### Removed
- unneccessary code
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.2.1](https://github.com/JudoPay/Judo-Swift/tag/0.2.1)
Released on 2015-08-26

#### Updated
- new endpoints that conform to iOS9 ATS ([further info here](https://developer.apple.com/library/prerelease/mac/technotes/App-Transport-Security-Technote/index.html))
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.2.0](https://github.com/JudoPay/Judo-Swift/tag/0.2.0)
Released on 2015-08-24

#### Added
- adding default values overloading for optional parameters
- adding missing card networks
- added card specific errors
- added missing constants
- added string representation method to Card enum
- adding cardnetwork constraints
	- Added by [Hamon Ben Riazy](https://github.com/ryce).

#### Updated
- setting deployment target
- using NSDecimalNumber instead of Double for currency precision
- moved card configuration to Judo Base Module
- moving functions to base SDK
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.6](https://github.com/JudoPay/Judo-Swift/tag/0.1.6)
- fixing tests - added PreAuth TransactionType and path correction
- modifying accessors for module subclass access
- created public initializers
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.5](https://github.com/JudoPay/Judo-Swift/tag/0.1.5)
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
- fixed podspec and cocoapod issues
	- Updated by [Hamon Ben Riazy](https://github.com/ryce).

---
## [0.1.0](https://bitbucket.org/judo/judo-swift/commits/tag/0.1.0)
Released on 2015-07-30.

#### Added
- Initial release of Judo-swift.
  - Added by [Hamon Ben Riazy](https://github.com/ryce).