//
//  LiuChengView.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "LiuChengView.h"

@implementation LiuChengView
@synthesize title,text;

- (instancetype)init {
//    self = [[[NSBundle mainBundle] loadNibNamed:@"LiuChengView" owner:self options:nil] objectAtIndex:0];
    self = [super init];
    if (self) {
        [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.layer setBorderWidth:1];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 110, 40)];
        [title setTextColor:[UIColor lightGrayColor]];
        [title setFont:[UIFont systemFontOfSize:16]];
        text = [[UILabel alloc] initWithFrame:CGRectMake(120, 2, frame.size.width - 120 - 10, 40)];
//        [title setTextColor:[UIColor lightGrayColor]];
        [text setFont:[UIFont systemFontOfSize:16]];
        [text setTextAlignment:NSTextAlignmentRight];
        
        [self addSubview:title];
        [self addSubview:text];
        
        [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.layer setBorderWidth:1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
