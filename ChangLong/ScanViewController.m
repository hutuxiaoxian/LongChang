//
//  ScanViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/3/6.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Request.h"
#import "TableViewController.h"
#import "MBProgressHUD.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, ResponseDelegate>
@property(nonatomic,strong)AVCaptureSession *captureSession;
@property(nonatomic, strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, strong)NSString *url;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.tabBarController.tabBar setTintColor:[UIColor yellowColor]];
//    [self.tabBarController.tabBarItem setImage:];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES];
    [self startReading];
}

- (BOOL)startReading {
//    isReading = YES;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    

    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"code %@", metadataObj.stringValue);
        [self stopReading];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:@"正在为您查询数据,请稍候..."];
        [hud hide:YES afterDelay:60];
        
//        [[[Request alloc] initWithDelegate:self] getBarCodeInfo:@"06942720100001"];
        self.url = [[[Request alloc] initWithDelegate:self] getBarCodeInfo:metadataObj.stringValue];
        
    } 
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (type == GETBARCODEINFO) {
        if ([json isKindOfClass:[NSArray class]]) {
            TableViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
            [ctrl setArrData:json];
            [ctrl setUrl:self.url];
            [[ctrl navigationController] setNavigationBarHidden:NO animated:YES];
//            UIViewController* c = [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController pushViewController:ctrl animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到相关信息" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
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
