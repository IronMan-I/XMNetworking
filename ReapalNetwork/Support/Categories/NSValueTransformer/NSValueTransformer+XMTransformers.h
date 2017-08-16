//
//  NSValueTransformer+XMTransformers.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMBlockValueTransformer.h"

@interface NSValueTransformer (XMTransformers)

+ (NSValueTransformer *)ba_transformerWithBlock:(XMValueTransformationBlock)block;

+ (NSValueTransformer *)ba_transformerWithModelClass:(Class)modelClass;

@end
