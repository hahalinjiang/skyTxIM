//
//  TxIMDelegate.h
//  YTH
//
//  Created by guyong on 2019/12/3.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <Cordova/CDVAppDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface TxIMDelegate : CDVAppDelegate<TIMUserStatusListener,TIMMessageListener,UIApplicationDelegate>
//-(void)SendJsToIm:(NSString*)messgae;
@end

NS_ASSUME_NONNULL_END
