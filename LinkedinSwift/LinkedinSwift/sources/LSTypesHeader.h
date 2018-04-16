//
//  LSTypesHeader.h
//  LinkedinSwift
//
//  Created by Li Jiantang on 29/08/2016.
//  Copyright © 2016 Carma. All rights reserved.
//

#ifndef LSTypesHeader_h
#define LSTypesHeader_h

#import "LSLinkedinToken.h"
#import "LSResponse.h"

/**
 *  LinkedinSwiftRequestSuccessCallback
 *
 *  @param response LSResponse
 */
typedef void(^LinkedinSwiftRequestSuccessCallback)(LSResponse * _Nonnull response);
/**
 *  LinkedinSwiftAuthRequestSuccessCallback
 *
 *  @param token LSLinkedinToken
 */
typedef void(^LinkedinSwiftAuthRequestSuccessCallback)(LSLinkedinToken * _Nonnull token);
/**
 *  LinkedinSwiftRequestErrorCallback
 *
 *  @param error NSError
 */
typedef void(^LinkedinSwiftRequestErrorCallback)(NSError * _Nonnull error);
/**
 *  LinkedinSwiftRequestCancelCallback
 */
typedef void(^LinkedinSwiftRequestCancelCallback)(void);

typedef NSString LinkedinSwiftRequestType;
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestGet = @"GET";
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestPOST = @"POST";
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestPUT = @"PUT";
static LinkedinSwiftRequestType* _Nonnull const LinkedinSwiftRequestDELETE = @"DELETE";


@protocol LinkedinClient <NSObject>

/**
 *  Login with Linkedin to get accessToken
 *
 *  @param success  callback
 *  @param error    callback
 *  @param cancel   callback
 */
- (void)authorizeSuccess:(__nullable LinkedinSwiftAuthRequestSuccessCallback)success error:(__nullable LinkedinSwiftRequestErrorCallback)error cancel:(__nullable LinkedinSwiftRequestCancelCallback)cancel;
/**
 *  Request Linkedin api
 *
 *  @param url         api url
 *  @param requestType requst type, for now only support GET
 *  @param token       LSLiknedinToken to use request the api call
 *  @param success     callback
 *  @param error       callback
 */
- (void)requestURL:(NSString* _Nonnull)url requestType:(LinkedinSwiftRequestType* _Nonnull)requestType token:(LSLinkedinToken* _Nonnull)token success:(__nullable LinkedinSwiftRequestSuccessCallback)success error:(__nullable LinkedinSwiftRequestErrorCallback)error;


/**
 Logout current session
 */
- (void)logout;

@end


#endif /* LSTypesHeader_h */
