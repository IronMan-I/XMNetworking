//
//  NSValueTransformer+XMTransformers.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSValueTransformer+XMTransformers.h"
#import "XMConstants.h"
#import "XMNumberValueTransformer.h"
#import "XMURLValueTransformer.h"
#import "XMModelValueTransformer.h"

@implementation NSValueTransformer (XMTransformers)

+ (NSValueTransformer *)ba_transformerWithBlock:(XMValueTransformationBlock)block {
    return [XMBlockValueTransformer transformerWithBlock:block];
}

+ (NSValueTransformer *)ba_transformerWithModelClass:(Class)modelClass {
    return [XMModelValueTransformer transformerWithModelClass:modelClass];
}

+ (NSValueTransformer *)ba_URLTransformer {
    return [XMURLValueTransformer new];
}


+ (NSValueTransformer *)ba_numberValueTransformer {
    return [XMNumberValueTransformer new];
}

@end
