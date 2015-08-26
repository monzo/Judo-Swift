# Change Log
All notable changes to this project will be documented in this file.
'Judo' adheres to [Semantic Versioning](http://semver.org/).

- `0.2.x` Releases - [0.2.0](#020) | [0.2.1](#021)
- `0.1.x` Releases - [0.1.0](#010) | [0.1.3](#013) | [0.1.5](#015) | [0.1.6](#016)

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