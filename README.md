# SafeURL

[![CI Status](http://img.shields.io/travis/anjlab/SafeURL.svg?style=flat)](https://travis-ci.org/anjlab/SafeURL)
[![Version](https://img.shields.io/cocoapods/v/SafeURL.svg?style=flat)](http://cocoapods.org/pods/SafeURL)
[![License](https://img.shields.io/cocoapods/l/SafeURL.svg?style=flat)](http://cocoapods.org/pods/SafeURL)
[![Platform](https://img.shields.io/cocoapods/p/SafeURL.svg?style=flat)](http://cocoapods.org/pods/SafeURL)

## Usage

```swift
let baseURL = NSURL(string: "https://google.com")!

baseURL.build(query: ["q": "Safe URL"]) // #> NSURL "https://google.com?q=Safe%20URL"
```

## Requirements

- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3
- Swift 2.2

## Installation

SafeURL is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SafeURL"
```

## Author

Yury Korolev, yury.korolev@gmail.com

## License

SafeURL is available under the MIT license. See the LICENSE file for more info.
