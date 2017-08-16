//
//  XMTokenStore.h
//  XMNetworking
//
//  Created by Crazy on 15/9/6.
//  Copyright © 2015年 Crazy. All rights reserved.
//

#import "XMAuthenticatedModel.h"

@protocol XMTokenStore <NSObject>

- (void)storeToken:(XMAuthenticatedModel *)token;

- (void)deleteStoredToken;

- (XMAuthenticatedModel *)storedToken;

@end
