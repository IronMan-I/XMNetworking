//
//  XMAuthenticationAPI.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMBaseAPI.h"

@interface XMAuthenticationAPI : XMBaseAPI

+ (XMRequest *)requestForAuthenticationWithEmail:(NSString *)email password:(NSString *)password;

+ (XMRequest *)requestForAuthenticationWithTransferToken:(NSString *)transferToken;

+ (XMRequest *)requestToRefreshToken:(NSString *)refreshToken;

@end
