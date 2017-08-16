//
//  XMURLSessionTaskDelegate.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMURLSessionTaskDelegate.h"

#import "NSFileManager+XMAdditions.h"
#import "NSError+XMErrors.h"

@interface XMURLSessionTaskDelegate ()

@property (nonatomic, strong, readonly) XMRequest *request;
@property (nonatomic, strong, readonly) dispatch_queue_t responseProcessingQueue;
@property (nonatomic, copy, readonly) XMRequestCompletionBlock completionBlock;
@property (nonatomic, copy, readonly) XMRequestProgressBlock progressBlock;
@property (nonatomic, copy, readonly) XMHTTPResponseProcessBlock responseProcessBlock;
@property (nonatomic, strong, readonly) NSMutableData *data;
@property (nonatomic, copy) NSError *error;

@end

@implementation XMURLSessionTaskDelegate

- (instancetype)initWithRequest:(XMRequest *)request
        responseProcessingQueue:(dispatch_queue_t)responseProcessingQueue
                  progressBlock:(XMRequestProgressBlock)progressBlock
           responseProcessBlock:(XMHTTPResponseProcessBlock)responseProcessBlock
                completionBlock:(XMRequestCompletionBlock)completionBlock {
    NSParameterAssert(request);
    NSParameterAssert(responseProcessingQueue);
    
    self = [super init];
    if (!self) return nil;
    
    _request = request;
    _responseProcessingQueue = responseProcessingQueue;
    _progressBlock = [progressBlock copy];
    _responseProcessBlock = [responseProcessBlock copy];
    _completionBlock = [completionBlock copy];
    _data = [NSMutableData data];
    
    return self;
}

#pragma mark - Public

- (void)task:(NSURLSessionTask *)task didReceiveData:(NSData *)data {
    NSParameterAssert(data);
    [self.data appendData:data];
    [self taskDidUpdateProgress:task];
}

- (void)taskDidUpdateProgress:(NSURLSessionTask *)task {
    if (!self.progressBlock) return;
    
    int64_t expectedBytes = 0;
    int64_t receivedBytes = 0;
    
    if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        expectedBytes = task.countOfBytesExpectedToSend;
        receivedBytes = task.countOfBytesSent;
    } else {
        expectedBytes = task.countOfBytesExpectedToReceive;
        receivedBytes = task.countOfBytesReceived;
    }
    
    float progress = 0.f;
    if (expectedBytes > 0) {
        progress = (double)receivedBytes / (double)expectedBytes;
    }
    
    self.progressBlock(progress, expectedBytes, receivedBytes);
}

- (void)task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSURLResponse *URLResponse = task.response;
    
    XMRequestCompletionBlock completion = self.completionBlock;
    NSError *otherError = self.error;
    
    dispatch_async(self.responseProcessingQueue, ^{
        id body = [self responseBodyForTask:task];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Compose response and return on the main queue
            NSUInteger statusCode = [URLResponse isKindOfClass:[NSHTTPURLResponse class]] ? [(NSHTTPURLResponse *)URLResponse statusCode] : 0;
            XMResponse *response = [[XMResponse alloc] initWithStatusCode:statusCode body:body];
            
            // NSURLSession reports URL level errors, but does not generate errors for non-2xx status codes.
            // Therefore we need to create our own error.
            NSError *finalError = error;
            if (!finalError) {
                if (statusCode < 200 || statusCode > 299) {
                    finalError = [NSError ba_serverErrorWithStatusCode:statusCode body:body];
                } else if (otherError) {
                    finalError = otherError;
                }
            }
            
            completion(response, finalError);
        });
    });
}

- (void)task:(NSURLSessionTask *)task didFinishDownloadingToURL:(NSURL *)location {
    NSParameterAssert(location);
    
    NSString *destinationPath = self.request.fileData.filePath;
    if (destinationPath) {
        NSError *moveError = nil;
        [[NSFileManager defaultManager] ba_moveItemAtURL:location
                                                   toPath:destinationPath
                              withIntermediateDirectories:YES
                                                    error:&moveError];
        if (moveError) {
            [self task:task didError:moveError];
        }
    }
}

- (void)task:(NSURLSessionTask *)task didError:(NSError *)error {
    self.error = error;
}

- (id)responseBodyForTask:(NSURLSessionTask *)task {
    id data = self.data.length > 0 ? [NSData dataWithData:self.data] : nil;
    
    id body = data;
    if (self.responseProcessBlock) {
        body = self.responseProcessBlock(task.response, data, self);
    }
    
    return body;
}


@end
