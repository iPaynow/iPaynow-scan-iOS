//
//  ViewController.m
//  IPNMarket
//
//  Created by 刘宁 on 15/2/9.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import "ViewController.h"
#import <IPNScannerSDK/IPNPreSignMessageUtil.h>
#import <IPNScannerSDK/IPNTransSDK.h>

#define kVCTitle            @"支付测试"
#define kBtnFirstTitle    @"获取订单，开始支付"
#define kWaiting           @"正在获取订单,请稍候..."
#define kNote               @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult             @"支付结果："
#define kSignURL         @"http://posp.ipaynow.cn/ZyPluginPaymentTest_PAY/api/pay2.php"

@interface ViewController ()<IPNTransDelegate>
- (IBAction)pay:(id)sender;

@end

@implementation ViewController
{
    UIAlertView* mAlert;
    NSString *_traceNo;
    
    NSMutableData *mData;
    NSString *_presignStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pay:(id)sender {
    [self doSignature];
}

-(void)returnTransResult:(IPNPayResult)result errCode:(NSString *)errCode info:(NSString *)info{
    if (result==IPNPayResultSuccess) {
        [self showAlertMessage:@"交易成功"];
    }else if (result==IPNPayResultFail)
            [self showAlertMessage:[NSString stringWithFormat:@"交易失败，原因：%@",info]];
    else if (result==IPNPayResultCancel)
            [self showAlertMessage:@"交易被取消"];
    else
            [self showAlertMessage:@"交易结果未知"];
}

#pragma mark  签名处理
-(void)doSignature{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    IPNPreSignMessageUtil *preSign=[IPNPreSignMessageUtil new];
    preSign.appId=@"1450659768775911";
    preSign.consumerId=@"IPN_001";
    preSign.consumerName=@"1号消费者";
    preSign.mhtOrderNo=[dateFormatter stringFromDate:[NSDate date]];
    preSign.mhtOrderName=@"IOS插件测试用例";
    preSign.mhtOrderType=@"01";
    preSign.mhtCurrencyType=@"156";
    preSign.mhtOrderAmt=@"1";
    preSign.mhtOrderDetail=@"关于订单验证接口的测试";
    preSign.mhtOrderStartTime=[dateFormatter stringFromDate:[NSDate date]];
    preSign.notifyUrl=@"http://localhost:10802/";
    preSign.mhtCharset=@"UTF-8";
    preSign.mhtOrderTimeOut=@"3600";
    
    NSString *originStr=[preSign generatePresignMessage];
    
    NSString *outputStr = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)originStr,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8));
    
    
    _presignStr = [[preSign generatePresignMessage] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _presignStr= originStr;
    NSString *presignStr=@"paydata=";
    presignStr=[presignStr stringByAppendingString:outputStr];
    
    NSURL* url = [NSURL URLWithString:kSignURL];
    NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlRequest.HTTPBody=[presignStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
    
    [self showAlertWait];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    int code = (int)[rsp statusCode];
    if (code != 200) {
    } else {
        if (mData != nil) {
            mData = nil;
        }
        mData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self hideAlert];
    
    NSString* data = [[NSMutableString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    NSString* payData=[_presignStr stringByAppendingString:@"&"];
    payData=[payData stringByAppendingString:data];
    
    [IPNTransSDK payByData:payData viewController:self delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self hideAlert];
    [self showAlertMessage:kErrorNet];
}

- (void)showAlertMessage:(NSString*)msg{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kNote
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:kConfirm
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)showAlertWait {
    mAlert = [[UIAlertView alloc] initWithTitle:@"正在获取订单..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
}

- (void)hideAlert {
    if (mAlert != nil){
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}
@end
