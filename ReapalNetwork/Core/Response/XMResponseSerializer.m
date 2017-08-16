//
//  XMResponseSerializer.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMResponseSerializer.h"
#import "NSString+XMAdditions.h"

@implementation XMResponseSerializer

- (id)responseObjectForURLResponse:(NSURLResponse *)response data:(NSData *)data {
    if (data == nil || ![response isKindOfClass:[NSHTTPURLResponse class]]) return nil;
    
    id object = nil;
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    if ([HTTPResponse.allHeaderFields[@"Content-Type"] ba_containsString:@"application/json"]) {
        NSError *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            object = data;
        }
    } else {
        object = data;
    }
    
    return object;
}

@end
