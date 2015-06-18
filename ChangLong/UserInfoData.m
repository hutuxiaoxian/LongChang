//
//  UserInfoData.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "UserInfoData.h"

static UserInfoData *instancet;

@interface UserInfoData()

@end

@implementation UserInfoData
@synthesize isLogin;
@synthesize account;
@synthesize userID;

+ (UserInfoData *)getInstancet{
    if (!instancet) {
        instancet = [[UserInfoData alloc] init];
    }
    return instancet;
}
@end
