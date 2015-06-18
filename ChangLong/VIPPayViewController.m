//
//  VIPPayViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/27.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "VIPPayViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UserInfoData.h"
#import "Request.h"

#import "APAuthV2Info.h"

@interface VIPPayViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UITextField *edit;

@end

@implementation VIPPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"支付"];
    [[self.edit layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.edit layer] setBorderWidth:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payClick:(id)sender {
    NSString *str = [[self.edit text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str length] > 0 && [str doubleValue] > 0 ) {
//        [self orderPay:[str doubleValue]];
        [self orderPay:500.00];
    }
}

- (void)orderPay:(double)money{
    NSString *partner = @"2088812105749241";
    NSString *seller = @"635657188@qq.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANpL53VWOFUrfZm8lu3ylTAW8PXP17mKYdTTM4NQqmO8LBHMZh6arGq8QqrftBtLu2Vs9MeIDWQmIr/O4ik2dN52+m1bNM0LtrIlcsSPrDr6dMH7FRaIN4KrNkaxPtonCtAj1sm2hW4+nVdkxgFp15SfasL5fJKJkOXyG0L31szVAgMBAAECgYBlI53Ng3D+JPRAclwLSsVMTpS9jtqIIFFLZb8MLCeFpf1VEbqOm2Me4LKSsKqlquTcDSsr9yEdMX4QGC44of5q6GETgO2xj41+IJ3elUKGmmrPuMzaQsAHoCT5BJw0bS1ku5E75EUUqTbM+NJbd112lBiAxqZXlURF7WTTik6CAQJBAP3T+cxOeTWoMvau7N6o47orSACE9EpMeehL+2gAGhsiV/Z+mmj2YA4Nj/bQ3BQ/QgJXirkRBezaVMTv9RCwPPUCQQDcKhg3YB487FqS/kJvi43GbgPykMhNi/rDr5IPS/YYPFvofzVLDhYhFjgBACMx+Xcw7fJ7yDRTXUW4sktQQGRhAkAmvfsLrxKbGQAmXM60sYyItuB3i9OJn6CfzzEhT5qsd5J7ghlpWemRW4qUvo5I3NrjZp863hlMbIqxwHpkQLIdAkEAlOiLtHh4OzCJGj6KZLN40qr6VIeEUp7Inq4TFfGEo2O/rgLL4tXGNd63RkX3iAd4jEmD5iDE81V0oLVGpyLGQQJACj9i+RbmGxVCW905nSMmnZIotqPkoDUQlsTKrFJfg5w8ISikGqcwCHLiEk7ngFLyMowp3CbDmaNfL6K5WkaYag==";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"龙昌VIP会员"; //商品标题
    order.productDescription = @"龙昌VIP会员"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",money]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {NSString *status = [resultDic objectForKey:@"resultStatus"];
            NSString *msg = @"付款失败";
            if ([@"9000" isEqualToString:status]) {
                if ([[UserInfoData getInstancet] userID]) {
                    msg = @"支付成功";
                    [[[Request alloc] initWithDelegate:self] getIsBuyStatus:[[UserInfoData getInstancet] userID]];
                } else {
                    msg = @"支付成功,请联系客服完成VIP绑定";
                }
            }else if([@"8000" isEqualToString:status]){
                msg = @"正在处理中";
            }else if([@"4000" isEqualToString:status]){
                msg = @"订单支付失败";
            }else if([@"6001" isEqualToString:status]){
                msg = @"您取消了付款";
            }else if([@"6002" isEqualToString:status]){
                msg = @"网络连接出错,请检查网络";
            }
            NSLog(@"reslut = %@",resultDic);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"付款" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    if (type == GETISBUYSTATUS && [json integerValue] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"付款" message:@"VIP购买完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
