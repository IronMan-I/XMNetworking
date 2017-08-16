//
//  NSNumberFormatter(XMAdditions)
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//


#import "NSNumberFormatter+XMAdditions.h"

@implementation NSNumberFormatter (XMAdditions)

+ (NSNumberFormatter *)ba_USNumberFormatter {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;
    
    return formatter;
}

@end
