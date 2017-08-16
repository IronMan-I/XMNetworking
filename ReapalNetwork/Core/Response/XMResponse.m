//
//  XMResponse.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMResponse.h"

@implementation XMResponse

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body {
    self = [super init];
    if (!self) return nil;
    
    _statusCode = statusCode;
    _body = body;
    
    return self;
}

@end
