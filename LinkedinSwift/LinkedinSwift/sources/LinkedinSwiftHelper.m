//
//  LinkedinSwiftHelper.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 17/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import "LinkedinSwiftHelper.h"

#import "LinkedinSwiftConfiguration.h"
#import "NativeAppInstalledChecker.h"
#import "LinkedinNativeClient.h"
#import "LinkedinOAuthWebClient.h"
#import <linkedin-sdk/LISDK.h>

@import UIKit;

@implementation LinkedinSwiftHelper
{
    LinkedinSwiftConfiguration *configuration;
    NativeAppInstalledChecker *checker;
    NSObject<LinkedinClient> *nativeClient;
    NSObject<LinkedinClient> *webClient;
}
@synthesize lsAccessToken;

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithConfiguration:(LinkedinSwiftConfiguration*)_configuration {
    return [self initWithConfiguration:_configuration nativeAppChecker:nil clients:nil webOAuthPresentViewController:nil persistedLSToken:nil];
}

- (_Nonnull instancetype)initWithConfiguration:(LinkedinSwiftConfiguration* _Nonnull)_configuration nativeAppChecker:(NativeAppInstalledChecker* _Nullable)_checker clients:(NSArray <id<LinkedinClient>>* _Nullable)clients webOAuthPresentViewController:(UIViewController* _Nullable)presentViewController persistedLSToken:(LSLinkedinToken* _Nullable)lsToken {
    
    if (self = [super init]) {
        if (_checker == nil) {
            checker = [NativeAppInstalledChecker new]; // create default NativeAppInstalledChecker if user not passing one 
        } else {
            checker = _checker;
        }
        if (lsToken != nil) {
            lsAccessToken = lsToken;
        }
        if (clients == nil) {
            nativeClient = [[LinkedinNativeClient alloc] initWithPermissions:_configuration.permissions];
            webClient = [[LinkedinOAuthWebClient alloc] initWithRedirectURL:_configuration.redirectUrl
                                                                   clientId:_configuration.clientId
                                                               clientSecret:_configuration.clientSecret
                                                                      state:_configuration.state
                                                                permissions:_configuration.permissions
                                                                    present:presentViewController];
        } else {
            // first is the native client, second is the web client
            nativeClient = [clients objectAtIndex:0];
            webClient = [clients objectAtIndex:1];
        }
        configuration = _configuration;
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Authorization

- (void)authorizeSuccess:(LinkedinSwiftAuthRequestSuccessCallback)successCallback error:(LinkedinSwiftRequestErrorCallback)errorCallback cancel:(LinkedinSwiftRequestCancelCallback)cancelCallback {
    
    /**
     *  If previous token still in memory callback directly
     */
    if (lsAccessToken != nil && [lsAccessToken.expireDate timeIntervalSinceNow] > 0) {
        successCallback(lsAccessToken);
    } else {
        
        __block LinkedinSwiftHelper *this = self;
        LinkedinSwiftAuthRequestSuccessCallback __successCallback = ^(LSLinkedinToken * _Nonnull token) {
            this->lsAccessToken = token;
            successCallback(this->lsAccessToken);
        };
        
        NSObject<LinkedinClient> *client = [checker isLinkedinAppInstalled] ? nativeClient : webClient;
        [client authorizeSuccess:__successCallback error:errorCallback cancel:cancelCallback];
    }
}

- (void)logout {
    lsAccessToken = nil;
    /// logout all sessions
    [nativeClient logout];
    [webClient logout];
}

#pragma mark -
#pragma mark Request

- (void)requestURL:(NSString*)url requestType:(LinkedinSwiftRequestType*)requestType success:(LinkedinSwiftRequestSuccessCallback)successCallback error:(LinkedinSwiftRequestErrorCallback)errorCallback {
    
    // Only can make request after logged in
    if (lsAccessToken != nil) {
        // for now only GET is needed :)
        if ([requestType isEqualToString:LinkedinSwiftRequestGet]) {
            NSObject<LinkedinClient> *client = lsAccessToken.isFromMobileSDK ? nativeClient : webClient;
            [client requestURL:url requestType:requestType token:lsAccessToken success:successCallback error:errorCallback];
        }
    }
}

#pragma mark -
#pragma mark Static functions

+ (BOOL)isLinkedinAppInstalled {
    return [[NativeAppInstalledChecker new] isLinkedinAppInstalled];
}

+ (BOOL)shouldHandleUrl:(NSURL *)url {
    
    return [self isLinkedinAppInstalled] && [LISDKCallbackHandler shouldHandleUrl:url];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [self isLinkedinAppInstalled] && [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
