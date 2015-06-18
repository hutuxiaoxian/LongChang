//
//  TabViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/26.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "TabViewController.h"
#import "UserInfoData.h"

@interface TabViewController ()<UITabBarControllerDelegate>
@property (nonatomic, assign)NSInteger select;
@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arr = [self.tabBar items];
    [self setDelegate:self];
    UITabBarItem *item = [arr objectAtIndex:0];
    if (iOS6) {
        [item setImage:[[UIImage imageNamed:@"icon_main.png"] imageWithAlignmentRectInsets:UIEdgeInsetsFromString(@"top")]];
        [item setSelectedImage:[[UIImage imageNamed:@"icon_main_select.png"] imageWithAlignmentRectInsets:UIEdgeInsetsFromString(@"top")]];
    }else{
        [item setImage:[[UIImage imageNamed:@"icon_main.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:@"icon_main_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    [item setTag:1];
    [item setEnabled:NO];
    
    item = [arr objectAtIndex:1];
    if (iOS6) {
        [item setImage:[[UIImage imageNamed:@"scan.png"] imageWithAlignmentRectInsets:UIEdgeInsetsFromString(@"top")]];
        [item setSelectedImage:[[UIImage imageNamed:@"scan.png"] imageWithAlignmentRectInsets:UIEdgeInsetsFromString(@"top")]];
    }else{
        
        [item setImage:[[UIImage imageNamed:@"scan.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:@"scan.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    [item setTag:2];
    [item setEnabled:NO];
    
    item = [arr objectAtIndex:2];
    if (iOS6) {
        [item setImage:[[UIImage imageNamed:@"icon_vip.png"] imageWithAlignmentRectInsets:UIEdgeInsetsFromString(@"top")]];
        [item setSelectedImage:[[UIImage imageNamed:@"icon_vip_select.png"] imageWithAlignmentRectInsets:UIEdgeInsetsFromString(@"top")]];
    }else{
        [item setImage:[[UIImage imageNamed:@"icon_vip.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:@"icon_vip_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    [item setTag:3];
    
    [self setSelectedIndex:2];
}

- (void)viewDidLayoutSubviews {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.select = [item tag];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.select == 2) {
        [[viewController navigationController] popToRootViewControllerAnimated:NO];
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
