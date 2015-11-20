//
//  LSResponse.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 19/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  LSResponse, responsed json object and http status code
 */
@interface LSResponse : NSObject

@property (nonatomic, strong, readonly) NSDictionary *jsonObject;
@property (nonatomic, readonly) int statusCode;

/**
 *  Init with string
 *
 *  @param string      string response
 *  @param _statusCode http status code
 *
 *  @return LSResponse
 */
- (instancetype)initWithString:(NSString*)string statusCode:(int)statusCode;
/**
 *  Init with data
 *
 *  @param _data       data resopnse
 *  @param _statusCode http status code
 *
 *  @return LSResponse
 */
- (instancetype)initWithData:(NSData*)data statusCode:(int)statusCode;
/**
 *  Init with json dictionary
 *
 *  @param _dictionary dictionary
 *  @param _statusCode http status code
 *
 *  @return LSResponse
 */
- (instancetype)initWithDictionary:(NSDictionary*)_dictionary statusCode:(int)_statusCode;

@end
