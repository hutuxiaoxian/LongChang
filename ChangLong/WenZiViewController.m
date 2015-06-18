//
//  WenZiViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "WenZiViewController.h"

@interface WenZiViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation WenZiViewController
//@synthesize item;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"文字"];
//    self.item = [[NSDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.item) {
        NSArray *arr = [self.item allKeys];
//        NSDictionary *dic = [arr objectAtIndex:indexPath.row];
        NSString *content = nil;
        
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        UILabel *lab = (UILabel*)[cell viewWithTag:2];
        [[lab layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [[lab layer] setBorderWidth:1.0];
        [[lab layer] setMasksToBounds:YES];
        [[lab layer] setCornerRadius:10];
        
        
        switch (indexPath.row) {
            case 0:
                [title setText:@"国际分类号"];
                content = [self.item objectForKey:@"IntCls"];
                break;
            case 1:
                [title setText:@"注册号"];
                content = [self.item objectForKey:@"RegNO"];
                break;
            case 2:
                [title setText:@"申请日期"];
                content = [self.item objectForKey:@"TrialDate"];
                break;
            case 3:
                [title setText:@"注册日期"];
                content = [self.item objectForKey:@"RegDate"];
                break;
            case 4:
                [title setText:@"商品名称"];
                content = [NSString stringWithFormat:@"%@ %@ %@", [self.item objectForKey:@"TMCN"], [self.item objectForKey:@"TMEN"], [self.item objectForKey:@"TMZT"]];
                break;
            case 5:
                [title setText:@"使用商品"];
                content = [self.item objectForKey:@"TMDetail"];
                break;
            case 6:
                [title setText:@"类似群组"];
                content = [self.item objectForKey:@"SimilarGroup"];
                break;
            case 7:
                [title setText:@"申请人"];
                content = [self.item objectForKey:@"TMApplicant"];
                break;
            case 8:
                [title setText:@"申请地址"];
                content = [self.item objectForKey:@"TMAddress"];
                break;
            case 9:
                [title setText:@"代理人"];
                content = [self.item objectForKey:@"TMAgent"];
                break;
            case 10:
                [title setText:@"商标状态"];
                content = [self.item objectForKey:@"TMStatus"];
                break;
            
            default:
                
                break;
        }
        [lab setText:content];
    }
    return cell;
}

- (void)setItem:(NSDictionary *)item{
    _item = item;
    [self.table reloadData];
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
