//
//  IPNTransDelegate.h
//  IPNMarket
//
//  Created by 刘宁 on 15/3/19.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IPNPayType) {
    IPNPayTypeAlixPay =32                   ,  //支付宝支付
    IPNPayTypeWechatPay                    ,  //微信支付
};

typedef NS_ENUM(NSInteger, IPNPayResult) {
    IPNPayResultFail                     ,  //失败
    IPNPayResultSuccess             ,  //成功
    IPNPayResultCancel               ,  //撤销
    IPNPayResultUnknown                //未知
};

@protocol IPNTransDelegate
-(void)returnTransResult:(IPNPayResult)result info:(NSString *)info;
@end

