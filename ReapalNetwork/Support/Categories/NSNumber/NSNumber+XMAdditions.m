//
//  NSNumber(XMAdditions)
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//


#import "NSNumber+XMAdditions.h"
#import "NSNumberFormatter+XMAdditions.h"

static NSNumberFormatter *sNumberFormatter = nil;

@implementation NSNumber (XMAdditions)

+ (NSNumber *)ba_numberFromUSNumberString:(NSString *)numberString {
    return [[self ba_USNumberFormatter] numberFromString:numberString];
}

- (NSString *)ba_USNumberString {
    return [[[self class] ba_USNumberFormatter] stringFromNumber:self];
}

+ (NSNumberFormatter *)ba_USNumberFormatter {
    if (!sNumberFormatter) {
        sNumberFormatter = [NSNumberFormatter ba_USNumberFormatter];
    }
    
    return sNumberFormatter;
}

@end
