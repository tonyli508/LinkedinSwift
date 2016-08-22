//
//  LinkedinSwiftHelper.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 17/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSLinkedinToken.h"
#import "LSResponse.h"

#import <UIKit/UIKit.h>

/**
 *  LinkedinSwiftRequestSuccessCallback
 *
 *  @param response LSResponse
 */
typedef void(^LinkedinSwiftRequestSuccessCallback)(LSResponse * _Nonnull response);
/**
 *  LinkedinSwiftAuthRequestSuccessCallback
 *
 *  @param token LSLinkedinToken
 */
typedef void(^LinkedinSwiftAuthRequestSuccessCallback)(LSLinkedinToken * _Nonnull token);
/**
 *  LinkedinSwiftRequestErrorCallback
 *
 *  @param error NSError
 */
typedef void(^LinkedinSwiftRequestErrorCallback)(NSError * _Nonnull error);
/**
 *  LinkedinSwiftRequestCancelCallback
 */
typedef void(^LinkedinSwiftRequestCancelCallback)(void);

typedef NSString LinkedinSwiftRequestType;
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestGet = @"GET";
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestPOST = @"POST";
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestPUT = @"PUT";
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestDELETE = @"DELETE";

@class LSLinkedinToken, LinkedinSwiftConfiguration;
/**
 *  LinkedinSwiftHelper
 */
@interface LinkedinSwiftHelper : NSObject {
    
}

/**
 *  Cached access token if logged in
 */
@property (nonatomic, strong, readonly) LSLinkedinToken * _Nullable lsAccessToken;

/**
 *  Init with configuration
 *
 *  @param configuration  LinkedinSwiftConfiguration
 *
 *  @return LinkedinSwiftHelper
 */
- (_Nonnull instancetype)initWithConfiguration:(LinkedinSwiftConfiguration* _Nonnull)configuration;

/**
 *  Init with configuration and web oauth present view controller which oauth-based webview will present in
 *
 *  @param _configuration         LinkedinSwiftConfiguration
 *  @param presentViewController  web oauth present view controller which oauth-based webview will present in
 *
 *  @return LinkedinSwiftHelper
 */
- (_Nonnull instancetype)initWithConfiguration:(LinkedinSwiftConfiguration* _Nonnull)_configuration webOAuthPresentViewController:(UIViewController* _Nullable)presentViewController;

/**
 *  Check if Linkedin app is installed
 *
 *  @return Bool
 */
+ (BOOL)isLinkedinAppInstalled;

/**
 *  Login with Linkedin to get accessToken
 *
 *  @param success  callback
 *  @param error    callback
 *  @param cancel   callback
 */
- (void)authorizeSuccess:(__nullable LinkedinSwiftAuthRequestSuccessCallback)success error:(__nullable LinkedinSwiftRequestErrorCallback)error cancel:(__nullable LinkedinSwiftRequestCancelCallback)cancel;
/**
 *  Request Linkedin api
 *
 *  @param url         api url
 *  @param requestType requst type, for now only support GET
 *  @param success     callback
 *  @param error       callback
 */
- (void)requestURL:(NSString* _Nonnull)url requestType:(LinkedinSwiftRequestType* _Nonnull)requestType success:(__nullable LinkedinSwiftRequestSuccessCallback)success error:(__nullable LinkedinSwiftRequestErrorCallback)error;

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate to check if the callback can be handled by LinkedIn SDK.
 */
+ (BOOL)shouldHandleUrl:(NSURL* _Nullable)url;
/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate in order to properly handle the callbacks. This must be called only if shouldHandleUrl: returns YES.
 */
+ (BOOL)application:(UIApplication* _Nonnull)application openURL:(NSURL* _Nullable)url sourceApplication:(NSString* _Nullable)sourceApplication annotation:(id _Nullable)annotation;


@end
