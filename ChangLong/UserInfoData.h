//
//  UserInfoData.h
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoData : NSObject

@property (nonatomic, strong)NSString *account;
@property (nonatomic, assign)BOOL *isLogin;
@property (nonatomic, strong)NSString *userID;

+ (UserInfoData*)getInstancet;
@end
