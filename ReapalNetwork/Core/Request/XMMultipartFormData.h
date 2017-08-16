//
//  XMMultipartFormData.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMultipartFormData : NSObject

@property (nonatomic, strong, readonly) NSData *finalizedData;
@property (nonatomic, copy, readonly) NSString *stringRepresentation;

+ (instancetype)multipartFormDataWithBoundary:(NSString *)boundary encoding:(NSStringEncoding)encoding;

- (void)appendFileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType name:(NSString *)name;

- (void)appendContentsOfFileAtPath:(NSString *)filePath name:(NSString *)name;

- (void)appendFormDataParameters:(NSDictionary *)parameters;

- (void)finalizeData;

@end
