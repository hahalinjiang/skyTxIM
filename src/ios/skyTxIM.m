//
//  skyTxIM.m
//  YTH
//
//  Created by guyong on 2019/12/3.
//

#import "skyTxIM.h"
#import "TxIMDelegate.h"
#import "CashData.h"
#import "ImChatCenter.h"

@implementation skyTxIM

#pragma mark -im消息机制
- (void)receiveMsg:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if (callbackidStr!=nil) {
            self.m_IMCommand = command;
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"设置监听成功"];
            pluginResult.keepCallback=  [NSNumber numberWithInt:1];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }else{
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"设置监听失败"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}

//监听下线消息
- (void)kickoutLine:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if (callbackidStr!=nil) {
        self.m_kickCommand = command;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"设置被踢监听成功"];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }else{
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"设置被踢监听失败"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}
//usrsig过期监听
- (void)sigExpired:(CDVInvokedUrlCommand*)command{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if (callbackidStr!=nil) {
        self.m_expiredCommand = command;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"设置被踢监听成功"];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }else{
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"设置被踢监听失败"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}
//发送被踢
+(void)sendKickOff:(NSString*)message{
    TxIMDelegate* delegate = (TxIMDelegate*)[UIApplication sharedApplication].delegate;
    skyTxIM* plugin = (skyTxIM*)[delegate.viewController.commandDelegate getCommandInstance:@"skyTxIM"];
    CDVPluginResult*pluginResult =nil;
    if (plugin != nil && plugin.m_IMCommand != nil) {
        NSString*callbackidStr=  plugin.m_kickCommand.callbackId;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [plugin.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
    
}
//发送过期
+(void)sendSigExpired:(NSString*)message{
    TxIMDelegate* delegate = (TxIMDelegate*)[UIApplication sharedApplication].delegate;
    skyTxIM* plugin = (skyTxIM*)[delegate.viewController.commandDelegate getCommandInstance:@"skyTxIM"];
    CDVPluginResult*pluginResult =nil;
    if (plugin != nil && plugin.m_IMCommand != nil) {
        NSString*callbackidStr=  plugin.m_expiredCommand.callbackId;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [plugin.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}

//发送消息给js端
+(void)SendImMessageToJs:(NSString*)messgae{
    TxIMDelegate* delegate = (TxIMDelegate*)[UIApplication sharedApplication].delegate;
    skyTxIM* plugin = (skyTxIM*)[delegate.viewController.commandDelegate getCommandInstance:@"skyTxIM"];
    CDVPluginResult*pluginResult =nil;
    if (plugin != nil && plugin.m_IMCommand != nil) {
        NSString*callbackidStr=  plugin.m_IMCommand.callbackId;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:messgae];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [plugin.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}
-(void)sendMessageJsToIm:(CDVInvokedUrlCommand*)command{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    NSString* info = nil;
    if ([command.arguments count]>0) {
       info=[command.arguments objectAtIndex:0];
    }
    if (callbackidStr!=nil) {
        if (info == nil) {
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"发送失败"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }else{
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:info];
            NSData *jsonData = [info dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
             [ImChatCenter onChatWithSingle:info sender:[dic objectForKey:@"sendTid"]];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }
    }
}

-(void)loginIM:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    NSDictionary* info = nil;
    if ([command.arguments count]>0) {
        info=[command.arguments objectAtIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[info valueForKey:@"sdkAppId"] forKey:Key_UserInfo_Appid];
    [[NSUserDefaults standardUserDefaults] setValue:[info valueForKey:@"userId"] forKey:key_UserInfo_Id];
    [[NSUserDefaults standardUserDefaults] setValue:[info valueForKey:@"userSig"] forKey:Key_UserInfo_Sig];
    [ImChatCenter LoginOnlyIm:^(int code, NSString * _Nonnull msg) {
        NSLog(@"IM登录成功");
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"登录成功"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(int code, NSString * _Nonnull msg) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        NSLog(@"IM登录失败");
    }];
}

-(void)loginOutIM:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    [ImChatCenter LoginOutIm:^(int code, NSString * _Nonnull msg) {
        if(code==0){  //登出成功
            CDVPluginResult*pluginResult =nil;
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }else if(code == 1)  //登出失败
        {
            CDVPluginResult*pluginResult =nil;
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }
    }];
}
//获取历史消息
-(void)histroyMessage:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    NSDictionary* info = nil;
    if ([command.arguments count]>0) {
        info=[command.arguments objectAtIndex:0];
    }
    int count = [[info valueForKey:@"num"] intValue];
    NSString* receiverId = [info valueForKey:@"receiverId"];
    [ImChatCenter getMessage:receiverId num:count callBack:^(NSString * _Nonnull string) {
        CDVPluginResult*pluginResult =nil;
               pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:string];
               [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(NSString * _Nonnull msgs) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msgs];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }];
}
//设置已读
-(void)setReadMessage:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    NSDictionary* info = nil;
    if ([command.arguments count]>0) {
        info=[command.arguments objectAtIndex:0];
    }
    NSString* receiverId = [info valueForKey:@"receiverId"];
    [ImChatCenter setReadMessage:receiverId callBack:^(int flag) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"成功"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(NSString* msg) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];

    }];
}
//获取未读数目
-(void)getUnReadMessageNum:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    NSDictionary* info = nil;
    if ([command.arguments count]>0) {
        info=[command.arguments objectAtIndex:0];
    }
    NSString* receiverId = [info valueForKey:@"receiverId"];
    [ImChatCenter getUnReadMessageNum:receiverId callBack:^(NSString* count) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:count];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(NSString* flag) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:flag];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }];
}

-(void)getLastMsg:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
       NSDictionary* info = nil;
       if ([command.arguments count]>0) {
           info=[command.arguments objectAtIndex:0];
       }
       NSString* receiverId = [info valueForKey:@"receiverId"];
      [ImChatCenter getLastMsg:receiverId callBack:^(NSString * _Nonnull str) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
      }];
}
-(void)getConversationList:(CDVInvokedUrlCommand*)command{
     NSString*callbackidStr=  command.callbackId;
    [ImChatCenter getConversationList:^(NSString * str) {
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }];
    
}


@end
