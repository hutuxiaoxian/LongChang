//
//  SearchClassViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "SearchClassViewController.h"
#import "Request.h"
#import "TableViewController.h"
#import "MBProgressHUD.h"

@interface SearchClassViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UITextField *content;

@end

@implementation SearchClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"商标状态查询"];

    [[self.content layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.content layer] setBorderWidth:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)serach:(id)sender {
    NSString *str = [[self.content text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!str || [str length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入查询内容" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您查询数据,请稍候..."];
        [hud hide:YES afterDelay:60];
        [[[Request alloc] initWithDelegate:self] stateList:str];
        
    }
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == STATELIST) {
        if ([json isKindOfClass:[NSArray class]]) {
            if ([json count] > 0) {
                TableViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
                [ctrl setArrData:json];
                [self.navigationController pushViewController:ctrl animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
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
