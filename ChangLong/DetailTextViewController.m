//
//  DetailTextViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/6/12.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "DetailTextViewController.h"
#import "Request.h"
#import "MBProgressHUD.h"

@interface DetailTextViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UILabel *classify;
@property (weak, nonatomic) IBOutlet UILabel *regNO;
@property (weak, nonatomic) IBOutlet UILabel *applyDate;
@property (weak, nonatomic) IBOutlet UILabel *regDate;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *goods;
@property (weak, nonatomic) IBOutlet UILabel *group;
@property (weak, nonatomic) IBOutlet UILabel *applys;
@property (weak, nonatomic) IBOutlet UILabel *applyAddress;
@property (weak, nonatomic) IBOutlet UILabel *proxy;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (nonatomic, strong)NSDictionary *item;

@end

@implementation DetailTextViewController
//@synthesize item;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UIView *v in [self.view subviews]) {
        [v.layer setBorderWidth:1.0];
        [v.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
    [self initWithData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initWithData{
    NSString *strClassify = [self.item objectForKey:@"IntCls"];
    [self.classify setText:strClassify];
    NSString *strRegNo = [self.item objectForKey:@"RegNO"];
    [self.regNO setText:strRegNo];
    NSString *strApplyDate = [self.item objectForKey:@"AppDate"];
    [self.applyDate setText:strApplyDate];
    NSString *strRegDate = [self.item objectForKey:@"RegDate"];
    [self.regDate setText:strRegDate];
    NSString *strName = [self.item objectForKey:@"SBMC"];
    if (!strName || [strName length] == 0) {
        strName = [NSString stringWithFormat:@"%@ %@ %@", [self.item objectForKey:@"TMCN"]?[self.item objectForKey:@"TMCN"]:@"", [self.item objectForKey:@"TMEN"]?[self.item objectForKey:@"TMEN"]:@"", [self.item objectForKey:@"TMZT"]?[self.item objectForKey:@"TMZT"]:@""];
    }
    [self.name setText:strName];
    NSString *strGoods = [self.item objectForKey:@"TMDetail"];
    [self.goods setText:strGoods];
    NSString *strGroup = [self.item objectForKey:@"SimilarGroup"];
    [self.group setText:strGroup];
    NSString *strApply = [self.item objectForKey:@"TMApplicant"];
    [self.applys setText:strApply];
    NSString *strApplyAddress = [self.item objectForKey:@"TMAddress"];
    [self.applyAddress setText:strApplyAddress];
    NSString *strProxy = [self.item objectForKey:@"TMAgent"];
    [self.proxy setText:strProxy];
    NSString *strStatus = [self.item objectForKey:@"TMStatus"];
    [self.status setText:strStatus];
}

- (void)setRegID:(NSString *)RegID {
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setLabelText:@"正在为您查询数据,请稍候..."];
//    [hud hide:YES afterDelay:60];
    _RegID = RegID;
    [[[Request alloc] initWithDelegate:self] stateList:_RegID];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == STATELIST) {
        if ([json isKindOfClass:[NSArray class]] && [json count] == 1) {
            self.item = [json objectAtIndex:0];
            [self initWithData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end
