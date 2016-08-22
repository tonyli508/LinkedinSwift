//
//  LinkedinSwiftHelper.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 17/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import "LinkedinSwiftHelper.h"

#import "LinkedinSwiftConfiguration.h"
#import <IOSLinkedInAPIFix/LIALinkedInApplication.h>
#import <IOSLinkedInAPIFix/LIALinkedInHttpClient.h>
#import <linkedin-sdk/LISDK.h>

@import UIKit;

@implementation LinkedinSwiftHelper
{
    LinkedinSwiftConfiguration *configuration;
    LIALinkedInHttpClient *httpClient;
}
@synthesize lsAccessToken;

#pragma mark -
#pragma mark Initialization

- (instancetype)initWithConfiguration:(LinkedinSwiftConfiguration*)_configuration {
    return [self initWithConfiguration:_configuration webOAuthPresentViewController:nil];
}

- (instancetype)initWithConfiguration:(LinkedinSwiftConfiguration*)_configuration webOAuthPresentViewController:(UIViewController*)presentViewController {
    
    if (self = [super init]) {
        configuration = _configuration;
        
        LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:configuration.redirectUrl clientId:configuration.clientId clientSecret:configuration.clientSecret state:configuration.state grantedAccess:configuration.permissions];
        httpClient = [LIALinkedInHttpClient clientForApplication:application presentingViewController:presentViewController];
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
        if ([LinkedinSwiftHelper isLinkedinAppInstalled]) {
            
            /**
             *  If Linkedin app installed, use Linkedin sdk
             */
            __block LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
            
            // check if session is still cached
            if (session && session.isValid) {
                
                this->lsAccessToken = [[LSLinkedinToken alloc] initWithAccessToken:session.accessToken.accessTokenValue expireDate:session.accessToken.expiration fromMobileSDK: YES];
                successCallback(this->lsAccessToken);
            } else {
                
                // no cache, create a new session
                [LISDKSessionManager createSessionWithAuth:configuration.permissions state:@"GET-ACCESS-TOKEN" showGoToAppStoreDialog:YES successBlock:^(NSString *returnState) {
                    
                    // refresh session
                    session = [[LISDKSessionManager sharedInstance] session];
                    this->lsAccessToken = [[LSLinkedinToken alloc] initWithAccessToken:session.accessToken.accessTokenValue expireDate:session.accessToken.expiration fromMobileSDK: YES];
                    successCallback(this->lsAccessToken);
                    
                } errorBlock:^(NSError *error) {
                    // error code 3 means user cancelled, LISDKErrorCode.USER_CANCELLED doesn't work
                    if (error.code == 3) {
                        cancelCallback();
                    } else {
                        errorCallback(error);
                    }
                }];
            }
        } else {
            
            /**
             *  If Linkedin app is not installed, present a model webview to let use login
             *
             *  WARNING: here we can check the cache save api call as well,
             *  but there is a problem when you login on other devices the accessToken you cached will invalid,
             *  and only you use this will be notice this, so I choose don't use this cache
             */
            [httpClient getAuthorizationCode:^(NSString *code) {
                
                [this->httpClient getAccessToken:code success:^(NSDictionary *dictionary) {
                    
                    NSString *accessToken = [dictionary objectForKey:@"access_token"];
                    NSNumber *expiresInSec = [dictionary objectForKey:@"expires_in"];
                    
                    this->lsAccessToken = [[LSLinkedinToken alloc] initWithAccessToken:accessToken expireDate:[NSDate dateWithTimeIntervalSinceNow:expiresInSec.doubleValue] fromMobileSDK: NO];
                    successCallback(this->lsAccessToken);
                } failure:^(NSError *error) {
                    errorCallback(error);
                }];
                
            } cancel:^{
                cancelCallback();
            } failure:^(NSError *error) {
                errorCallback(error);
            }];
        }
    }
}

#pragma mark -
#pragma mark Request

- (void)requestURL:(NSString*)url requestType:(LinkedinSwiftRequestType*)requestType success:(LinkedinSwiftRequestSuccessCallback)successCallback error:(LinkedinSwiftRequestErrorCallback)errorCallback {
    
    // Only can make request after logged in
    if (lsAccessToken != nil) {
        // for now only GET is needed :)
        if ([requestType isEqualToString:LinkedinSwiftRequestGet]) {
            
            if (lsAccessToken.isFromMobileSDK) {
                
                [[LISDKAPIHelper sharedInstance] getRequest:url success:^(LISDKAPIResponse *response) {
                    
                    successCallback([[LSResponse alloc] initWithString:response.data statusCode:response.statusCode]);
                } error:^(LISDKAPIError *error) {
                    
                    errorCallback(error);
                }];
            } else {
                [self httpClientRequestWithURL:url success:successCallback erorr:errorCallback];
            }
        }
    }
}

- (void)httpClientRequestWithURL:(NSString*)url success:(LinkedinSwiftRequestSuccessCallback)successCallback erorr:(LinkedinSwiftRequestErrorCallback)errorCallback {
    
#ifdef isSessionManager
    [httpClient GET:url parameters:@{@"oauth2_access_token": lsAccessToken.accessToken} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallback([[LSResponse alloc] initWithDictionary:responseObject statusCode:200]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(error);
    }];
#else
    
    [httpClient GET:url parameters:@{@"oauth2_access_token": lsAccessToken.accessToken} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        successCallback([[LSResponse alloc] initWithDictionary:responseObject statusCode:200]);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        errorCallback(error);
    }];
#endif
}

#pragma mark -
#pragma mark Static functions

+ (BOOL)isLinkedinAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"linkedin://"]];
}

+ (BOOL)shouldHandleUrl:(NSURL *)url {
    
    return [self isLinkedinAppInstalled] && [LISDKCallbackHandler shouldHandleUrl:url];
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [self isLinkedinAppInstalled] && [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
