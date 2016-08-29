//
//  NativeAppInstalledChecker.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NativeAppInstalledChecker : NSObject {
    NSString *linkedinAppScheme;
}

/**
 *  Check if Linkedin app is installed
 *
 *  @return Bool
 */
- (BOOL)isLinkedinAppInstalled;

@end
