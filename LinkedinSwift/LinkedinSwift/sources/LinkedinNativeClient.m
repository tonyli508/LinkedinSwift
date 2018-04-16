//
//  LinkedinNativeClient.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import "LinkedinNativeClient.h"
#import <linkedin-sdk/LISDK.h>
#import "LinkedinSwiftConfiguration.h"

@implementation LinkedinNativeClient

- (instancetype)initWithPermissions:(NSArray *)_permissions {
    
    if (self = [super init]) {
        permissions = _permissions;
    }
    
    return self;
}


- (void)authorizeSuccess:(__nullable LinkedinSwiftAuthRequestSuccessCallback)successCallback error:(__nullable LinkedinSwiftRequestErrorCallback)errorCallback cancel:(__nullable LinkedinSwiftRequestCancelCallback)cancelCallback {
    
    /**
     *  If Linkedin app installed, use Linkedin sdk
     */
    __block LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
    
    // check if session is still cached
    if (session && session.isValid) {
        
        LSLinkedinToken *token = [[LSLinkedinToken alloc] initWithAccessToken:session.accessToken.accessTokenValue expireDate:session.accessToken.expiration fromMobileSDK: YES];
        successCallback(token);
    } else {
        
        // no cache, create a new session
        [LISDKSessionManager createSessionWithAuth:permissions state:@"GET-ACCESS-TOKEN" showGoToAppStoreDialog:YES successBlock:^(NSString *returnState) {
            
            // refresh session
            session = [[LISDKSessionManager sharedInstance] session];
            LSLinkedinToken *token =  [[LSLinkedinToken alloc] initWithAccessToken:session.accessToken.accessTokenValue expireDate:session.accessToken.expiration fromMobileSDK: YES];
            successCallback(token);
            
        } errorBlock:^(NSError *error) {
            // error code 3 means user cancelled, LISDKErrorCode.USER_CANCELLED doesn't work
            if (error.code == 3) {
                cancelCallback();
            } else {
                errorCallback(error);
            }
        }];
    }
}


- (void)requestURL:(NSString* _Nonnull)url requestType:(LinkedinSwiftRequestType* _Nonnull)requestType token:(LSLinkedinToken * _Nonnull)token success:(__nullable LinkedinSwiftRequestSuccessCallback)successCallback error:(__nullable LinkedinSwiftRequestErrorCallback)errorCallback {
    [[LISDKAPIHelper sharedInstance] getRequest:url success:^(LISDKAPIResponse *response) {
        successCallback([[LSResponse alloc] initWithString:response.data statusCode:response.statusCode]);
    } error:^(LISDKAPIError *error) {
        errorCallback(error);
    }];
}

- (void)logout {
    [LISDKSessionManager clearSession];
}

@end
