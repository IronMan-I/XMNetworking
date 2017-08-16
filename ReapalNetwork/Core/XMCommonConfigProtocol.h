//
//  BACommonConfig.h
//  XMNetworking
//
//  Created by Crazy on 16/3/29.
//  Copyright © 2016年 abel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMCommonConfigProtocol <NSObject>

+ (NSDictionary *)commonParameters;

+ (NSDictionary *)headerCommonParameters;

+ (NSDictionary *)cookieCommonParameters;

@end
