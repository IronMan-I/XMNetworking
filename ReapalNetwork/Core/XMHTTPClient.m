//
//  BAHTTPClient.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMHTTPClient.h"
#import "XMURLSessionTaskDelegate.h"
#import "XMMultipartFormData.h"
#import "XMSecurity.h"
#import "XMMacros.h"
#import "NSURLRequest+XMDescription.h"


static char * const kRequestProcessingQueueLabel = "com.reapal.networingkit.httpclient.response_processing_queue";

@interface XMHTTPClient () <NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong, readonly) NSURLSession *session;
@property (nonatomic, strong, readonly) dispatch_queue_t responseProcessingQueue;
@property (nonatomic, strong) NSOperationQueue *delegateQueue;
@property (nonatomic, strong) NSMutableDictionary *taskDelegates;
@property (nonatomic, strong) NSLock *taskDelegatesLock;
@property (nonatomic, copy, readonly) XMSecurity *security;

@end

@implementation XMHTTPClient

@synthesize session = _session;
@synthesize requestSerializer = _requestSerializer;
@synthesize responseSerializer = _responseSerializer;
@synthesize security = _security;

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _baseURL = [[NSURL alloc] initWithString:kDefaultBaseURLString];
    _responseProcessingQueue = dispatch_queue_create(kRequestProcessingQueueLabel, DISPATCH_QUEUE_CONCURRENT);
    _requestSerializer = [XMRequestSerializer new];
    _responseSerializer = [XMResponseSerializer new];
    _taskDelegates = [NSMutableDictionary new];
    _taskDelegatesLock = [NSLock new];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPShouldUsePipelining = YES;
    
    self.delegateQueue = [NSOperationQueue new];
    self.delegateQueue.maxConcurrentOperationCount = 1;
    
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:self.delegateQueue];
    
    return self;
}

#pragma mark - Properties

- (NSString *)userAgent {
    return [self.requestSerializer valueForHTTPHeader:XMRequestSerializerHTTPHeaderKeyUserAgent];
}

- (void)setUserAgent:(NSString *)userAgent {
    [self.requestSerializer setUserAgentHeader:userAgent];
}

#pragma mark - Private

- (XMSecurity *)security {
    if (!_security) {
        _security = [XMSecurity new];
    }
    
    return _security;
}

- (void)addTaskDelegate:(XMURLSessionTaskDelegate *)delegate forTask:(NSURLSessionTask *)task {
    NSParameterAssert(delegate);
    [self.taskDelegatesLock lock];
    self.taskDelegates[@(task.taskIdentifier)] = delegate;
    [self.taskDelegatesLock unlock];
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task {
    [self.taskDelegatesLock lock];
    [self.taskDelegates removeObjectForKey:@(task.taskIdentifier)];
    [self.taskDelegatesLock unlock];
}

- (XMURLSessionTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
    return self.taskDelegates[@(task.taskIdentifier)];
}

- (XMRequest *)addCommonParametersByRequest:(XMRequest *)request {
    if (self.commonParametersClass) {
        if ([(id)self.commonParametersClass conformsToProtocol:@protocol(XMCommonConfigProtocol)]) {
            NSString *className = NSStringFromClass(self.commonParametersClass);
            if (request.parameters) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters addEntriesFromDictionary:request.parameters];
                [parameters addEntriesFromDictionary:[NSClassFromString(className) commonParameters]];
                request.parameters = parameters;
            } else {
                request.parameters = [NSClassFromString(className) commonParameters];
            }
        } else {
            debug(@"请在%@中实现commonParameters方法", self.commonParametersClass);
        }
    }
    return request;
}

#pragma mark - Public

- (NSURLSessionTask *)taskForRequest:(XMRequest *)request progress:(XMRequestProgressBlock)progress completion:(XMRequestCompletionBlock)completion {
    NSURLSessionTask *task = nil;
    request = [self addCommonParametersByRequest:request];
    
    XMHTTPResponseProcessBlock responseProcessBlock = nil;
    
    if ((request.fileData || request.fileDatas) && (request.method == XMRequestMethodPUT || request.method == XMRequestMethodPOST)) {
        // Upload task
        XMMultipartFormData *multipartData = [self.requestSerializer multipartFormDataFromRequest:request];
        NSData *data = [multipartData finalizedData];
        
        NSMutableURLRequest *URLRequest = [self.requestSerializer URLRequestForRequest:request multipartData:multipartData relativeToURL:self.baseURL];
        
        if (self.debugEnabled) {
            debug(@"URLRequest = %@ ", [URLRequest ba_description]);
        }
        
        XM_WEAK(self.responseSerializer) weakResponseSerializer = self.responseSerializer;
        responseProcessBlock = ^(NSURLResponse *URLResponse, NSData *data, XMURLSessionTaskDelegate *delegate) {
            return [weakResponseSerializer responseObjectForURLResponse:URLResponse data:data];
        };
        
        task = [self.session uploadTaskWithRequest:URLRequest fromData:data];
    } else {
        NSMutableURLRequest *URLRequest = [self.requestSerializer URLRequestForRequest:request relativeToURL:self.baseURL];
        
        if (self.debugEnabled) {
            debug(@"URLRequest = %@ ", [URLRequest ba_description]);
        }
        if (request.fileData && request.method == XMRequestMethodGET) {
            // Download task
            
            task = [self.session downloadTaskWithRequest:URLRequest];
        } else {
            // Regular data task
            task = [self.session dataTaskWithRequest:URLRequest];
            
            XM_WEAK(self.responseSerializer) weakResponseSerializer = self.responseSerializer;
            responseProcessBlock = ^(NSURLResponse *URLResponse, NSData *data, XMURLSessionTaskDelegate *delegate) {
                return [weakResponseSerializer responseObjectForURLResponse:URLResponse data:data];
            };
        }
    }
    
    XMURLSessionTaskDelegate *taskDelegate = [[XMURLSessionTaskDelegate alloc] initWithRequest:request
                                                                         responseProcessingQueue:self.responseProcessingQueue
                                                                                   progressBlock:progress
                                                                            responseProcessBlock:responseProcessBlock
                                                                                 completionBlock:completion];
    [self addTaskDelegate:taskDelegate forTask:task];
    
    return task;
}

- (NSMutableURLRequest *)URLRequestForRequest:(XMRequest *)request {
    return [self.requestSerializer URLRequestForRequest:request relativeToURL:_baseURL];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    
    if (self.useSSLPinning && [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
        BOOL isTrustValid = [self.security evaluateServerTrust:serverTrust];
        
        if (isTrustValid) {
            credential = [NSURLCredential credentialForTrust:serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    XMURLSessionTaskDelegate *taskDelegate = [self delegateForTask:task];
    [taskDelegate task:task didCompleteWithError:error];
    [self removeDelegateForTask:task];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    XMURLSessionTaskDelegate *taskDelegate = [self delegateForTask:dataTask];
    [taskDelegate task:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    XMURLSessionTaskDelegate *taskDelegate = [self delegateForTask:task];
    [taskDelegate taskDidUpdateProgress:task];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    XMURLSessionTaskDelegate *taskDelegate = self.taskDelegates[@(downloadTask.taskIdentifier)];
    [taskDelegate taskDidUpdateProgress:downloadTask];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    XMURLSessionTaskDelegate *taskDelegate = [self delegateForTask:downloadTask];
    [taskDelegate task:downloadTask didFinishDownloadingToURL:location];
}

@end
