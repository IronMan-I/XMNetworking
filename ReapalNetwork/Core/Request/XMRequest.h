//
//  XMRequest.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMRequestFileData.h"

#define XMRequestPath(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

typedef NSURLRequest * (^BAURLRequestConfigurationBlock) (NSURLRequest *request);

typedef NS_ENUM(NSUInteger, XMRequestMethod) {
    XMRequestMethodGET = 0,
    XMRequestMethodPOST,
    XMRequestMethodPUT,
    XMRequestMethodDELETE,
    XMRequestMethodHEAD,
};

typedef NS_ENUM(NSUInteger, XMRequestContentType) {
    XMRequestContentTypeJSON = 0,
    XMRequestContentTypeFormURLEncoded,
    XMRequestContentTypeMultipart,
    XMRequestContentTypeString
};

@interface XMRequest : NSObject

@property (nonatomic, assign, readonly) XMRequestMethod method;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, strong) XMRequestFileData *fileData;
@property (nonatomic, strong) NSArray *fileDatas;   // BARequestFileData Array
@property (nonatomic, assign, readwrite) XMRequestContentType contentType;
@property (nonatomic, copy, readwrite) BAURLRequestConfigurationBlock URLRequestConfigurationBlock;

+ (instancetype)GETRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;
+ (instancetype)POSTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;
+ (instancetype)PUTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;
+ (instancetype)DELETERequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

+ (instancetype)GETRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;
+ (instancetype)POSTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;
+ (instancetype)PUTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;
+ (instancetype)DELETERequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;

@end
