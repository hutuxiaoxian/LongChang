//
//  SearchSameViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "SearchSameViewController.h"
#import "Request.h"
#import "TableViewController.h"
#import "MBProgressHUD.h"

@interface SearchSameViewController ()<ResponseDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UIButton *type;
@property (weak, nonatomic) IBOutlet UITextField *classify;
@property (nonatomic, strong)NSDictionary *dicType;
@property (nonatomic, strong)NSDictionary *dicClassify;
@property (nonatomic, strong)NSArray *arrClassify;
@property (nonatomic, strong)NSArray *arrType;
@property (nonatomic, strong)Request *req;
@property (nonatomic, weak)IBOutlet UIPickerView *pick;
@property (nonatomic, assign)int pickType;//1:classify, 2:type;
@property (weak, nonatomic) IBOutlet UIButton *findTypes;
@property (weak, nonatomic) IBOutlet UIView *vClassify;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSString *strUrl;

@end

@implementation SearchSameViewController
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"近似查询"];
    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.view addSubview:hud];
    
    
    self.req = [[Request alloc] initWithDelegate:self];
    [self.req fenLeiListAll];
    self.pickType = 1;
    [self.findTypes setTitle:@"精确" forState:UIControlStateNormal];
    
    [[self.vClassify layer] setBorderWidth:1.0];
    [[self.vClassify layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.type layer] setBorderWidth:1.0];
    [[self.type layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.findTypes layer] setBorderWidth:1.0];
    [[self.findTypes layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.content layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.content layer] setBorderWidth:1.0];
    
    self.arrType = @[@{@"char": @"汉字", @"ID": @"1"},
//                     @{@"char": @"拼音", @"ID": @"2"},
                     @{@"char": @"外文", @"ID": @"3"},
                     @{@"char": @"数字", @"ID": @"4"},
                     @{@"char": @"字头", @"ID": @"5"}];

    self.dicType = [self.arrType objectAtIndex:0];
    [self.type setTitle:[self.dicType objectForKey:@"char"] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findTypeClick:(id)sender {
    self.pickType = 2;
    [self.pick setHidden:NO];
    [self.pick selectedRowInComponent:0];
    [self.pick reloadAllComponents];
}

- (IBAction)classifyClick:(id)sender {
    self.pickType = 1;
    [self.pick setHidden:NO];
    [self.pick selectedRowInComponent:0];
    [self.pick reloadAllComponents];
}

- (IBAction)searchClick:(id)sender {
    NSString *str = [[self.content text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!str || [str length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入查询内容" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您查询数据,请稍后..."];
        [hud hide:YES afterDelay:60];
        NSString *typ = [self.findTypes titleForState:UIControlStateNormal];
        NSString *intclass = [[self.classify text] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([intclass length] == 0) {
            intclass = [self.dicClassify objectForKey:@"IntCls"];
        }
        if ([typ isEqualToString:@"精确"]) {
            self.strUrl = [[[Request alloc] initWithDelegate:self] jinsichaxun:[self.dicType objectForKey:@"ID"] typeName:str TabNum:intclass start:1 end:30];
        }else{
            self.strUrl = [[[Request alloc] initWithDelegate:self] jinshichaxun:[self.dicType objectForKey:@"ID"] typeName:str TabNum:intclass start:1 end:30];
        }
    }
}



- (IBAction)tap:(id)sender {
    [self.pick setHidden:YES];
}

- (IBAction)findType:(id)sender {
    self.pickType = 3;
    [self.pick setHidden:NO];
    [self.pick selectedRowInComponent:0];
    [self.pick reloadAllComponents];
}


- (void)responseDate:(id)json Type:(NSInteger)type {
    [hud setHidden:YES];
    
    if (type == JINSHICHAXUN) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            long countPages = [[json objectForKey:@"total"] longValue];
            json = [json objectForKey:@"data"];
            if ([json isKindOfClass:[NSArray class]]) {
                if ([json count] > 0) {
                    TableViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
                    [ctrl setUrl:self.strUrl];
                    NSMutableArray *arrData = [[NSMutableArray alloc] initWithCapacity:20];

                    for (NSDictionary *item in json) {
                        [arrData addObject:item];
                    }
                    [ctrl setArrData:arrData];
                    [ctrl setPageCount:countPages];
                    [self.navigationController pushViewController:ctrl animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
    }else if(type == FENLEILISTALL){
        self.arrClassify = json;
        self.dicClassify = [self.arrClassify objectAtIndex:0];
        NSString *str = [[self.arrClassify objectAtIndex:0] objectForKey:@"IntCls"];
        [self.classify setText:str];
//        [self.pick reloadAllComponents];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *arr = nil;
    if (self.pickType == 1) {
        arr = self.arrClassify ;
    }else if(self.pickType == 2){
        arr = self.arrType;
    }else if(self.pickType == 3){
        arr = @[@"精确", @"模糊"];
    }
    return [arr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *arr = nil;
    NSString *key = nil;
    if (self.pickType == 1) {
        key = @"DetailName";
        arr = self.arrClassify ;
    }else if(self.pickType == 2){
        key = @"char";
        arr = self.arrType;
    }else if(self.pickType == 3){
        key = @"key";
        arr = @[@{@"key": @"精确"}, @{@"key" :@"模糊"}];
    }
    NSString *str = [[arr objectAtIndex:row] objectForKey:key];
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickType == 1) {
        NSString *str = [[self.arrClassify objectAtIndex:row] objectForKey:@"IntCls"];
        self.dicClassify = [self.arrClassify objectAtIndex:row];
        [self.classify setText:str];
//        [self.classify setTitle:str forState:UIControlStateNormal];
    }else if(self.pickType == 2){
        NSString *str = [[self.arrType objectAtIndex:row] objectForKey:@"char"];
        self.dicType = [self.arrType objectAtIndex:row];
        [self.type setTitle:str forState:UIControlStateNormal];
    }else if(self.pickType == 3){
        NSString *str = [@[@"精确", @"模糊"] objectAtIndex:row];
        [self.findTypes setTitle:str forState:UIControlStateNormal];
    }
}

- (void)setIntClassify:(NSString *)classify {
    if (classify) {
        [self.classify setText:classify];
    }
}

@end
