//
//  BAModelValueTransformer.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMModelValueTransformer : NSValueTransformer

- (instancetype)initWithModelClass:(Class)modelClass;

+ (instancetype)transformerWithModelClass:(Class)modelClass;

@end
