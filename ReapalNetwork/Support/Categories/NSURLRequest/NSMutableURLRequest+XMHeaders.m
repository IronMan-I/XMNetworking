//
//  NSMutableURLRequest+XMHeaders.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSMutableURLRequest+XMHeaders.h"
#import "NSString+XMAdditions.h"

static NSString * const kHeaderAuthorization = @"Authorization";
static NSString * const kAuthorizationOAuth2AccessTokenFormat = @"OAuth2 %@";

@implementation NSMutableURLRequest (XMHeaders)

- (void)ba_setAuthorizationHeaderWithOAuth2AccessToken:(NSString *)accessToken {
  NSString *value = [NSString stringWithFormat:kAuthorizationOAuth2AccessTokenFormat, accessToken];
  [self setValue:value forHTTPHeaderField:kHeaderAuthorization];
}

- (void)ba_setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password {
  NSString *authString = [NSString stringWithFormat:@"%@:%@", username, password];
  [self setValue:[NSString stringWithFormat:@"Basic %@", [authString ba_base64String]] forHTTPHeaderField:@"Authorization"];
}

@end
