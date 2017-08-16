//
//  NSMutableURLRequest+XMHeaders.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (XMHeaders)

- (void)ba_setAuthorizationHeaderWithOAuth2AccessToken:(NSString *)accessToken;
- (void)ba_setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password;

@end
