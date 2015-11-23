//
//  LSLinkedinToken.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  LSLinkedinToken
 */
@interface LSLinkedinToken : NSObject

/**
 *  Linkedin access token
 */
@property (nonatomic, strong, readonly) NSString *accessToken;
/**
 *  token expire date
 */
@property (nonatomic, strong, readonly) NSDate *expireDate;
/**
 *  If token is from MobileSDK
 */
@property (nonatomic, readonly) BOOL isFromMobileSDK;


- (instancetype)initWithAccessToken:(NSString*)_accessToken expireDate:(NSDate*)_expireDate fromMobileSDK:(BOOL)_isFromMobileSDK;

@end
