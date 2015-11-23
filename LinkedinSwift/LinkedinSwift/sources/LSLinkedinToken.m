//
//  LSLinkedinToken.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import "LSLinkedinToken.h"

@implementation LSLinkedinToken
@synthesize accessToken, expireDate, isFromMobileSDK;

- (instancetype)initWithAccessToken:(NSString*)_accessToken expireDate:(NSDate*)_expireDate fromMobileSDK:(BOOL)_isFromMobileSDK {
    
    if (self = [super init]) {
        
        accessToken = _accessToken;
        expireDate = _expireDate;
        isFromMobileSDK = _isFromMobileSDK;
    }
    
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<LSLinkedinToken - accessToken: %@, expireDate: %@>", accessToken, expireDate];
}

@end
