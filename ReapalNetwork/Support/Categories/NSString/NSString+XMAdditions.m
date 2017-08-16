//
//  NSString+XMAdditions.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSString+XMAdditions.h"

@implementation NSString (XMAdditions)

+ (instancetype)ba_randomHexStringOfLength:(NSUInteger)length {
    char data[length];
    
    for (NSUInteger i = 0; i < length; ++i) {
        u_int32_t rand = arc4random_uniform(36);
        data[i] = rand < 10 ? '0' + rand : 'a' + (rand - 10);
    }
    
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

+ (NSString *)generateRadom:(int)size{
    //static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned int)time(0));
    for (int i = 0; i < size; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
    
}

- (BOOL)ba_containsString:(NSString *)string {
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSString *)ba_base64String {
    NSData *data = [NSData dataWithBytes:[self UTF8String] length:[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    const uint8_t* input = (const uint8_t*)[data bytes];
    NSInteger length = [data length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* outputData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)outputData.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:outputData encoding:NSASCIIStringEncoding];
}

- (NSString *)unicodeString {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                     mutabilityOption:NSPropertyListImmutable
                                                               format:NULL
                                                     errorDescription:NULL];
#pragma clang diagnostic pop
    } else {
        returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    }
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             NULL, /* allocator */
                                                                             (__bridge CFStringRef)input,
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             kCFStringEncodingUTF8);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
//        
//    } else {
//        NSString *unreserved = @"!*'();:@&=+$,/?%#[]";
//        NSMutableCharacterSet *allowed = [NSMutableCharacterSet
//                                          alphanumericCharacterSet];
//        [allowed addCharactersInString:unreserved];
//        outputStr = [input stringByAddingPercentEncodingWithAllowedCharacters:allowed];
//    }
    
    return outputStr;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *)jsonStringWithObject:(id)object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

+ (NSString *)jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (NSString *)jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *)defaultCurrencyFormatString:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    NSString *formatted = [formatter stringFromNumber:number];
    return [NSString stringWithFormat:@"%@", formatted];
}

// 正常号转银行卡号 － 增加4位间的空格
- (NSString *)formatBankCardNumber {
    NSString *tmpStr = [self bankNumToNormalNum];
    NSInteger size = (tmpStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0; n < size; n++) {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}

// 银行卡号转正常号 － 去除4位间的空格
- (NSString *)bankNumToNormalNum {
    if (!self) {
        return nil;
    }
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
