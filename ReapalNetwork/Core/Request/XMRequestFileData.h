//
//  XMRequestFileData.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMRequestFileData : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *fileName;

+ (instancetype)fileDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName;

+ (instancetype)fileDataWithFilePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName;


@end
