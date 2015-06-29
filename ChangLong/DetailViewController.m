//
//  DetailViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageViewController.h"
#import "LiuChengViewController.h"
#import "GongGaoViewController.h"
#import "WenZiViewController.h"
#import "DetailTextViewController.h"
#import "Request.h"

@interface DetailViewController ()<UITabBarControllerDelegate, ResponseDelegate>

@end

@implementation DetailViewController
@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
    [self setTitle:@"商标详情"];
    [[[Request alloc] initWithDelegate:self] stateFlowInfo:[data objectForKey:@"IntCls"] regNO:[data objectForKey:@"RegNO"]];
//     [(WenZiViewController*)[self.viewControllers objectAtIndex:0] setItem:data];
    [(DetailTextViewController*)[self.viewControllers objectAtIndex:0] setRegID:[data objectForKey:@"RegNO"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ImageViewController class]]) {
        [(ImageViewController*)viewController setImage:[data objectForKey:@"RegNO"]];
        
    }else if ([viewController isKindOfClass:[LiuChengViewController class]]) {
        [(LiuChengViewController*)viewController setItem:data];
        
    }else if ([viewController isKindOfClass:[GongGaoViewController class]]) {
        [(GongGaoViewController*)viewController setRegNO:[data objectForKey:@"RegNO"]];
        
    }else if ([viewController isKindOfClass:[WenZiViewController class]]) {
        [(DetailTextViewController*)viewController setRegID:[data objectForKey:@"RegNO"]];
    }
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    if (type == STATEFLOWINFO) {
        if (type == STATEFLOWINFO) {
            if ([json isKindOfClass:[NSArray class]]) {
                if ([json count] > 0) {
                    LiuChengViewController *liu = [self.viewControllers objectAtIndex:2];
                    [liu setArrData:json];
                }
//                else {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
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
