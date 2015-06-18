//
//  SearchClassifyViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/6/17.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "SearchClassifyViewController.h"
#import "SearchClassViewController.h"
#import "SearchSameViewController.h"
#import "Request.h"

@interface SearchClassifyViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (nonatomic, assign)int start, end;
@end

@implementation SearchClassifyViewController
@synthesize arrData;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self.content layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.content layer] setBorderWidth:1.0];
    
    self.start = 1;
    self.end = 30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)searchClick:(id)sender {
    NSString *str = [[self.content text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str length] > 0 ) {
        [[[Request alloc] initWithDelegate:self] fenleiSousuo:str start:self.start end:self.end];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索关键字" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *item = [arrData objectAtIndex:indexPath.row];
    
    UILabel *classif = (UILabel*)[cell viewWithTag:1];
    [[classif layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[classif layer] setBorderWidth:1.0];
    [classif setText:[item objectForKey:@"intcls"]];
    
    
    UILabel *detailID = (UILabel*)[cell viewWithTag:2];
    [[detailID layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[detailID layer] setBorderWidth:1.0];
    [detailID setText:[item objectForKey:@"DetailType"]];
    
    UILabel *detail = (UILabel*)[cell viewWithTag:3];
    [[detail layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[detail layer] setBorderWidth:1.0];
    [detail setText:[item objectForKey:@"DetailName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [arrData objectAtIndex:indexPath.row];
    NSString *classify = [item objectForKey:@"intcls"];
    classify = @"01";
    
    [self.navigationController popViewControllerAnimated:YES];
    if (delegate && [delegate respondsToSelector:@selector(returnClassify:)]) {
        [delegate returnClassify:classify];
    }
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    if (type == FENLEILISTCHAXUN) {
        if ([json objectForKey:@"data"]) {
            self.end = [[json objectForKey:@"total"] intValue];
            json = [json objectForKey:@"data"];
            if ([json isKindOfClass:[NSArray class]]) {
                if ([json count] > 0) {
                    arrData = json;
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关的信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
        [self.tableView reloadData];
    }
}

@end
