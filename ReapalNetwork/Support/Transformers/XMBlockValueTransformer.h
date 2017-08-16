//
//  XMBlockValueTransformer.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^XMValueTransformationBlock) (id value);

@interface XMBlockValueTransformer : NSValueTransformer

- (instancetype)initWithBlock:(XMValueTransformationBlock)block;

+ (instancetype)transformerWithBlock:(XMValueTransformationBlock)block;

@end
