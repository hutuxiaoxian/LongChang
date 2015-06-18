//
//  MainViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/10.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "MainViewController.h"
#import "Request.h"

@interface MainViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btVIP;
@property (weak, nonatomic) IBOutlet UIButton *btMain;
@property(nonatomic, strong) Request *req;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.req = [[Request alloc] initWithDelegate:self];
    double w = ([self.view frame].size.width - 32 - 20)/2;
    double h = [self.view frame].size.height *.4 < 220?220:[self.view frame].size.height *.4  ;
//    double h = 220;
    NSLog(@"vH %f sear %f",self.view.frame.size.height, h);
    
    UIView *vSearchSame = [[UIView alloc] initWithFrame:CGRectMake(16, 16, w, h)];
    UIImageView *imgSearchSame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_icon02.png"]];
    [imgSearchSame setFrame:CGRectMake(16, 16, 40, 40)];
    UILabel *labSearchSame = [[UILabel alloc] initWithFrame:CGRectMake(5, h - 20 - 10, w - 10, 20)];
    [labSearchSame setText:@"近似查询"];
    [labSearchSame setTextAlignment:NSTextAlignmentRight];
    [labSearchSame setTextColor:[UIColor whiteColor]];
    [labSearchSame setFont:[UIFont systemFontOfSize:20]];
    
    [vSearchSame addSubview:imgSearchSame];
    [vSearchSame addSubview:labSearchSame];
    UITapGestureRecognizer *tapSS = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchSame)];
    [vSearchSame addGestureRecognizer:tapSS];
    
    
    UIView *vSearchClassify = [[UIView alloc] initWithFrame:CGRectMake(16 + w + 20, 16, w, h)];
    UIImageView *imgSearchClassify = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_icon03.png"]];
    [imgSearchClassify setFrame:CGRectMake(16, 16, 40, 40)];
    UILabel *labSearchClassify = [[UILabel alloc] initWithFrame:CGRectMake(5, h - 20 - 10, w - 10, 20)];
    [labSearchClassify setText:@"综合查询"];
    [labSearchClassify setTextAlignment:NSTextAlignmentRight];
    [labSearchClassify setTextColor:[UIColor whiteColor]];
    [labSearchClassify setFont:[UIFont systemFontOfSize:20]];
    
    [vSearchClassify addSubview:imgSearchClassify];
    [vSearchClassify addSubview:labSearchClassify];
    UITapGestureRecognizer *tapSC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchComplex)];
    [vSearchClassify addGestureRecognizer:tapSC];
    
    
    UIView *vComplexView = [[UIView alloc] initWithFrame:CGRectMake(16, h + 16 + 16, [self.view frame].size.width - 32, [self.view frame].size.height *.4 < 220?120:146)];
    UIImageView *imgComplex = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_icon.png"]];
    [imgComplex setFrame:CGRectMake(16, 16, 40, 40)];
    
    UILabel *labComplex = [[UILabel alloc] initWithFrame:CGRectMake(5, vComplexView.frame.size.height - 20 - 10, vComplexView.frame.size.width - 10, 20)];
    [labComplex setText:@"状态查询"];
    [labComplex setTextAlignment:NSTextAlignmentRight];
    [labComplex setTextColor:[UIColor whiteColor]];
    [labComplex setFont:[UIFont systemFontOfSize:20]];
    
    [vComplexView addSubview:imgComplex];
    [vComplexView addSubview:labComplex];
    UITapGestureRecognizer *tapCV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SearchClass)];
    [vComplexView addGestureRecognizer:tapCV];
    
    
    [vSearchSame setBackgroundColor:[UIColor colorWithRed:73.0/255 green:94.0/255 blue:134.0/255 alpha:1]];
    [vSearchClassify setBackgroundColor:[UIColor colorWithRed:98.0/255 green:174.0/255 blue:148.0/255 alpha:1]];
    [vComplexView setBackgroundColor:[UIColor colorWithRed:117.0/255 green:134.0/255 blue:80.0/255 alpha:1]];
    
    [self.view addSubview:vSearchClassify];
    [self.view addSubview:vSearchSame];
    [self.view addSubview:vComplexView];
    
    
//    [self.navigationController.toolbar setTintColor:[UIColor redColor]];
//    [self.navigationController.toolbar setTintColor:[UIColor colorWithRed:119/255.0 green:144/255.0 blue:202/255.0 alpha:0]];
    
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

- (IBAction)click:(id)sender {
    if (sender == self.btMain) {
        [self.btVIP setImage:[UIImage imageNamed:@"icon_vip.png"] forState:UIControlStateNormal];
        [self.btMain setImage:[UIImage imageNamed:@"icon_main_select.png"] forState:UIControlStateNormal];
    }else if (sender == self.btVIP){
        [self.btVIP setImage:[UIImage imageNamed:@"icon_vip_select.png"] forState:UIControlStateNormal];
        [self.btMain setImage:[UIImage imageNamed:@"icon_main.png"] forState:UIControlStateNormal];
    }
}

- (void)searchSame{
    UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchSameViewController"];
    [[self navigationController] pushViewController:ctrl animated:YES];
}

- (void)searchComplex{
    UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchComplexViewController"];
    [[self navigationController] pushViewController:ctrl animated:YES];
}

- (void)SearchClass{
    UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchClassViewController"];
    [[self navigationController] pushViewController:ctrl animated:YES];
}

- (IBAction)scan:(id)sender {
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    
}

@end
