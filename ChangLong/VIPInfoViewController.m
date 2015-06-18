//
//  VIPInfoViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/27.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "VIPInfoViewController.h"

@interface VIPInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation VIPInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [format stringFromDate:[NSDate date]];
    NSString *txt = [[self.lab text] stringByReplacingOccurrencesOfString:@"${date}" withString:strDate];
    [self.lab setText:txt];
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

@end
