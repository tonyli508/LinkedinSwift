//
//  ViewController.swift
//  Example
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

import UIKit
import LinkedinSwift // Just import the module, I import the framework for example, you just do `pod 'LinkedinSwift', '= 0.9'`


class ViewController: UIViewController {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    // You still need to set appId and URLScheme in Info.plist, follow this instruction: https://developer.linkedin.com/docs/ios-sdk
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF45sd6ikMMZI", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        consoleTextView.layer.cornerRadius = 10.0
        consoleTextView.layer.borderColor = UIColor.orangeColor().CGColor
        consoleTextView.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Login with Linkedin
     */
    @IBAction func login() {
        
        /**
        *  Yeah, Just this simple, try with Linkedin installed and without installed
        *
        *   Check installed if you want to do different UI: linkedinHelper.isLinkedinAppInstalled()
        *   Access token later after login: linkedinHelper.lsAccessToken
        */
        
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            
            self.writeConsoleLine("Login success lsToken: \(lsToken)")
        }, error: { [unowned self] (error) -> Void in
            
            self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        }, cancel: { [unowned self] () -> Void in
            
            self.writeConsoleLine("User Cancelled!")
        })
    }
    
    /**
     Request profile for your just logged in account
     */
    @IBAction func requestProfile() {
        
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
            
            self.writeConsoleLine("Request success with response: \(response)")
            
        }) { [unowned self] (error) -> Void in
                
            self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
        }
    }
    
    private func writeConsoleLine(log: String, funcName: String = __FUNCTION__) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.consoleTextView.insertText("\n")
            self.consoleTextView.insertText("-----------\(funcName) start:-------------")
            self.consoleTextView.insertText("\n")
            self.consoleTextView.insertText(log)
            self.consoleTextView.insertText("\n")
            self.consoleTextView.insertText("-----------\(funcName) end.----------------")
            self.consoleTextView.insertText("\n")
            
            let rect = CGRect(x: self.consoleTextView.contentOffset.x, y: self.consoleTextView.contentOffset.y, width: self.consoleTextView.contentSize.width, height: self.consoleTextView.contentSize.height)
            
            self.consoleTextView.scrollRectToVisible(rect, animated: true)
        }
    }
}

