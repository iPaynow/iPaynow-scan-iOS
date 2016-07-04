//
//  IPNTransDelegate.h
//  IPNMarket
//
//  Created by 刘宁 on 15/3/19.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import <Foundation/Foundation.h>

static  NSString* kOrderInitTimeout=@"PE001"; //订单初始化超时
static  NSString* kHttpRequestError=@"PE002";//网络请求异常
static  NSString* kTransCancelFail=@"PE003";   //冲正失败
static  NSString* kTransCancelTimeOut=@"PE004";//冲正超时
static  NSString* kCameraAccessError=@"PE005";//相机权限获取失败

typedef NS_ENUM(NSInteger, IPNPayResult) {
    IPNPayResultFail                     ,  //失败
    IPNPayResultSuccess             ,  //成功
    IPNPayResultCancel               ,  //撤销
    IPNPayResultUnknown                //未知
};

@protocol IPNTransDelegate
-(void)returnTransResult:(IPNPayResult)result errCode:(NSString *)errCode info:(NSString *)info;
@end

