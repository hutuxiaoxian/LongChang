//
//  ViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "LoginViewController.h"
#import "Request.h"
#import "MBProgressHUD.h"
#import "UserInfoData.h"
#import "VIPInfoViewController.h"

@interface LoginViewController ()<ResponseDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    NSString *strAcc = [self.account text];
    strAcc = [strAcc stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strPsd = [self.password text];
    strPsd = [strPsd stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!strAcc || strAcc.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"账号信息不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else if (!strPsd || strPsd.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您登录,请稍后..."];
        [hud hide:YES afterDelay:60];
        [[[Request alloc] initWithDelegate:self] getLoginUser:strAcc PassWord:strPsd];
    }
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == USERLOGIN) {
        if ([[json objectForKey:@"result"] integerValue] == 1) {
//            UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
//            [self presentViewController:ctrl animated:NO completion:nil];
            
            NSString *userID = [json objectForKey:@"UserID"];
            [[UserInfoData getInstancet] setUserID:userID];
            [[[self.tabBarController.tabBar items] objectAtIndex:0] setEnabled:YES];
            [[[self.tabBarController.tabBar items] objectAtIndex:1] setEnabled:YES];
            [[[self.tabBarController.tabBar items] objectAtIndex:2] setEnabled:NO];
            
            [self.tabBarController setSelectedIndex:0];
        }else if([[json objectForKey:@"result"] integerValue] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"账号或密码错误,请重新输入" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else if([[json objectForKey:@"result"] integerValue] == 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有成为VIP,或VIP已过期" delegate:self cancelButtonTitle:@"去购买" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    VIPInfoViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"vipinfo"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
