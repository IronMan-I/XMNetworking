//
//  NSDictionary+XMQueryParameters.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XMQueryParameters)

- (NSString *)ba_queryString;
- (NSString *)ba_escapedQueryString;
- (NSDictionary *)ba_queryParametersPairs;
- (NSDictionary *)ba_escapedQueryParametersPairs;

@end
