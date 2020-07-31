# LinkedinSwift

[![CocoaPods](https://img.shields.io/cocoapods/v/LinkedinSwift.svg)](https://github.com/tonyli508/LinkedinSwift.git)
[![Build Status](https://travis-ci.org/tonyli508/LinkedinSwift.svg?branch=master)](https://travis-ci.org/tonyli508/LinkedinSwift)
[![codebeat badge](https://codebeat.co/badges/ea9c29be-fbd1-4b51-87ba-3881b6b90641)](https://codebeat.co/projects/github-com-tonyli508-linkedinswift)
[![Gitter](https://badges.gitter.im/tonyli508/IOSLinkedInAPI.svg)](https://gitter.im/tonyli508/IOSLinkedInAPI?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


LinkedinSwift is a project for managing native LinkedIn SDK using [CocoaPods](https://cocoapods.org)

Linkedin Oauth Helper, depend on Linkedin Native App installed or not, using Linkdin IOS SDK or UIWebView to login

Latest version is based on [LinkedIn SDK 1.0.7](https://content.linkedin.com/content/dam/developer/sdk/iOS/li-ios-sdk-1.0.6-release.zip) and [IOSLinkedinAPI for webview auth](https://github.com/jeyben/IOSLinkedInAPI).

⚠️ Linkedin has turned down the support of The Mobile SDK [link](https://developer.linkedin.com/docs/ios-sdk), hopefully they will solve this soon. For now only use web login.

```swift
let linkedinHelper = LinkedinSwiftHelper(configuration: 
    LinkedinSwiftConfiguration(
        clientId: "77tn2ar7gq6lgv", 
        clientSecret: "iqkDGYpWdhf7WKzA", 
        state: "DLKDJF45DIWOERCM", 
        permissions: ["r_liteprofile", "r_emailaddress"]
    ),
    nativeAppChecker: WebLoginOnly()
)
```
Try the example app as well.

Be aware of their upcoming changes for permissions as well, starting from 1st March, 2019, they may only supprot r_liteprofile permission instead of r_basicprofile. [link](https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin?context=linkedin/consumer/context)

## How to use

```ruby
pod 'LinkedinSwift', '~> 1.8.0'
```

Check out Example project.

- Setup configuration and helper instance.
```swift
let linkedinHelper = LinkedinSwiftHelper(configuration: 
    LinkedinSwiftConfiguration(
        clientId: "77tn2ar7gq6lgv", 
        clientSecret: "iqkDGYpWdhf7WKzA", 
        state: "DLKDJF45DIWOERCM", 
        permissions: ["r_liteprofile", "r_emailaddress"]
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
:warning: for iOS 9 and above use this instead:
```swift
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Linkedin sdk handle redirect
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: nil, annotation: nil)
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
linkedinHelper.requestURL("https://api.linkedin.com/v2/me", 
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

<p align="left">
<img src="https://github.com/tonyli508/LinkedinSwift/blob/master/page_images/screenshot1.jpg" alt="Demo photo" width="280" height="500" />
</p>

## Known issues

-It seems Linkedin 1.0.7 messed up with `Bitcode support.` again. You need to turn off Bitcode to make it work.-
seems can turn on Bitcode now.

