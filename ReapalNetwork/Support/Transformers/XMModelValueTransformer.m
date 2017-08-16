//
//  BAModelValueTransformer.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMModelValueTransformer.h"
#import "XMModel.h"

@interface XMModelValueTransformer ()

@property (nonatomic, strong) Class modelClass;

@end

@implementation XMModelValueTransformer

- (instancetype)init {
    return [self initWithModelClass:nil];
}

- (instancetype)initWithModelClass:(Class)modelClass {
    self = [super init];
    if (!self) return nil;
    
    // NOTE: Class casting workaround for incompatability with Swift, where -isSubclassOfClass return
    // NO when using [BAModel class] directly.
    NSParameterAssert([NSClassFromString(NSStringFromClass(modelClass)) isSubclassOfClass:NSClassFromString(NSStringFromClass([XMModel class]))]);
    _modelClass = modelClass;
    
    return self;
}

+ (instancetype)transformerWithModelClass:(Class)modelClass {
    return [[self alloc] initWithModelClass:modelClass];
}

#pragma mark - NSValueTransformer

- (id)transformedValue:(id)value {
    id transformedValue = nil;
    
    if ([value isKindOfClass:[NSArray class]]) {
        // Many objects
        NSArray *objects = value;
        
        NSMutableArray *modelObjects = [NSMutableArray array];
        
        for (id dict in objects) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                id modelObject = [self modelObjectFromDictionary:dict];
                if (modelObject) {
                    [modelObjects addObject:modelObject];
                }
            }
        }
        
        transformedValue = [modelObjects copy];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        // Single object
        transformedValue = [self modelObjectFromDictionary:value];
    }
    
    return transformedValue;
}

- (id)modelObjectFromDictionary:(NSDictionary *)dictionary {
    return [[self.modelClass alloc] initWithDictionary:dictionary];
}

@end
