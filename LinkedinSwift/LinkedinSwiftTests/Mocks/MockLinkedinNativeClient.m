//
//  MockLinkedinNativeClient.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import "MockLinkedinNativeClient.h"

@implementation MockLinkedinNativeClient
@synthesize authorizeCalled, requestCalled, tokenExpireDate;

- (void)authorizeSuccess:(__nullable LinkedinSwiftAuthRequestSuccessCallback)successCallback error:(__nullable LinkedinSwiftRequestErrorCallback)errorCallback cancel:(__nullable LinkedinSwiftRequestCancelCallback)cancelCallback {
    
    authorizeCalled = true;
    NSDate *expireDate = tokenExpireDate ?: [NSDate new];
    LSLinkedinToken *token = [[LSLinkedinToken alloc] initWithAccessToken:@"123123" expireDate:expireDate fromMobileSDK:true];
    successCallback(token);
}


- (void)requestURL:(NSString* _Nonnull)url requestType:(LinkedinSwiftRequestType* _Nonnull)requestType token:(LSLinkedinToken * _Nonnull)token success:(__nullable LinkedinSwiftRequestSuccessCallback)successCallback error:(__nullable LinkedinSwiftRequestErrorCallback)errorCallback {
    
    requestCalled = true;
    LSResponse *response = [[LSResponse alloc] initWithData:[NSData new] statusCode:200];
    successCallback(response);
}

- (void)reset {
    authorizeCalled = false;
    requestCalled = false;
}

@end
