//
//  NSString+XMURLEncode.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSString+XMURLEncode.h"

@implementation NSString (XMURLEncode)

- (NSString *)ba_encodeString {
  NSString *escapedString = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                   (__bridge CFStringRef)self,
                                                                                                   NULL,
                                                                                                   (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                                   kCFStringEncodingUTF8);
  return escapedString;
}

- (NSString *)ba_decodeString {
  NSString *escapedString = (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                   (__bridge CFStringRef)self,
                                                                                                                   CFSTR(""),
                                                                                                                   kCFStringEncodingUTF8);
  return escapedString;
}

@end
