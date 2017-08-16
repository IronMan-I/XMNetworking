//
//  BAKeychainTokenStore.h
//  BAbelKit
//
//  Created by Crazy on 10/06/14.
//  Copyright (c) 2014 Abel, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMTokenStore.h"

@class XMKeychain;

@interface XMKeychainTokenStore : NSObject <XMTokenStore>

@property (nonatomic, strong, readonly) XMKeychain *keychain;

- (instancetype)initWithService:(NSString *)service;

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (instancetype)initWithKeychain:(XMKeychain *)keychain;

@end
