//
//  NativeAppInstalledToggleChecker.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NativeAppInstalledChecker.h"

@interface NativeAppInstalledToggleChecker : NativeAppInstalledChecker {
    BOOL installed;
}

@property (nonatomic, assign) BOOL installed;

@end
