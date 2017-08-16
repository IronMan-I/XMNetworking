//
//  XMNetworking.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMNetworking.h"
#import "XMClient.h"
#import "XMKeychainTokenStore.h"
#import "XMUserDefaultsTokenStore.h"

@implementation XMNetworking

+ (XMAsyncTask *)authenticateAsUserWithAccount:(NSString *)account password:(NSString *)password {
    return [[XMClient currentClient] authenticateAsUserWithEmail:account password:password];
}

+ (BOOL)isAuthenticated {
    return [[XMClient currentClient] isAuthenticated];
}

+ (void)setupAuthenticatedHandlerClass:(Class)className authenticatedAPIClass:(Class)apiName {
    [[XMClient currentClient] setupAuthenticatedHandlerClass:className authenticatedAPIClass:apiName];
}

+ (void)setupCommonParametersClass:(Class)commonClass {
    [[XMClient currentClient] setupCommonParametersClass:commonClass];
}

+ (void)setupUserAgent:(NSString *)userAgent {
    [[XMClient currentClient] setupUserAgent:userAgent];
}

+ (void)setDebugEnabled:(BOOL)value {
    [[XMClient currentClient] setDebugEnabled:value];
}

+ (void)automaticallyStoreTokenInKeychainForServiceWithName:(NSString *)name {
    [XMClient currentClient].tokenStore = [[XMKeychainTokenStore alloc] initWithService:name];
    [[XMClient currentClient] restoreTokenIfNeeded];
}

+ (void)automaticallyStoreTokenInKeychainForCurrentApp {
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge id)kCFBundleIdentifierKey];
    [self automaticallyStoreTokenInKeychainForServiceWithName:name];
}

+ (void)automaticallyStoreTokenInUserDefaultsForServiceWithName:(NSString *)name {
    [XMClient currentClient].tokenStore = [[XMUserDefaultsTokenStore alloc] initWithService:name];
    [[XMClient currentClient] restoreTokenIfNeeded];
}

+ (void)automaticallyStoreTokenInUserDefaultsForCurrentApp {
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge id)kCFBundleIdentifierKey];
    [self automaticallyStoreTokenInUserDefaultsForServiceWithName:name];
}

@end
