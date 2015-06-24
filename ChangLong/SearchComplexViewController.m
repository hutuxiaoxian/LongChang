//
//  SearchComplexViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "SearchComplexViewController.h"
#import "Request.h"
#import "MBProgressHUD.h"
#import "TableViewController.h"
#import "SearchClassifyViewController.h"

@interface SearchComplexViewController ()<UIPickerViewDataSource ,UIPickerViewDelegate, ResponseDelegate, returnClassify>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UITextField *classify;
@property (weak, nonatomic) IBOutlet UIButton *findType;
@property (weak, nonatomic) IBOutlet UITextField *editReg;
@property (weak, nonatomic) IBOutlet UITextField *editName;
@property (weak, nonatomic) IBOutlet UITextField *editPeople;
@property (weak, nonatomic) IBOutlet UIPickerView *pick;
@property (weak, nonatomic) IBOutlet UIView *vClassify;
@property (nonatomic ,strong)NSArray *arrClassify;
@property (nonatomic ,strong)NSArray *arrType;
@property (nonatomic, strong)NSDictionary *dicClassify;
@property (nonatomic, strong)NSDictionary *dicType;
@property (nonatomic, assign)int pickType; //1:classify 2:findType
@property (nonatomic, strong)Request *req;
@property (nonatomic, strong)NSString *url;

@end

@implementation SearchComplexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.classify setInputView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.pickType = 1;
    
    [self setTitle:@"综合查询"];
    
    self.req = [[Request alloc] initWithDelegate:self];
    [self.req fenLeiListAll];
    
    [[self.editReg layer] setBorderWidth:1.0];
    [[self.editReg layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.findType layer] setBorderWidth:1.0];
    [[self.findType layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.editName layer] setBorderWidth:1.0];
    [[self.editName layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.editPeople layer] setBorderWidth:1.0];
    [[self.editPeople layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    [[self.vClassify layer] setBorderWidth:1.0];
    [[self.vClassify layer] setBorderColor:[[UIColor lightGrayColor] CGColor] ];
    
    self.arrType = @[@{@"char": @"精确", @"ID": @"2"},
                     @{@"char": @"模糊", @"ID": @"1"}
                     ];
    
    self.dicType = [self.arrType objectAtIndex:0];
    [self.findType setTitle:[self.dicType objectForKey:@"char"] forState:UIControlStateNormal];
//    [self.findType addGestureRecognizer:self.tap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender {
    [self.pick setHidden:YES];
}
- (IBAction)classifyClick:(id)sender {
//    self.pickType = 1;
//    [self.pick reloadAllComponents];
//    [self.pick setHidden:NO];
    
    SearchClassifyViewController *cvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SearchClassifyViewController"];
    [cvc setDelegate:self];
    [self.navigationController pushViewController:cvc animated:YES];
    
}
- (IBAction)typeClick:(id)sender {
    self.pickType = 2;
    [self.pick reloadAllComponents];
    [self.pick setHidden:NO];
}

- (IBAction)serach:(id)sender {
    
    NSString *reg = [[self.editReg text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *name = [[self.editName text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *people = [[self.editPeople text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *content = [[self.classify text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (reg.length == 0 && name.length == 0 && people.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入查询内容" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else if (([reg length]> 0 && [name length] > 0) || ([people length]> 0 && [name length] > 0) || ([reg length]> 0 && [people length] > 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册号、商标名称、申请人只能同时存在一个条件" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您查询数据,请稍后..."];
        [hud hide:YES afterDelay:60];
        if (content.length == 0) {
            content = nil;
        }
        
        NSInteger type = 0;
        if ([[self.dicType objectForKey:@"char"] isEqualToString:@"精确"] || [reg length] > 0) {
            type = 1;
        }
        self.url = [self.req zongHeInfoWithRegNO:reg Sbmc:name applicant:people Intcls:content type:type start:1 end:20];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickType == 1) {
        NSString *str = [[self.arrClassify objectAtIndex:row] objectForKey:@"IntCls"];
        self.dicClassify = [self.arrClassify objectAtIndex:row];
        [self.classify setText:str];
    }else if(self.pickType == 2){
        NSString *str = [[self.arrType objectAtIndex:row] objectForKey:@"char"];
        self.dicType = [self.arrType objectAtIndex:row];
        [self.findType setTitle:str forState:UIControlStateNormal];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *arr = nil;
    if (self.pickType == 1) {
        arr = self.arrClassify;
    }else if (self.pickType == 2){
        arr = self.arrType;
    }
    return [arr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *arr = nil;
    NSString *key = nil;
    if (self.pickType == 1) {
        arr = self.arrClassify;
        key = @"DetailName";
    }else if (self.pickType == 2){
        arr = self.arrType;
        key = @"char";
    }
    return [[arr objectAtIndex:row] objectForKey:key];
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == FENLEILISTALL) {
        self.arrClassify = json;
        self.dicClassify = [self.arrClassify objectAtIndex:0];
//        NSString *str = [[self.arrClassify objectAtIndex:0] objectForKey:@"IntCls"];
//        [self.classify setText:str];
    }else if (type == ZONGHEINFO){
        if ([json isKindOfClass:[NSDictionary class]]) {
            long countPages = [[json objectForKey:@"total"] longValue];
            json = [json objectForKey:@"data"];
            if ([json isKindOfClass:[NSArray class]]) {
                if ([json count] > 0) {
                    TableViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
                    NSMutableArray *arrData = [[NSMutableArray alloc] initWithCapacity:20];
                    
                    for (NSDictionary *item in json) {
                        [arrData addObject:item];
                    }
                    [ctrl setArrData:arrData];
                    [ctrl setPageCount:countPages];
                    [ctrl setUrl:self.url];
                    [self.navigationController pushViewController:ctrl animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
        
    }
}

- (void)returnClassify:(NSString *)classify{
    if (classify) {
        [self.classify setText:classify];
    }
}

- (void)setIntClassify:(NSString *)classify {
    if (classify) {
        [self.classify setText:classify];
    }
}
@end
