//
//  Request.h
//  ChangLong
//
//  Created by 糊涂 on 15/3/10.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Connect.h"

#define HostName @"http://120.55.73.239:8001/SBService.aspx"
enum requestType{
    JINSHICHAXUN = 1,
    TYPEINFO,
    ZONGHEINFO,
    STATELIST,
    STATEFLOWINFO,
    IMGBYTE,
    FENLEILISTALL,
    FENLEILISTCHAXUN,
    SETREGISTERUSER,
    GETLOGNUSER,
    GOODSIMGINFO,
    GETBARCODEINFO,
    USERLOGIN,
    REGISTER,
    GETISBUYSTATUS,
    GONGGAO
};

@interface Request : NSObject

@property (nonatomic, strong)NSObject<ResponseDelegate> *delegate;
- (id)initWithDelegate:(NSObject<ResponseDelegate>*)delegat;

- (void)request:(NSString*)url type:(int)type;

- (NSString*)jinsichaxun:(NSString*)type typeName:(NSString*)typeName TabNum:(NSString*)tabNum start:(int)start end:(int)end;
- (NSString*)jinshichaxun:(NSString*)type typeName:(NSString*)typeName TabNum:(NSString*)tabNum start:(int)start end:(int)end;

- (void)typeInfo:(int)flType FlName:(NSString*)flName;

/**
 * 商标综合查询
 * @param TabNum	国际分类号
 * @param RegNO		注册号/申请号
 * @param SPName	商标名称
 * @param SQNameCN	申请人名称(中文)
 * @param SQNameEN	申请人名称(英文)
 */
- (NSString*)zongHeInfoWithRegNO:(NSString*)regNO Sbmc:(NSString*)Sbmc applicant:(NSString*)applicant Intcls:(NSString*)Intcls type:(NSInteger)type start:(int)start end:(int)end ;

/**
 * 商标状态查询
 * @param RegNO	注册号/申请号
 */
- (void)stateList:(NSString*)regNO;
/**
 * 商标流程
 * @param TabNum	国际分类号
 * @param RegNO		注册号/申请号
 */
- (void)stateFlowInfo:(NSString*)tabNum regNO:(NSString*)regNO;
/**
 * 公告
 * @param RegNO		注册号/申请号
 */
- (void)gonggao:(NSString*)regNO;
/**
 * 查询二进制图片  返回byte[](byte)
 * @param RegNO 注册号/申请号
 */
- (void)imgByte:(NSString*)regNO;
/**
 * 商品分类列表
 */
- (void)fenLeiListAll;
- (void)fenleiSousuo:(NSString *)content start:(int)start end:(int)end;

/**
 * 注册用户 注册成功返回1 注册失败返回0
 */
- (void)setRegisterUser:(NSString*) UserName PassWord:(NSString*)PassWord;

/**
 * 用户登录 登录成功返回1；登录失败返回0；
 */

- (void)getLoginUser:(NSString*) UserName PassWord:(NSString*)PassWord;

/**
 * 商标图像、服务列表、类似群 查询
 */
- (void)goodsImgInfo;
/**
 * 根据条形码获取商标数据
 * @param BarCode 条码
 */
- (NSString*)getBarCodeInfo:(NSString*)barCode;

- (void)getIsBuyStatus:(NSString*)userID;

@end
