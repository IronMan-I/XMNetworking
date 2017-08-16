//
//  BAOAuth2Token.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMAuthenticatedModel.h"
#import "NSValueTransformer+XMTransformers.h"

@implementation XMAuthenticatedModel

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) return NO;
    
    return [self.accessToken isEqualToString:[object accessToken]];
}

- (NSUInteger)hash {
    return [self.accessToken hash];
}

#pragma mark - BAModel

+ (NSDictionary *)dictionaryKeyPathsForPropertyNames {
    return @{
             @"accessToken": @"token",
             };
}

+ (NSValueTransformer *)expiresOnValueTransformer {
    return [NSValueTransformer ba_transformerWithBlock:^id(NSNumber *expiresIn) {
        return [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
    }];
}

#pragma mark - Public

- (BOOL)willExpireWithinIntervalFromNow:(NSTimeInterval)expireInterval {
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:expireInterval];
//    return [self.expiresOn earlierDate:date] == self.expiresOn;
    return NO;
}

@end
