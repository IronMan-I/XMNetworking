//
//  XMResponseSerializer.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMResponseSerializer : NSObject

- (id)responseObjectForURLResponse:(NSURLResponse *)response data:(NSData *)data;

@end
