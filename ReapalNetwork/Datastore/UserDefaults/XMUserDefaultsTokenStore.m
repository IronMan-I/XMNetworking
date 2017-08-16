//
//  XMUserDefaultsTokenStore.m
//  PersonToPerson
//
//  Created by Crazy on 15/9/18.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMUserDefaultsTokenStore.h"
#import "XMAuthenticatedModel.h"

static NSString * const kUserDefaultsTokenKey = @"BAbelKitOAuthToken";

@implementation XMUserDefaultsTokenStore

- (instancetype)initWithService:(NSString *)service {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - XMTokenStore

- (void)storeToken:(XMAuthenticatedModel *)token {
    [XMUserDefaults setObject:token ForKey:kUserDefaultsTokenKey];
}

- (void)deleteStoredToken {
    [XMUserDefaults removeObjectForKey:kUserDefaultsTokenKey];
}

- (XMAuthenticatedModel *)storedToken {
    return [XMUserDefaults objectForKey:kUserDefaultsTokenKey];
}

@end
