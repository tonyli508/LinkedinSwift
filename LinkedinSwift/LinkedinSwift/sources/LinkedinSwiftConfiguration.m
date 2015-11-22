//
//  LinkedinSwiftApplication.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import "LinkedinSwiftConfiguration.h"


@implementation LinkedinSwiftConfiguration
@synthesize clientId, clientSecret, state, permissions, redirectUrl;

- (instancetype)initWithClientId:(NSString *)_clientId clientSecret:(NSString *)_clientSecret state:(NSString *)_state permissions:(NSArray *)_permisssions redirectUrl:(NSString *)_redirectUrl {
    
    if (self = [super init]) {
        clientId = _clientId;
        clientSecret = _clientSecret;
        state = _state;
        permissions = _permisssions;
        redirectUrl = _redirectUrl;
    }
    
    return self;
}

@end
