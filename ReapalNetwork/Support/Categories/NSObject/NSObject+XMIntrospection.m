//
//  NSObject+XMIntrospection.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+XMIntrospection.h"

@implementation NSObject (XMIntrospection)

+ (id)ba_valueByPerformingSelectorWithName:(NSString *)selectorName {
    return [self ba_valueByPerformingSelectorWithName:selectorName withObject:nil];
}

+ (id)ba_valueByPerformingSelectorWithName:(NSString *)selectorName withObject:(id)object {
    id value = nil;
    
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        value = [self performSelector:selector withObject:object];
#pragma clang diagnostic pop
    }
    
    return value;
}

@end
