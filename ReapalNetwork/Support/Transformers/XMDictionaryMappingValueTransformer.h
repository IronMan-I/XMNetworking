//
//  BADictionaryMappingValueTransformer.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMDictionaryMappingValueTransformer : NSValueTransformer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)transformerWithDictionary:(NSDictionary *)dictionary;

@end
