//
//  BAKeychainTokenStore.m
//  BAbelKit
//
//  Created by Crazy on 10/06/14.
//  Copyright (c) 2014 Abel, Inc. All rights reserved.
//

#import "XMKeychainTokenStore.h"
#import "XMKeychain.h"

static NSString * const kTokenKeychainKey = @"BAbelKitOAuthToken";

@interface XMKeychainTokenStore ()

@end

@implementation XMKeychainTokenStore

- (instancetype)initWithService:(NSString *)service {
    return [self initWithService:service accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup {
    XMKeychain *keychain = [XMKeychain keychainForService:service accessGroup:accessGroup];
    return [self initWithKeychain:keychain];
}

- (instancetype)initWithKeychain:(XMKeychain *)keychain {
    self = [super init];
    if (!self) return nil;
    
    _keychain = keychain;
    
    return self;
}

#pragma mark - BATokenStore

- (void)storeToken:(XMAuthenticatedModel *)token {
    [self.keychain setObject:token ForKey:kTokenKeychainKey];
}

- (void)deleteStoredToken {
    [self.keychain removeObjectForKey:kTokenKeychainKey];
}

- (XMAuthenticatedModel *)storedToken {
    return [self.keychain objectForKey:kTokenKeychainKey];
}

@end
