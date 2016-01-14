//
//  IPNTransSDK.h
//  IPNMposMarket
//
//  Created by 刘宁 on 15/3/23.
//  Copyright (c) 2015年 刘宁. All rights reserved.
//

#import "IPNTransDelegate.h"
#import <UIKit/UIKit.h>

@interface IPNTransSDK : NSObject

+(void) payByData:(NSString *)data viewController:(UIViewController*)viewController delegate:(id<IPNTransDelegate>)delegate;

@end
