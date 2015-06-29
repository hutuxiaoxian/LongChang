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
@property (nonatomic, strong)NSArray *arrData;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation GongGaoViewController
//@synthesize RegNO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setTitle:@"公告"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)setRegNO:(NSString *)RegNO {
    if (!self.arrData) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您查询数据,请稍候..."];
        [hud hide:YES afterDelay:60];
        [[[Request alloc] initWithDelegate:self] gonggao:RegNO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *content = (UILabel*)[cell viewWithTag:2];
    UIView *v = [cell viewWithTag:3];
    [[v layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[v layer] setBorderWidth:1.0];
//    [[content layer] setMasksToBounds:YES];
//    [[content layer] setCornerRadius:10];
    
    NSDictionary *dict = [self.arrData objectAtIndex:indexPath.row];
    
    title.text = [dict objectForKey:@"TrialNum"];
    content.text = [dict objectForKey:@"Matters"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrData count];
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    if (type == GONGGAO) {
        if ([json isKindOfClass:[NSArray class]]) {
//            self.dict = [json objectAtIndex:0];
            self.arrData = json;
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
