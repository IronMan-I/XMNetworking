//
//  BAConstants.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#ifndef BAConstants_h
#define BAConstants_h

typedef NS_ENUM(NSUInteger, BAErrorCode) {
    BAErrorCodeUnknown = 1000,
    BAErrorCodeRequestFailed,
    BAErrorCodeAut = 10001,
};


static NSString *XMCodeSuccess = @"0000";  //成功
static NSString *XMCodeBindCardListNull = @"3075"; //用户于指定的银行卡无绑卡关系
static NSString *XMCodeParametersError = @"1002"; //传入参数错误或非法请求（参数错误，有必要参数为空）

#endif /* BAConstants_h */
