//
//  CashData.m
//  VideoFrame
//
//  Created by gu yong on 2019/8/18.
//  Copyright © 2019年 gu yong. All rights reserved.
//

#import "CashData.h"
static CashData* cashData = nil;
@implementation CashData
@synthesize m_delegate;
@synthesize deviceToken;
@synthesize m_currentVideoDic;

+(CashData*)shareConstance{
    if (cashData == nil) {
        cashData =[[CashData alloc]init];
    }
   return cashData;
}

@end
