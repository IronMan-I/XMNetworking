//
//  NSError+XMErrors.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSError+XMErrors.h"
#import "NSDictionary+XMAdditions.h"

NSString * const XMServerErrorDomain = @"ErrorDomain";

NSString * const XMErrorKey = @"XMErrorKey";
NSString * const XMErrorDescriptionKey = @"XMErrorDescriptionKey";
NSString * const XMErrorDetailKey = @"XMErrorDetailKey";
NSString * const XMErrorParametersKey = @"XMErrorParametersKey";
NSString * const XMErrorPropagateKey = @"XMErrorPropagateKey";

@implementation NSError (XMErrors)

#pragma mark - Public

+ (NSError *)ba_serverErrorWithStatusCode:(NSUInteger)statusCode body:(id)body {
    return [NSError errorWithDomain:XMServerErrorDomain code:statusCode userInfo:[self ba_userInfoFromBody:body]];
}

- (BOOL)ba_isServerError {
    return [self.domain isEqualToString:XMServerErrorDomain] && self.code > 0;
}

- (NSString *)ba_localizedServerSideDescription {
    return [self ba_shouldPropagate] ? self.userInfo[XMServerErrorDomain] : nil;
}

#pragma mark - Private

- (BOOL)ba_shouldPropagate {
    return [self ba_isServerError] && [self.userInfo[XMServerErrorDomain] boolValue] == YES;
}

+ (NSDictionary *)ba_userInfoFromBody:(id)body {
    if (![body isKindOfClass:[NSDictionary class]]) return nil;
    
    NSDictionary *errorDict = body;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    NSString *error = [errorDict ba_nonNullObjectForKey:@"error"];
    NSString *errorDescription = [errorDict ba_nonNullObjectForKey:@"error_description"];
    NSString *errorDetail = [errorDict ba_nonNullObjectForKey:@"error_detail"];
    NSDictionary *errorParameters = [errorDict ba_nonNullObjectForKey:@"error_parameters"];
    NSNumber *errorPropagate = [errorDict ba_nonNullObjectForKey:@"error_propagate"];
    
    if (errorDescription && [errorPropagate boolValue]) userInfo[NSLocalizedDescriptionKey] = errorDescription;
    if (error) userInfo[XMErrorKey] = error;
    if (errorDescription) userInfo[XMErrorDescriptionKey] = errorDescription;
    if (errorDetail) userInfo[XMErrorDetailKey] = errorDetail;
    if (errorParameters) userInfo[XMErrorParametersKey] = errorParameters;
    if (errorPropagate) userInfo[XMErrorPropagateKey] = errorPropagate;
    
    return [userInfo copy];
}

@end
