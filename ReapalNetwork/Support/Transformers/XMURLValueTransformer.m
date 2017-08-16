//
//  XMURLValueTransformer.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMURLValueTransformer.h"

@implementation XMURLValueTransformer

- (instancetype)init {
    return [super initWithBlock:^id(NSString *URLString) {
        return [NSURL URLWithString:URLString];
    }];
}

@end
