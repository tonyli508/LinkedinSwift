//
//  LinkedinSwiftTests.m
//  LinkedinSwiftTests
//
//  Created by Li Jiantang on 17/11/2015.
//  Copyright © 2015 Carma. All rights reserved.
//

#import <XCTest/XCTest.h>

#define AFHTTPManager AFHTTPRequestOperationManager

#import "MockLinkedinWebClient.h"
#import "MockLinkedinNativeClient.h"
#import "NativeAppInstalledToggleChecker.h"
#import "LSHeader.h"

@interface LinkedinSwiftTests : XCTestCase {

    NativeAppInstalledToggleChecker *checker;
    MockLinkedinWebClient *webClient;
    MockLinkedinNativeClient *nativeClient;
    LinkedinSwiftHelper *helper;
}

@end

@implementation LinkedinSwiftTests

- (void)setUp {
    [super setUp];
    // fake configuration
    LinkedinSwiftConfiguration *configuration = [[LinkedinSwiftConfiguration alloc] initWithClientId:@"123" clientSecret:@"secret" state:@"ok" permissions:@[@"profile", @"login"] redirectUrl:@"https://goole.com"];
    // create mocks
    checker = [NativeAppInstalledToggleChecker new];
    webClient = [[MockLinkedinWebClient alloc] initWithRedirectURL:configuration.redirectUrl clientId:configuration.clientId clientSecret:configuration.clientSecret state:configuration.state permissions:configuration.permissions present:nil];
    nativeClient = [[MockLinkedinNativeClient alloc] initWithPermissions:configuration.permissions];
    // create helper instance
    helper = [[LinkedinSwiftHelper alloc] initWithConfiguration:configuration nativeAppChecker:checker clients:@[nativeClient, webClient] webOAuthPresentViewController:nil persistedLSToken:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)authorizeAssertionsFromNative:(BOOL)authorizeFromNative {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Should call success callback!"];
    
    [helper authorizeSuccess:^(LSLinkedinToken * _Nonnull token) {
        
        XCTAssertEqual(nativeClient.authorizeCalled, authorizeFromNative);
        XCTAssertEqual(webClient.authorizeCalled, !authorizeFromNative);
        XCTAssertEqual(token.isFromMobileSDK, authorizeFromNative);
        
        [expectation fulfill];
        
    } error:^(NSError * _Nonnull error) {
        XCTFail(@"Should not call error!");
    } cancel:^{
        XCTFail(@"Should not call cancel!");
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Should not timteout!");
    }];
}

- (void)requestAssertionsFromNative:(BOOL)requestFromNative {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Should call success callback!"];
    
    [helper requestURL:@"https://api.linkedin.com/profile" requestType:LinkedinSwiftRequestGet success:^(LSResponse * _Nonnull response) {
        
        XCTAssertEqual(nativeClient.requestCalled, requestFromNative);
        XCTAssertEqual(webClient.requestCalled, !requestFromNative);

        [expectation fulfill];
        
    } error:^(NSError * _Nonnull error) {
        XCTFail(@"Should not call error!");
    }];
    
    [self waitForExpectationsWithTimeout:60 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, "Should not timteout!");
    }];
}

- (void)testNativeAppInstalledShouldCallNativeClient {
    // app installed
    checker.installed = true;
    // reset
    [webClient reset];
    [nativeClient reset];
    
    [self authorizeAssertionsFromNative:true];
}

- (void)testNativeAppNotInstalledShouldCallWebClient {
    // app not installed
    checker.installed = false;
    // reset
    [webClient reset];
    [nativeClient reset];
    
    [self authorizeAssertionsFromNative:false];
}

- (void)testAuthorizeWithNativeAppInstallTheRequestAfterDeletedNativeApp {
    // app installed
    checker.installed = true;
    // reset
    [webClient reset];
    [nativeClient reset];
    // authorize from native
    [self authorizeAssertionsFromNative:true];
    // while app installed should request from native client
    [self requestAssertionsFromNative:true];
    
    // deleting the app
    checker.installed = false;
    // reset
    [webClient reset];
    [nativeClient reset];
    // still request from native even native app deleted, because token is from native client
    [self requestAssertionsFromNative:true];
}

- (void)testTokenCaching {
    // app installed
    checker.installed = true;
    [webClient reset];
    [nativeClient reset];
    // set token expire date to one hour later
    nativeClient.tokenExpireDate = [[NSDate new] dateByAddingTimeInterval:3600];
    // authorize
    [self authorizeAssertionsFromNative:true];
    // cache current token
    LSLinkedinToken *authorizedToken = helper.lsAccessToken;
    XCTAssertNotNil(authorizedToken);
    
    // re-do authorize
    [self authorizeAssertionsFromNative:true];
    // re-authorized token
    LSLinkedinToken * reauthorizedToken= helper.lsAccessToken;
    
    XCTAssertEqual(authorizedToken, reauthorizedToken, "Two token should be same, cached!");
}

- (void)testTokenExpire {
    // app installed
    checker.installed = false;
    [webClient reset];
    [nativeClient reset];
    // set token expire date to one hour ago
    nativeClient.tokenExpireDate = [[NSDate new] dateByAddingTimeInterval:-3600];
    // authorize
    [self authorizeAssertionsFromNative:false];
    // cache current token
    LSLinkedinToken *authorizedToken = helper.lsAccessToken;
    XCTAssertNotNil(authorizedToken);
    
    // re-do authorize
    [self authorizeAssertionsFromNative:false];
    // re-authorized token
    LSLinkedinToken * reauthorizedToken= helper.lsAccessToken;
    
    XCTAssertNotEqual(authorizedToken, reauthorizedToken, "Two token should not be same, expired!");
}

@end
