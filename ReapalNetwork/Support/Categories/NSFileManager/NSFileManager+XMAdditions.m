//
//  NSFileManager+XMAdditions.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSFileManager+XMAdditions.h"

@implementation NSFileManager (XMAdditions)

- (BOOL)ba_moveItemAtURL:(NSURL *)fromURL toPath:(NSString *)toPath withIntermediateDirectories:(BOOL)withIntermediateDirectories error:(NSError **)error {
    NSURL *toURL = [NSURL fileURLWithPath:toPath];
    
    return [self ba_moveItemAtURL:fromURL toURL:toURL withIntermediateDirectories:withIntermediateDirectories error:error];
}

- (BOOL)ba_moveItemAtPath:(NSString *)fromPath toURL:(NSURL *)toURL withIntermediateDirectories:(BOOL)withIntermediateDirectories error:(NSError **)error {
    NSURL *fromURL = [NSURL fileURLWithPath:fromPath];
    
    return [self ba_moveItemAtURL:fromURL toURL:toURL withIntermediateDirectories:withIntermediateDirectories error:error];
}

- (BOOL)ba_moveItemAtURL:(NSURL *)fromURL toURL:(NSURL *)toURL withIntermediateDirectories:(BOOL)withIntermediateDirectories error:(NSError **)error {
    BOOL success = YES;
    
    NSString *directoryPath = [toURL.path stringByDeletingLastPathComponent];
    NSURL *directoryURL = [NSURL fileURLWithPath:directoryPath];
    
    success = [self createDirectoryAtURL:directoryURL withIntermediateDirectories:withIntermediateDirectories attributes:nil error:error];
    if (success) {
        if ([self fileExistsAtPath:toURL.path]) {
            [self removeItemAtURL:toURL error:nil];
        }
        
        success = [self moveItemAtURL:fromURL toURL:toURL error:error];
    }
    
    return success;
}

@end
