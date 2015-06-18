//
//  TableViewController.h
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property (nonatomic, strong)NSMutableArray *arrData;
@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, assign)long pageCount;
@end
