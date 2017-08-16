//
//  XMRequestSerializer.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMRequestSerializer.h"
#import "XMRequest.h"
#import "XMMultipartFormData.h"
#import "NSString+XMAdditions.h"
#import "NSURL+XMAdditions.h"
#import "NSDictionary+XMQueryParameters.h"
#import "NSURLRequest+XMDescription.h"


static NSString * const kHTTPMethodGET = @"GET";
static NSString * const kHTTPMethodPOST = @"POST";
static NSString * const kHTTPMethodPUT = @"PUT";
static NSString * const kHTTPMethodDELETE = @"DELETE";
static NSString * const kHTTPMethodHEAD = @"HEAD";

NSString * const XMRequestSerializerHTTPHeaderKeyAuthorization = @"Authorization";
NSString * const XMRequestSerializerHTTPHeaderKeyUserAgent = @"User-Agent";
NSString * const XMRequestSerializerHTTPHeaderKeyContentType = @"Content-Type";
NSString * const XMRequestSerializerHTTPHeaderKeyContentLength = @"Content-Length";


static NSString * const kAuthorizationOAuth2AccessTokenFormat = @"OAuth2 %@";

static NSString * const kHeaderTimeZone = @"X-Time-Zone";

static NSString * const kBoundaryPrefix = @"----------------------";
static NSUInteger const kBoundaryLength = 20;


@interface XMRequestSerializer ()

@property (nonatomic, assign) XMRequestContentType requestContentType;
@property (nonatomic, copy, readonly) NSString *boundary;
@property (nonatomic, strong, readonly) NSMutableDictionary *mutAdditionalHTTPHeaders;

@end

@implementation XMRequestSerializer

@synthesize boundary = _boundary;
@synthesize mutAdditionalHTTPHeaders = _mutAdditionalHTTPHeaders;

- (NSString *)boundary {
    if (!_boundary) {
        _boundary = [NSString stringWithFormat:@"%@%@", kBoundaryPrefix, [NSString ba_randomHexStringOfLength:kBoundaryLength]];
    }
    
    return _boundary;
}

- (NSMutableDictionary *)mutAdditionalHTTPHeaders {
    if (!_mutAdditionalHTTPHeaders) {
        _mutAdditionalHTTPHeaders = [NSMutableDictionary new];
    }
    
    return _mutAdditionalHTTPHeaders;
}

- (NSDictionary *)additionalHTTPHeaders {
    return [self.mutAdditionalHTTPHeaders copy];
}

#pragma mark Public

- (id)valueForHTTPHeader:(NSString *)header {
    return [self additionalHTTPHeaders][header];
}

- (void)setValue:(NSString *)value forHTTPHeader:(NSString *)header {
    NSParameterAssert(header);
    
    if (value) {
        self.mutAdditionalHTTPHeaders[header] = value;
    } else {
        [self.mutAdditionalHTTPHeaders removeObjectForKey:header];
    }
}

- (void)setAuthorizationHeaderWithOAuth2AccessToken:(NSString *)accessToken {
    NSParameterAssert(accessToken);
    [self setValue:[NSString stringWithFormat:kAuthorizationOAuth2AccessTokenFormat, accessToken] forHTTPHeader:XMRequestSerializerHTTPHeaderKeyAuthorization];
}

- (void)setAuthorizationHeaderWithAPIKey:(NSString *)key secret:(NSString *)secret {
    NSParameterAssert(key);
    NSParameterAssert(secret);
    
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", key, secret];
    [self setValue:[NSString stringWithFormat:@"Basic %@", [credentials ba_base64String]] forHTTPHeader:XMRequestSerializerHTTPHeaderKeyAuthorization];
}

- (void)setUserAgentHeader:(NSString *)userAgent {
    NSParameterAssert(userAgent);
    [self setValue:userAgent forHTTPHeader:XMRequestSerializerHTTPHeaderKeyUserAgent];
}

#pragma mark - URL request

- (NSMutableURLRequest *)URLRequestForRequest:(XMRequest *)request relativeToURL:(NSURL *)baseURL {
    return [self URLRequestForRequest:request multipartData:nil relativeToURL:baseURL];
}

- (NSMutableURLRequest *)URLRequestForRequest:(XMRequest *)request multipartData:(XMMultipartFormData *)multipartData relativeToURL:(NSURL *)baseURL {
    NSParameterAssert(request);
    NSParameterAssert(baseURL);
    
    NSURL *url = nil;
    if (request.URL) {
        url = request.URL;
    } else {
        NSParameterAssert(request.path);
        url = [NSURL URLWithString:request.path relativeToURL:baseURL];
    }
    
    if (request.parameters && [[self class] supportsQueryParametersForRequestMethod:request.method]) {
        url = [url ba_URLByAppendingQueryParameters:request.parameters];
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = [[self class] HTTPMethodForMethod:request.method];
    urlRequest.timeoutInterval = 40;
    [urlRequest setValue:[self contentTypeForRequest:request] forHTTPHeaderField:XMRequestSerializerHTTPHeaderKeyContentType];
    [urlRequest setValue:[[NSTimeZone localTimeZone] name] forHTTPHeaderField:kHeaderTimeZone];
    
    if (multipartData) {
        NSString *contentLength = [NSString stringWithFormat:@"%lu", (unsigned long)multipartData.finalizedData.length];
        [urlRequest setValue:contentLength forHTTPHeaderField:XMRequestSerializerHTTPHeaderKeyContentLength];
    }
    
    [self.additionalHTTPHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *header, NSString *value, BOOL *stop) {
        [urlRequest setValue:value forHTTPHeaderField:header];
    }];
    
    urlRequest.HTTPBody = [[self class] bodyDataForRequest:request boundary:self.boundary];
    
    if (request.URLRequestConfigurationBlock) {
        urlRequest = [request.URLRequestConfigurationBlock(urlRequest) mutableCopy];
    }
    
    return urlRequest;
}

- (XMMultipartFormData *)multipartFormDataFromRequest:(XMRequest *)request {
    XMMultipartFormData *multiPartData = [XMMultipartFormData multipartFormDataWithBoundary:self.boundary encoding:NSUTF8StringEncoding];
    
    if (request.fileData.data) {
        [multiPartData appendFileData:request.fileData.data fileName:request.fileData.fileName mimeType:nil name:request.fileData.name];
    } else if (request.fileData.filePath) {
        [multiPartData appendContentsOfFileAtPath:request.fileData.filePath name:request.fileData.name];
    }
    
    for (XMRequestFileData *fileData in request.fileDatas) {
        if (fileData.data) {
            [multiPartData appendFileData:fileData.data fileName:fileData.fileName mimeType:nil name:fileData.name];
        } else if (fileData.filePath) {
            [multiPartData appendContentsOfFileAtPath:fileData.filePath name:fileData.name];
        }
    }
    
    if ([request.parameters count] > 0) {
        [multiPartData appendFormDataParameters:request.parameters];
    }
    
    [multiPartData finalizeData];
    
    return multiPartData;
}

#pragma mark - Private
+ (NSString *)HTTPMethodForMethod:(XMRequestMethod)method {
    NSString *string = nil;
    
    switch (method) {
        case XMRequestMethodGET:
            string = kHTTPMethodGET;
            break;
        case XMRequestMethodPOST:
            string = kHTTPMethodPOST;
            break;
        case XMRequestMethodPUT:
            string = kHTTPMethodPUT;
            break;
        case XMRequestMethodDELETE:
            string = kHTTPMethodDELETE;
            break;
        case XMRequestMethodHEAD:
            string = kHTTPMethodHEAD;
            break;
        default:
            break;
    }
    
    return string;
}

+ (NSData *)bodyDataForRequest:(XMRequest *)request boundary:(NSString *)boundary {
    NSData *data = nil;
    
    if (request.parameters && ![self supportsQueryParametersForRequestMethod:request.method]) {
        if (request.contentType == XMRequestContentTypeJSON) {
            data = [NSJSONSerialization dataWithJSONObject:request.parameters options:0 error:nil];
            
        } else if (request.contentType == XMRequestContentTypeString) {
            data = [[request.parameters ba_escapedQueryString] dataUsingEncoding:NSUTF8StringEncoding];
        } else if (request.contentType == XMRequestContentTypeFormURLEncoded) {
            data = [[request.parameters ba_escapedQueryString] dataUsingEncoding:NSUTF8StringEncoding];
        } else if (request.contentType == XMRequestContentTypeMultipart) {
            XMMultipartFormData *formdata = [XMMultipartFormData multipartFormDataWithBoundary:boundary encoding:NSUTF8StringEncoding];
            [formdata appendFormDataParameters:request.parameters];
            data = formdata.finalizedData;
        }
    }
    
    return data;
}


+ (BOOL)supportsQueryParametersForRequestMethod:(XMRequestMethod)method {
    return method == XMRequestMethodGET || method == XMRequestMethodDELETE || method == XMRequestMethodHEAD;
}

- (NSString *)contentTypeForRequest:(XMRequest *)request {
    NSString *contentType = nil;
    
    static NSString *charset = nil;
    static dispatch_once_t charsetToken;
    dispatch_once(&charsetToken, ^{
        charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    });
    
    switch (request.contentType) {
        case XMRequestContentTypeMultipart:
            contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
            break;
        case XMRequestContentTypeFormURLEncoded:
            contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset];
            break;
        case XMRequestContentTypeJSON:
            contentType = [NSString stringWithFormat:@"application/json; charset=%@", charset];
//            break;
//        case XMRequestContentTypeString:
//            contentType = [NSString stringWithFormat:@"application/json; charset=%@", charset];
//            break;
        default:
            
            break;
    }
    
    return contentType;
}

@end
