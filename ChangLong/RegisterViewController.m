//
//  RegisterViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "RegisterViewController.h"
#import "Request.h"
#import "MBProgressHUD.h"
#import "UserInfoData.h"

@interface RegisterViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;

@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *btGetCode;
@property (nonatomic, strong)NSString *strCodeRes;
@property (nonatomic, strong)NSTimer *timer ;
@property (nonatomic, assign)NSInteger time;
@end

@implementation RegisterViewController

- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.time = 60;
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self.account layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.account layer] setBorderWidth:1];
    
    [[self.password layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.password layer] setBorderWidth:1];
    
    [[self.rePassword layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.rePassword layer] setBorderWidth:1];
    
//    [[self.phone layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
//    [[self.phone layer] setBorderWidth:1];
    
    [[self.code layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.code layer] setBorderWidth:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerClick:(id)sender {
    
    
//    UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"vipinfo"];
////    [self presentViewController:ctrl animated:NO completion:nil];
//    [self.navigationController pushViewController:ctrl animated:YES];
    
    NSString *strAccount = [[self.account text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strPassword = [[self.password text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strRePassword = [[self.rePassword text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strCode = [[self.code text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strPhoen = [[self.account text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if (!strCode || [strCode length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];

    } else if (![strCode isEqualToString:self.strCodeRes]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码输入错误!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];

    } else if (!strAccount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"账号信息不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    } else if (!strPhoen || [strPhoen length]!= 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机信息不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else if (!strPassword || strPassword.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else if (![strPassword isEqualToString:strRePassword]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您注册账号,请稍候..."];
        [hud hide:YES afterDelay:60];
        [[[Request alloc] initWithDelegate:self] setRegisterUser:strAccount PassWord:strPassword];
    }
    
}
- (IBAction)getCode:(id)sender {
    NSString *strAccount = [[self.account text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!strAccount || [strAccount length]!= 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"账号信息不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        int i = arc4random() % 100000;
        i += 1;
        self.strCodeRes = [NSString stringWithFormat:@"%06d", i];
        NSString *url = [NSString stringWithFormat:@"http://utf8.sms.webchinese.cn/?Uid=longchang&Key=bbb1e31d8d3609525c43&smsMob=%@&smsText=%%E6%%82%%A8%%E7%%9A%%84%%E9%%AA%%8C%%E8%%AF%%81%%E7%%A0%%81:%@", strAccount, self.strCodeRes];
        NSData *data = [[[Connect alloc] init] getSynConnectWithURL:url];
        NSString *resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *resp = @"1";
        if ([@"1" isEqualToString:resp]) {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"验证码获取成功"];
            [self getCode];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码获取失败,请稍候重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@"resp %@", resp);
    }
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"resp %@", json);
    if (type == REGISTER && [[json objectForKey:@"result"] integerValue] == 1) {
        NSString *userID = [json objectForKey:@"UserID"];
        [[UserInfoData getInstancet] setUserID:userID];
//        UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"vipinfo"];
//        [self.navigationController pushViewController:ctrl animated:YES];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)getCode{
    if (!self.timer) {
        
        [self.btGetCode setEnabled:NO];
        self.time = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshBtName) userInfo:nil repeats:YES];
    }
}

- (void)refreshBtName{
    
    if (self.time <= 0) {
//        self.time = 0;
        [self.timer invalidate];
        self.timer = nil;
        [self.btGetCode setEnabled:YES];
        [self.btGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.btGetCode setTitle:[NSString stringWithFormat:@"获取验证码(%02ld)", (long)self.time] forState:UIControlStateNormal];
        self.time -= 1;
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
