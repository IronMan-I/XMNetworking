//
//  NSObject+XMIntrospection.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XMIntrospection)

+ (id)ba_valueByPerformingSelectorWithName:(NSString *)selectorName;

+ (id)ba_valueByPerformingSelectorWithName:(NSString *)selectorName withObject:(id)object;

@end
