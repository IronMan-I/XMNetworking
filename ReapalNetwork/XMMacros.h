//
//  XMMacros.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#define XM_STRONG(obj) __typeof__(obj)
#define XM_WEAK(obj) __typeof__(obj) __weak
#define XM_WEAK_SELF XM_WEAK(self)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#define XM_IOS_SDK_AVAILABLE 1
#else
#define XM_IOS_SDK_AVAILABLE 0
#endif


#ifdef DEBUG
#define debug(format, ...)  NSLog(format, ## __VA_ARGS__)
#else
#define debug(format, ...)
#endif

#ifndef kDefaultBaseURL
#define kDefaultBaseURL

static NSString * const kDefaultBaseURLString = @"http://api.reapal.com/";

#endif
