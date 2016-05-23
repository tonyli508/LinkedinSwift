//
//  LinkedinSwiftApplication.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Liknedin configuration most for oauth
 */
@interface LinkedinSwiftConfiguration : NSObject

/**
 *  Linkedin client id, lookup your https://developer.linkedin.com settings
 */
@property (nonatomic, strong, readonly) NSString *clientId;
/**
 *  Linkedin client secret, lookup your https://developer.linkedin.com settings
 */
@property (nonatomic, strong, readonly) NSString *clientSecret;
/**
 *  state to identify each oauth redirect calls, make a unique one
 */
@property (nonatomic, strong, readonly) NSString *state;
/**
 *  Linkedin permissions to ask
 */
@property (nonatomic, strong, readonly) NSArray *permissions;
/**
 *  Linkedin oauth redirect url
 */
@property (nonatomic, strong) NSString *redirectUrl;


/**
 *  Init with settings
 *
 *  @param clientId     Linkedin client id
 *  @param clientSecret Linkedin client secret
 *  @param state        state to identify each oauth redirect calls, make a unique one
 *  @param permisssions Linkedin permissions to ask
 *  @param redirectUrl  Linkedin oauth redirect url
 *
 *  @return LinkedinSwiftConfiguration
 */

- (instancetype)initWithClientId:(NSString *)_clientId clientSecret:(NSString *)_clientSecret state:(NSString *)_state permissions:(NSArray *)_permisssions redirectUrl:(NSString *)redirectUrl;



@end
