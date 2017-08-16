//
//  XMAuthenticationAPI.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMAuthenticationAPI.h"

@implementation XMAuthenticationAPI

+ (XMRequest *)requestForAuthenticationWithEmail:(NSString *)email password:(NSString *)password {
    return [XMRequest POSTRequestWithPath:@"hello" parameters:nil];
}


+ (XMRequest *)requestForAuthenticationWithTransferToken:(NSString *)transferToken {
    return nil;
}

+ (XMRequest *)requestToRefreshToken:(NSString *)refreshToken {
    return nil;
}

@end
