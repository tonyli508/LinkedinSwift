//
//  NativeAppInstalledChecker.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#import "NativeAppInstalledChecker.h"
#import <UIKit/UIKit.h>

@implementation NativeAppInstalledChecker

- (instancetype)init {
    
    if (self = [super init]) {
        linkedinAppScheme = @"linkedin://";
    }
    return self;
}

- (BOOL)checkIfAppSchemeExist:(NSString *)appScheme {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]];
}

- (BOOL)isLinkedinAppInstalled {
    return [self checkIfAppSchemeExist:linkedinAppScheme];
}

@end
