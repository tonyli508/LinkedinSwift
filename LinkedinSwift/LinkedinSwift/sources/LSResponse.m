//
//  LSResponse.m
//  LinkedinSwift
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import "LSResponse.h"

#import <Foundation/Foundation.h>

@implementation LSResponse
@synthesize jsonObject, statusCode;

/**
 *  Init with string
 *
 *  @param string      string response
 *  @param _statusCode http status code
 *
 *  @return LSResponse
 */
- (instancetype)initWithString:(NSString*)string statusCode:(int)_statusCode {
    return [self initWithData:[string dataUsingEncoding:NSUTF8StringEncoding] statusCode:_statusCode];
}

/**
 *  Init with data
 *
 *  @param _data       data resopnse
 *  @param _statusCode http status code
 *
 *  @return LSResponse
 */
- (instancetype)initWithData:(NSData*)_data statusCode:(int)_statusCode {
    
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:_data options:0 error:&error];
    
    if (json != nil && error == nil) {
        self = [self initWithDictionary:json statusCode:_statusCode];
    }
    
    return self;
}

/**
 *  Init with json dictionary
 *
 *  @param _dictionary dictionary
 *  @param _statusCode http status code
 *
 *  @return LSResponse
 */
- (instancetype)initWithDictionary:(NSDictionary*)_dictionary statusCode:(int)_statusCode {
    
    if (self = [super init]) {
        
        jsonObject = _dictionary;
        statusCode = _statusCode;
    }
    
    return self;
}

- (NSString*)description {
    
    return [NSString stringWithFormat:@"<LSResponse - data: %@, status code: %d>", jsonObject, statusCode];
}

@end
