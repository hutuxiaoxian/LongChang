//
//  Request.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/10.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "Request.h"

@interface Request()
@property (nonatomic, strong)Connect *conn;
@end


@implementation Request
@synthesize conn;
@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        conn = [Connect getInstance];
    }
    
    return self;
}

- (id)initWithDelegate:(NSObject<ResponseDelegate>*)delegat{
    self = [super init];
    if (self) {
        conn = [Connect getInstance];
        delegate = delegat;
    }
    return self;
}

- (NSString *)urlEncod:(NSString*)code{
    return [code stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)request:(NSString *)url type:(int)type{
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:type];
    }
}

- (NSString*)jinsichaxun:(NSString*)type typeName:(NSString*)typeName TabNum:(NSString*)tabNum start:(int)start end:(int)end{
    
    NSString *url = [NSString stringWithFormat:@"%@?method=SBJinSiChaXun&TabNum=%@&TypeName=%@&type=%@&IsHuanXu=0&IsJhz=0&IsRyjhz=0&IsNhqtbq=0&IsWqxt=0&IsBfxt=0&IsBhz=0&IsDyxt=0&IsNx=0&Start=%d&End=%d", HostName, tabNum ,typeName, type, start, end];
    url = [self urlEncod:url];
    NSLog(@"近似URL:%@",url);
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:JINSHICHAXUN];
    }
    return url;
    
}
- (NSString*)jinshichaxun:(NSString*)type typeName:(NSString*)typeName TabNum:(NSString*)tabNum start:(int)start end:(int)end{
    
    NSString *url = [NSString stringWithFormat:@"%@?method=SBJinSiChaXun&TabNum=%@&TypeName=%@&type=%@&IsHuanXu=1&IsJhz=1&IsRyjhz=1&IsNhqtbq=1&IsWqxt=1&IsBfxt=1&IsBhz=1&IsDyxt=1&IsNx=1&Start=%d&End=%d", HostName, tabNum ,typeName, type, start, end];
    url = [self urlEncod:url];
    NSLog(@"近似URL:%@",url);
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:JINSHICHAXUN];
    }
    return url;
}

- (void)typeInfo:(int)flType FlName:(NSString*)flName{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBTypeInfo", HostName];
    
    if (flName && flName.length > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&FlName=%@", flName]];
    } else {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&FlType=%d", flType]];
    }
    url = [self urlEncod:url];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:TYPEINFO];
    }
}

/**
 * 商标综合查询
 * @param TabNum	国际分类号
 * @param RegNO		注册号/申请号
 * @param SPName	商标名称
 * @param SQNameCN	申请人名称(中文)
 * @param SQNameEN	申请人名称(英文)
 */
- (NSString*)zongHeInfoWithRegNO:(NSString*)regNO Sbmc:(NSString*)Sbmc applicant:(NSString*)applicant Intcls:(NSString*)Intcls type:(NSInteger)type start:(int)start end:(int)end{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBZongHeInfo", HostName];
//    if (tabNum != nil) {
//        url = [NSString stringWithFormat:@"%@&TabNum=%@", url, tabNum];
//    }
    url = [NSString stringWithFormat:@"%@&type=%ld", url, (long)type];

    if (regNO != nil && [regNO length] > 0) {
        url = [NSString stringWithFormat:@"%@&RegNO=%@", url, regNO];
    }
    
    if (Sbmc != nil && [Sbmc length] > 0) {
        url = [NSString stringWithFormat:@"%@&Sbmc=%@", url, Sbmc];
    }
    
    if (applicant != nil && [applicant length] > 0) {
        url = [NSString stringWithFormat:@"%@&applicant=%@", url, applicant];
    }
    
    if (Intcls != nil && [Intcls length] > 0) {
        url = [NSString stringWithFormat:@"%@&Intcls=%@", url, Intcls];
    }
    
    url = [NSString stringWithFormat:@"%@&Start=%d", url, start];
    url = [NSString stringWithFormat:@"%@&End=%d", url, end];
    url = [self urlEncod:url];
    
    
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:ZONGHEINFO];
    }
    return url;
}

/**
 * 商标状态查询
 * @param RegNO	注册号/申请号
 */
- (void)stateList:(NSString*)regNO{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBStateList&RegNO=%@", HostName, regNO];
    url = [self urlEncod:url];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:STATELIST];
    }
}

/**
 * 商标流程
 * @param TabNum	国际分类号
 * @param RegNO		注册号/申请号
 */
- (void)stateFlowInfo:(NSString*)tabNum regNO:(NSString*)regNO{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBStateFlowInfo&RegNO=%@&TabNum=%@", HostName, regNO, tabNum];
    url = [self urlEncod:url];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:STATEFLOWINFO];
    }
}
/**
 * 查询二进制图片  返回byte[](byte)
 * @param RegNO 注册号/申请号
 */
- (void)imgByte:(NSString*)regNO{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBImgByte&RegNO=%@", HostName, regNO];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:IMGBYTE];
    }
}
/**
 * 公告
 * @param RegNO		注册号/申请号
 */
- (void)gonggao:(NSString*)regNO{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBBulletinHzList&RegNO=%@", HostName, regNO];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:GONGGAO];
    }
}

/**
 * 商品分类列表
 */
- (void)fenLeiListAll{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBFenLeiListAll", HostName];
    
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:FENLEILISTALL];
    }
}

- (void)fenleiSousuo:(NSString *)content start:(int)start end:(int)end{
    NSString *url = [NSString stringWithFormat:@"%@?method=GetDetailInfo&DetailName=%@&Start=%d&End=%d ", HostName, content, start, end];
    
    url = [self urlEncod:url];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:FENLEILISTCHAXUN];
    }
}
/**
 * 注册用户 注册成功返回1 注册失败返回0
 */
- (void)setRegisterUser:(NSString*) UserName PassWord:(NSString*)PassWord{
    
    NSString *url = [NSString stringWithFormat:@"%@?method=SetRegisterUser&UserName=%@&PassWord=%@", HostName, UserName, PassWord];
    
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:REGISTER];
    }
}

/**
 * 用户登录 登录成功返回1；登录失败返回0；
 */
- (void)getLoginUser:(NSString*) UserName PassWord:(NSString*)PassWord {
    NSString *url = [NSString stringWithFormat:@"%@?method=GetLognUser&UserName=%@&PassWord=%@", HostName, UserName, PassWord];
    
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:USERLOGIN];
    }
}

/**
 * 商标图像、服务列表、类似群 查询
 */
- (void)goodsImgInfo{
    NSString *url = [NSString stringWithFormat:@"%@?method=SBGoodsImgInfo", HostName];
    
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:GOODSIMGINFO];
    }
}
/**
 * 根据条形码获取商标数据
 * @param BarCode 条码
 */
- (void)getBarCodeInfo:(NSString*)barCode{
    
    NSString *url = [NSString stringWithFormat:@"%@?method=GetBarCodeInfo&BarCode=%@", HostName, barCode];
    
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:GETBARCODEINFO];
    }
}

- (void)getIsBuyStatus:(NSString *)userID{

    NSString *url = [NSString stringWithFormat:@"%@?method=GetIsBuyState&userid=%@", HostName, userID];
    if (delegate && [delegate respondsToSelector:@selector(responseDate:Type:)]) {
        [conn getConnectWithURL:url delegate:delegate type:GETISBUYSTATUS];
    }
}

@end
