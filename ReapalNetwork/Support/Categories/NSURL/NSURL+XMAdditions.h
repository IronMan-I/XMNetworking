//
//  NSURL+XMAdditions.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (XMAdditions)

- (NSURL *)ba_URLByAppendingQueryParameters:(NSDictionary *)parameters;

@end
