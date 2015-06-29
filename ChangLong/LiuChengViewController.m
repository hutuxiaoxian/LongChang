//
//  LiuChengViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "LiuChengViewController.h"
#import "LiuChengView.h"
#import "Request.h"
@interface LiuChengViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic, assign)float scrollHeight;
@end

@implementation LiuChengViewController
//.@synthesize arrData;
@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setTitle:@"流程"];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scroll setContentSize:CGSizeMake(self.view.frame.size.width, self.scrollHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setArrData:(NSArray *)arrData {
    float w = [self.view frame].size.width - 20;
    float x = 10, y = 0, h = 44;
    for (NSDictionary *dict in arrData) {
        y += 10;
        LiuChengView *v = [[LiuChengView alloc] initWithFrame:CGRectMake(x, y, w, h)];

        [v.text setText:[dict objectForKey:@"FlowName"]];
        [v.title setText:[dict objectForKey:@"FlowDate"]];
        [self.scroll addSubview:v];
        y += h;
    }
    self.scrollHeight = y + 44 + 10;
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
