//
//  XMBlockValueTransformer.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMBlockValueTransformer.h"

@interface XMBlockValueTransformer ()

@property (nonatomic, copy) XMValueTransformationBlock transformBlock;

@end

@implementation XMBlockValueTransformer

- (instancetype)init {
    return [self initWithBlock:nil];
}

- (instancetype)initWithBlock:(XMValueTransformationBlock)block {
    self = [super init];
    if (!self) return nil;
    
    _transformBlock = [block copy];
    
    return self;
}

+ (instancetype)transformerWithBlock:(XMValueTransformationBlock)block {
    return [[self alloc] initWithBlock:block];
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    return self.transformBlock ? self.transformBlock(value) : nil;
}

@end
