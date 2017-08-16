//
//  XMResponse.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, copy, readonly) id body;

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body;

@end
