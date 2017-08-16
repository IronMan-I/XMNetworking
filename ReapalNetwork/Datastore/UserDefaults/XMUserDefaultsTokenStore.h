//
//  XMUserDefaultsTokenStore.h
//  PersonToPerson
//
//  Created by Crazy on 15/9/18.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMUserDefaults.h"
#import "XMTokenStore.h"

@interface XMUserDefaultsTokenStore : NSObject <XMTokenStore>

@property (nonatomic, strong, readonly) XMUserDefaults *keychain;

- (instancetype)initWithService:(NSString *)service;

@end
