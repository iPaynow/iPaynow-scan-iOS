//
//  IPNPreSignMessageUtil.h
//  TestPlugin
//
//  Created by 刘宁 on 14/12/2.
//  Copyright (c) 2014年 Ipaynow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPNPreSignMessageUtil : NSObject

@property (nonatomic,strong) NSString *appId;
@property (nonatomic,strong) NSString *mhtOrderNo;
@property (nonatomic,strong) NSString *mhtOrderName;
@property (nonatomic,strong) NSString *mhtOrderType;
@property (nonatomic,strong) NSString *mhtCurrencyType;
@property (nonatomic,strong) NSString *mhtOrderAmt;
@property (nonatomic,strong) NSString *mhtOrderDetail;
@property (nonatomic,strong) NSString *mhtOrderStartTime;
@property (nonatomic,strong) NSString *notifyUrl;
@property (nonatomic,strong) NSString *mhtCharset;

@property (nonatomic,strong) NSString *consumerId;
@property (nonatomic,strong) NSString *consumerName;
@property (nonatomic,strong) NSString *mhtOrderTimeOut;
@property (nonatomic,strong) NSString *mhtReserved;
@property (nonatomic,strong) NSString *payChannelType;

-(NSString *)generatePresignMessage;

@end
