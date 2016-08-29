//
//  LinkedinNativeClient.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSTypesHeader.h"

@interface LinkedinNativeClient : NSObject<LinkedinClient> {
    NSArray *permissions;
}

/**
 *  Init with permissions required
 *
 *  @param permissions permissions required
 *
 */
- (instancetype)initWithPermissions:(NSArray *)permissions;

@end
