//
//  NSString+XMAdditions.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (XMAdditions)

+ (instancetype)ba_randomHexStringOfLength:(NSUInteger)length;

//生成指定长度的随机码,字母+数字
+ (NSString *)generateRadom:(int)size;

- (BOOL)ba_containsString:(NSString *)string;

- (NSString *)ba_base64String;

- (NSString *)unicodeString;

- (NSString *)encodeToPercentEscapeString: (NSString *) input;

- (NSString *)trim;

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)jsonStringWithObject:(id)object;

+ (NSString *)jsonStringWithArray:(NSArray *)array;

+ (NSString *)jsonStringWithString:(NSString *) string;

+ (NSString *)defaultCurrencyFormatString:(NSNumber *)number;

// 正常号转银行卡号 － 增加4位间的空格
- (NSString *)formatBankCardNumber;

// 银行卡号转正常号 － 去除4位间的空格
- (NSString *)bankNumToNormalNum;




@end
