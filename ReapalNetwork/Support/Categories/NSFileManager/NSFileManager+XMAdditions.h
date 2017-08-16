//
//  NSFileManager+XMAdditions.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (XMAdditions)

- (BOOL)ba_moveItemAtURL:(NSURL *)fromURL toPath:(NSString *)toPath withIntermediateDirectories:(BOOL)withIntermediateDirectories error:(NSError **)error;

- (BOOL)ba_moveItemAtPath:(NSString *)fromPath toURL:(NSURL *)toURL withIntermediateDirectories:(BOOL)withIntermediateDirectories error:(NSError **)error;

- (BOOL)ba_moveItemAtURL:(NSURL *)fromURL toURL:(NSURL *)toURL withIntermediateDirectories:(BOOL)withIntermediateDirectories error:(NSError **)error;

@end
