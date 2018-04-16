# LinkedinSwift

[![CocoaPods](https://img.shields.io/cocoapods/v/LinkedinSwift.svg)](https://github.com/tonyli508/LinkedinSwift.git)
[![Build Status](https://travis-ci.org/tonyli508/LinkedinSwift.svg?branch=master)](https://travis-ci.org/tonyli508/LinkedinSwift)
[![codebeat badge](https://codebeat.co/badges/ea9c29be-fbd1-4b51-87ba-3881b6b90641)](https://codebeat.co/projects/github-com-tonyli508-linkedinswift)
[![Gitter](https://badges.gitter.im/tonyli508/IOSLinkedInAPI.svg)](https://gitter.im/tonyli508/IOSLinkedInAPI?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


LinkedinSwift is a project for managing native LinkedIn SDK using [CocoaPods](https://cocoapods.org)

Linkedin Oauth Helper, depend on Linkedin Native App installed or not, using Linkdin IOS SDK or UIWebView to login, support Swift with iOS 7

Latest version is based on [LinkedIn SDK 1.0.7](https://content.linkedin.com/content/dam/developer/sdk/iOS/li-ios-sdk-1.0.6-release.zip) and [IOSLinkedinAPI for webview auth](https://github.com/jeyben/IOSLinkedInAPI).

## How to use

```ruby
pod 'LinkedinSwift', '~> 1.7.7'
```

Check out Example project.

- Setup configuration and helper instance.
```swift
let linkedinHelper = LinkedinSwiftHelper(configuration: 
    LinkedinSwiftConfiguration(
        clientId: "77tn2ar7gq6lgv", 
        clientSecret: "iqkDGYpWdhf7WKzA", 
        state: "DLKDJF45DIWOERCM", 
        permissions: ["r_basicprofile", "r_emailaddress"]
    )
)
```
Or if you want to present in a different ViewController, using:
```swift
let linkedinHelper = LinkedinSwiftHelper(
    configuration: LinkedinSwiftConfiguration(
        clientId: "77tn2ar7gq6lgv", 
        clientSecret: "iqkDGYpWdhf7WKzA", 
        state: "DLKDJF45DIWOERCM", 
        permissions: ["r_basicprofile", "r_emailaddress"]
    ), webOAuthPresent: yourViewController
)
```
- Setup Linkedin SDK settings: [instruction here](https://developer.linkedin.com/docs/ios-sdk)
- Setup redirect handler in AppDelegate
```swift
func application(application: UIApplication, 
        openURL url: NSURL, 
        sourceApplication: String?, 
        annotation: AnyObject) -> Bool {

    // Linkedin sdk handle redirect
    if LinkedinSwiftHelper.shouldHandleUrl(url) {
        return LinkedinSwiftHelper.application(application, 
                openURL: url, 
                sourceApplication: sourceApplication, 
                annotation: annotation
        )
    }
    
    return false
}
```
- Login:
```swift
linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
    //Login success lsToken
}, error: { (error) -> Void in
    //Encounter error: error.localizedDescription
}, cancel: { () -> Void in
    //User Cancelled!
})
```
- Fetch profile:
```swift
linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json", 
    requestType: LinkedinSwiftRequestGet, 
    success: { (response) -> Void in
    
    //Request success response
    
}) { [unowned self] (error) -> Void in
        
    //Encounter error
}
```
- Logout:
```swift
linkedinHelper.logout()
```

Example project screenshots:

<p align="center">
<img src="https://github.com/tonyli508/LinkedinSwift/blob/master/page_images/screenshot1.jpg" alt="Demo photo" width="56" height="100" />
</p>

## Known issues

It seems Linkedin 1.0.7 messed up with `Bitcode support.` again. You need to turn off Bitcode to make it work.

