//
//  XMUserDefaults.h
//  PersonToPerson
//
//  Created by Crazy on 15/9/17.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMUserDefaults : NSObject

+ (id)objectForKey:(id)key;

+ (BOOL)setObject:(id<NSCoding>)object ForKey:(id)key;

+ (void)removeObjectForKey:(id)key;

- (instancetype)initWithService:(NSString *)service;

@end
