//
//  BAHTTPClient.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMRequest.h"
#import "XMResponse.h"
#import "XMRequestSerializer.h"
#import "XMResponseSerializer.h"
#import "XMCommonConfigProtocol.h"

typedef void(^XMRequestCompletionBlock)(XMResponse *response, NSError *error);

/**
 *  A progress block to be called whenever a task makes progress.
 *
 *  @param progress           The current progress of the task.
 *  @param totalBytesExpected The total expected number of bytes to be received.
 *  @param totalBytesReceived The current number of bytes received at the time of calling this block.
 */
typedef void(^XMRequestProgressBlock)(float progress, int64_t totalBytesExpected, int64_t totalBytesReceived);

@interface XMHTTPClient : NSObject

@property (nonatomic, copy) NSURL *baseURL;

/**
 *  The user agent string of the user agent.
 */
@property (nonatomic, copy) NSString *userAgent;


@property (nonatomic, assign) BOOL debugEnabled;

@property (nonatomic, strong) Class<XMCommonConfigProtocol> commonParametersClass;

/**
 *  The serializer of the request.
 */
@property (nonatomic, strong, readonly) XMRequestSerializer *requestSerializer;

/**
 *  The serializer of the response.
 */
@property (nonatomic, strong, readonly) XMResponseSerializer *responseSerializer;

/**
 *  Controls whether or not to pin the server public key to that of any .cer certificate included in the app bundle.
 */
@property (nonatomic) BOOL useSSLPinning;

/**
 *  Creates and returns a NSURLSessionTask for the given request, for which the provided completion handler
 *  will be executed upon completion.
 *
 *  @param request    The request
 *  @param completion A block to be called when the task makes progress, or nil.
 *  @param completion A completion handler to be executed on task completion.
 *
 *  @return An NSURLSessionTask
 */
- (NSURLSessionTask *)taskForRequest:(XMRequest *)request progress:(XMRequestProgressBlock)progress completion:(XMRequestCompletionBlock)completion;

- (NSMutableURLRequest *)URLRequestForRequest:(XMRequest *)request;

@end
