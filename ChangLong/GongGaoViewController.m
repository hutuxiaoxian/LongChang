//
//  GongGaoViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "GongGaoViewController.h"
#import "Request.h"
#import "MBProgressHUD.h"

@interface GongGaoViewController ()<ResponseDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation GongGaoViewController
//@synthesize RegNO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"公告"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)setRegNO:(NSString *)RegNO {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"正在为您查询数据,请稍后..."];
    [hud hide:YES afterDelay:60];
    [[[Request alloc] initWithDelegate:self] stateList:RegNO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *content = (UILabel*)[cell viewWithTag:2];
    [[content layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[content layer] setBorderWidth:1.0];
    [[content layer] setMasksToBounds:YES];
    [[content layer] setCornerRadius:10];
    
    switch (indexPath.row) {
        case 0:
            title.text = @"国际分类号";
            content.text = [self.dict objectForKey:@"IntCls"];
            break;
        case 1:
            title.text = @"注册号";
            content.text = [self.dict objectForKey:@"RegNO"];
            break;
        case 2:
            title.text = @"商标中文";
            content.text = ![[self.dict objectForKey:@"TMCN"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMCN"]:@"";
            break;
        case 3:
            title.text = @"商标英文";
            content.text = ![[self.dict objectForKey:@"TMEN"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMEN"]:@"";
            break;
        case 4:
            title.text = @"商标字头";
            content.text = ![[self.dict objectForKey:@"TMZT"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMZT"]:@"";
            break;
        case 5:
            title.text = @"商标数字";
            content.text = ![[self.dict objectForKey:@"TMSZ"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMSZ"]:@"";
            break;
        case 6:
            title.text = @"申请人";
            content.text = ![[self.dict objectForKey:@"TMApplicant"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMApplicant"]:@"";
            break;
        case 7:
            title.text = @"代理人";
            content.text = ![[self.dict objectForKey:@"TMAgent"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMAgent"]:@"";
            break;
        case 8:
            title.text = @"地区编号";
            content.text = ![[self.dict objectForKey:@"TMAreaNum"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMAreaNum"]:@"";
            break;
        case 9:{
            title.text = @"商标组别";
            
            content.text = ![[self.dict objectForKey:@"SimilarGroup"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"SimilarGroup"]:@"";
            break;}
        case 10:{
            title.text = @"状态";
            content.text = ![[self.dict objectForKey:@"TMStatus"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMStatus"]:@"";
            break;}
        case 11:
            title.text = @"初审公告期数";
            content.text = ![[self.dict objectForKey:@"TrialNum"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TrialNum"]:@"";
            break;
        case 12:
            title.text = @"商标同音";
            content.text = ![[self.dict objectForKey:@"TMTY"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMTY"]:@"";
            break;
        case 13:
            title.text = @"商标多音";
            content.text = ![[self.dict objectForKey:@"TMDY"] isKindOfClass:[NSNull class]]?[self.dict objectForKey:@"TMDY"]:@"";
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 14;
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == STATELIST) {
        if ([json isKindOfClass:[NSArray class]] && [json count] == 1) {
            self.dict = [json objectAtIndex:0];
            [self.table reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
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
