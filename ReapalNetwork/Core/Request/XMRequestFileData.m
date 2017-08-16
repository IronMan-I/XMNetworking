//
//  XMRequestFileData.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMRequestFileData.h"

@implementation XMRequestFileData

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName {
    self = [super init];
    if (!self) return nil;
    
    _data = data;
    _name = [name copy];
    _fileName = [fileName copy];
    
    return self;
}

- (instancetype)initWithFilePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName {
    self = [super init];
    if (!self) return nil;
    
    _filePath = [filePath copy];
    _name = [name copy];
    _fileName = [fileName copy];
    
    return self;
}

+ (instancetype)fileDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName {
    return [[self alloc] initWithData:data name:name fileName:fileName];
}

+ (instancetype)fileDataWithFilePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName {
    return [[self alloc] initWithFilePath:filePath name:name fileName:fileName];
}

@end
