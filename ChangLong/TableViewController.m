//
//  TableViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "TableViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "DetailViewController.h"
#import "Request.h"

@interface TableViewController ()<ResponseDelegate>
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)BOOL isUp;
@end

@implementation TableViewController
@synthesize arrData;
@synthesize isRefresh;
@synthesize url;
@synthesize pageCount;

//- (void)viewWillAppear:(BOOL)animated {
////    [self setHidesBottomBarWhenPushed:NO];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isRefresh) {
        self.index = 0;
    }
    
    if (!arrData) {
        arrData = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    [self setTitle:@"查询列表"];
    
    [self.tableView addHeaderWithTarget:self action:@selector(dropDown)];
    [self.tableView addFooterWithTarget:self action:@selector(onPull)];
}

- (void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.index++;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    UILabel *reg = (UILabel*)[cell viewWithTag:1];
    UILabel *types = (UILabel*)[cell viewWithTag:2];
    UILabel *cname = (UILabel*)[cell viewWithTag:3];
    UILabel *index = (UILabel*)[cell viewWithTag:4];
    NSDictionary *item = [arrData objectAtIndex:indexPath.row];
    NSString *str = [item objectForKey:@"SBMC"];
    if (!str || [str length] == 0) {
        str = [item objectForKey:@"TMCN"];
        str = [str stringByAppendingString:[item objectForKey:@"TMEN"]];
        str = [str stringByAppendingString:[item objectForKey:@"TMZT"]];
    }
    [reg setText:[item objectForKey:@"RegNO"]];
    [types setText:[item objectForKey:@"IntCls"]];
    [cname setText:[str isKindOfClass:[NSNull class]]?@"":str];
    [index setText:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [arrData objectAtIndex:indexPath.row];
    DetailViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [ctrl setData:item];
    [ctrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
//下拉刷新
- (void)dropDown {
    if (url) {
        self.isUp = NO;
        NSRange ran = [url rangeOfString:@"Start="];
        NSString *str = [url substringFromIndex:ran.location];
        NSArray *arr = [str componentsSeparatedByString:@"&"];
        NSString *start = [[[arr objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
        NSString *end = [[[arr objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
        start = [NSString stringWithFormat:@"Start=%@", start];
        
        NSString *newStart = [NSString stringWithFormat:@"Start=%d", 1];
        NSString *newEnd = [NSString stringWithFormat:@"End=%d", 20];
        end = [NSString stringWithFormat:@"End=%@", end];
        url = [url stringByReplacingOccurrencesOfString:start withString:newStart];
        url = [url stringByReplacingOccurrencesOfString:end withString:newEnd];
        [self request];
    }
}
//上拉刷新
- (void)onPull {
    if (url) {
        self.isUp = YES;
        NSRange ran = [url rangeOfString:@"Start="];
        NSString *str = [url substringFromIndex:ran.location];
        NSArray *arr = [str componentsSeparatedByString:@"&"];
        NSString *start = [[[arr objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
        NSString *end = [[[arr objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
        start = [NSString stringWithFormat:@"Start=%@", start];
        NSString *newStart = [NSString stringWithFormat:@"Start=%ld", [end intValue] + 1>pageCount?pageCount:[end intValue] + 1];
        NSString *newEnd = [NSString stringWithFormat:@"End=%ld", [end intValue] + 20>pageCount?pageCount:[end intValue] + 20];
        end = [NSString stringWithFormat:@"End=%@", end];
        url = [url stringByReplacingOccurrencesOfString:start withString:newStart];
        url = [url stringByReplacingOccurrencesOfString:end withString:newEnd];
        [self request];
    }
}

- (void)request{
    
    int type = -1;
    if ([url rangeOfString:@"SBJinSiChaXun"].length > 0) {
        type = JINSHICHAXUN;
    } else if ([url rangeOfString:@"SBZongHeInfo"].length > 0) {
        type = ZONGHEINFO;
    }
    [[[Request alloc] initWithDelegate:self] request:url type:type];
}

- (void)responseDate:(id)json Type:(NSInteger)type_ {
    if (self.isUp) {
        [self.tableView footerEndRefreshing];
    }else{
        [self.tableView headerEndRefreshing];
    }
    if (type_ == STATELIST) {
        json = [json objectForKey:@"data"];
        if ([json isKindOfClass:[NSArray class]]) {
            if ([json count] > 0) {
                if (!self.isUp) {
                    [arrData removeAllObjects];
                }
                for (NSDictionary *item in json) {
                    [arrData addObject:item];
                }
                [self.tableView reloadData];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }else if (type_ == ZONGHEINFO || type_ == JINSHICHAXUN){
        json = [json objectForKey:@"data"];
        if ([json isKindOfClass:[NSArray class]]) {
            if ([json count] > 0) {
                
                if (!self.isUp) {
                    [arrData removeAllObjects];
                }
                for (NSDictionary *item in json) {
                    [arrData addObject:item];
                }
                [self.tableView reloadData];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

@end
