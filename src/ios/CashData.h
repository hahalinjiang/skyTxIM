//
//  CashData.h
//  VideoFrame
//
//  Created by gu yong on 2019/8/18.
//  Copyright © 2019年 gu yong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
NS_ASSUME_NONNULL_BEGIN

#define Key_UserInfo_Appid @"Key_UserInfo_Appid"
#define Key_UserInfo_User  @"Key_UserInfo_User"
#define Key_UserInfo_Pwd   @"Key_UserInfo_Pwd"
#define Key_UserInfo_Sig   @"Key_UserInfo_Sig"
#define key_UserInfo_Id    @"Key_UserInfo_Id"

#define sdkBusiId         14983       // 14983 开发证书id  14984 生产环境  已经废弃这个字段（改用在.plist文件中了）
#define BUGLY_APP_ID      @"e965e5d928"

@interface CashData : NSObject
{
}

@property(nonatomic,assign)id m_delegate;
@property(nonatomic,retain)NSData *deviceToken;
@property(nonatomic,retain)NSDictionary* __nullable m_currentVideoDic;
+(CashData*)shareConstance;
@end

NS_ASSUME_NONNULL_END
