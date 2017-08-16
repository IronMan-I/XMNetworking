//
//  NSDateFormatter+XMAdditions.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSDateFormatter+XMAdditions.h"

@implementation NSDateFormatter (XMAdditions)

+ (NSDateFormatter *)ba_UTCDateFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-MM-dd";
  formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
  
  return formatter;
}

+ (NSDateFormatter *)ba_UTCDateTimeFormatter {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
  
  return formatter;
}

@end
