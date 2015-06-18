//
//  ImageViewController.m
//  ChangLong
//
//  Created by 糊涂 on 15/5/31.
//  Copyright (c) 2015年 hutu. All rights reserved.
//

#import "ImageViewController.h"
#import "Request.h"
#import "UIImageView+WebCache.h"

@interface ImageViewController ()<ResponseDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation ImageViewController
//@synthesize image;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setTitle:@"商标图"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(NSString *)image {
    image = [image stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (image && [image length] > 0) {
        _image = image;
//        [[[Request alloc] initWithDelegate:self] imgByte:image];
        NSString *strURL = [NSString stringWithFormat:@"%@?method=SBImgByte&RegNO=%@", HostName, image];
        NSData *dat = [[[Connect alloc] init] downLoadWithURL:strURL];
        NSString *code = [[NSString alloc] initWithData:dat encoding:NSASCIIStringEncoding];
        dat = [self base64Decode:code];
        //    NSData *dat = [[[Connect alloc] init] downLoadWithURL:strUrl];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
        NSString *path =[paths objectAtIndex:0];
        NSString *FileName=[path stringByAppendingPathComponent:@"n.jpg"];
        NSLog(@"file %@", FileName);
        [dat writeToFile:FileName atomically:YES];
        [self.img setImage:[UIImage imageWithData:dat]];
    }
}

- (void)responseDate:(id)json Type:(NSInteger)type {
    if (type == IMGBYTE) {
        NSData *dat = [self base64Decode:json];
        [self.img setImage:[UIImage imageWithData:dat]];
    }
}

- (NSData*)base64Decode:(NSString*)string {
    
    static char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

+ (NSData *)stringFromHexString:(NSString *)hexString { //
    static const char hexdigits[] = "0123456789ABCDEF";
    NSData *da = [hexString dataUsingEncoding:NSASCIIStringEncoding];
    const size_t numBytes = [da length];
    const unsigned char* bytes = [da bytes];
    char *strbuf = (char *)malloc(numBytes / 2);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    return [[NSData alloc] initWithBytes:hex length:numBytes * 2 + 1];
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
