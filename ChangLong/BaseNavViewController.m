//
//  BaseNavViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/6/9.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        UIColor *color = [UIColor colorWithRed:134/255.0 green:141/255.0 blue:192/255.0 alpha:1.0];
        [[self navigationBar] setTintColor:color];
    }
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
