//
//  MockLinkedinWebClient.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkedinOAuthWebClient.h"

@interface MockLinkedinWebClient : LinkedinOAuthWebClient {
    BOOL authorizeCalled;
    BOOL requestCalled;
    NSDate *tokenExpireDate;
}

@property (nonatomic, assign) BOOL authorizeCalled;
@property (nonatomic, assign) BOOL requestCalled;
@property (nonatomic, strong) NSDate *tokenExpireDate;

- (void)reset;

@end
