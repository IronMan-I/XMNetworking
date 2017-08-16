//
//  NSError+XMErrors.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XMServerErrorDomain;

extern NSString * const XMErrorKey;
extern NSString * const XMErrorDescriptionKey;
extern NSString * const XMErrorDetailKey;
extern NSString * const XMErrorParametersKey;
extern NSString * const XMErrorPropagateKey;

@interface NSError (XMErrors)

+ (NSError *)ba_serverErrorWithStatusCode:(NSUInteger)statusCode body:(id)body;

- (BOOL)ba_isServerError;

- (NSString *)ba_localizedServerSideDescription;

@end
