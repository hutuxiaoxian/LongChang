//
//  SearchClassifyViewController.h
//  ChangLong
//
//  Created by 糊涂 on 15/6/17.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol returnClassify <NSObject>

- (void)returnClassify:(NSString*)classify;

@end

@interface SearchClassifyViewController : UITableViewController
@property (nonatomic, strong)NSMutableArray *arrData;
@property (nonatomic ,strong)NSObject<returnClassify> *delegate;

@end
