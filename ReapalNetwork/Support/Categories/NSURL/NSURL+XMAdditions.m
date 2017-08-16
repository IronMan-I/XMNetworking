//
//  NSURL+XMAdditions.m
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "NSURL+XMAdditions.h"
#import "NSString+XMAdditions.h"
#import "NSDictionary+XMQueryParameters.h"

@implementation NSURL (XMAdditions)

- (NSURL *)ba_URLByAppendingQueryParameters:(NSDictionary *)parameters {
  if ([parameters count] == 0) return self;
  
  NSMutableString *query = [NSMutableString stringWithString:self.absoluteString];
  
  if (![query ba_containsString:@"?"]) {
    [query appendString:@"?"];
  } else {
    [query appendString:@"&"];
  }
  
  [query appendString:[parameters ba_escapedQueryString]];
  
  return [NSURL URLWithString:[query copy]];
}

@end
