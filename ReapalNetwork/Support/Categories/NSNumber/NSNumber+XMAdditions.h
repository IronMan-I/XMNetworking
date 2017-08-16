//
//  NSNumber(XMAdditions) 
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSNumber (XMAdditions)

+ (NSNumber *)ba_numberFromUSNumberString:(NSString *)numberString;
- (NSString *)ba_USNumberString;

@end
