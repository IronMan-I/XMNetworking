//
//  XMSecurity.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMSecurity : NSObject

- (BOOL)evaluateServerTrust:(SecTrustRef)trust;

@end
