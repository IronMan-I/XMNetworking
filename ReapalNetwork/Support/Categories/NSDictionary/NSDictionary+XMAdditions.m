//
//  NSDictionary+XMAdditions.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSDictionary+XMAdditions.h"

@implementation NSDictionary (XMAdditions)

- (id)ba_nonNullObjectForKey:(id)key {
    id value = self[key];
    if (value == [NSNull null]) {
        value = nil;
    }
    
    return value;
}

@end
