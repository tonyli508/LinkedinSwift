//
//  LinkedinOAuthWebClient.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSTypesHeader.h"



@class UIViewController, LIALinkedInHttpClient;
@interface LinkedinOAuthWebClient : NSObject<LinkedinClient> {
    LIALinkedInHttpClient *httpClient;
}

/**
 *  Init with configurations
 *
 *  @param redirectURL  oauth redirect url
 *  @param clientId     client id
 *  @param clientSecret client secret
 *  @param state        state
 *  @param permissions  permissions required
 *  @param presentViewController presentViewController 
 *
 */
- (instancetype)initWithRedirectURL:(NSString*)redirectURL clientId:(NSString*)clientId clientSecret:(NSString*)clientSecret state:(NSString*)state permissions:(NSArray*)permissions present:(UIViewController*)presentViewController;


@end
