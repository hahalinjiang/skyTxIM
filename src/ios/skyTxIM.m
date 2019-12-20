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
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"201" forKey:@"code"];
        [dic setValue:@"设置监听成功" forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }else{
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"202" forKey:@"code"];
        [dic setValue:@"设置监听失败" forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
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
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"201" forKey:@"code"];
        [dic setValue:@"设置监听成功" forKey:@"message"];
        [dic setValue:@[] forKey:@"list"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }else{
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"202" forKey:@"code"];
        [dic setValue:@"设置监听失败" forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}
//usrsig过期监听
- (void)sigExpired:(CDVInvokedUrlCommand*)command{
    CDVPluginResult*pluginResult =nil;
    NSString*callbackidStr=  command.callbackId;
    if (callbackidStr!=nil) {
        self.m_expiredCommand = command;
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"201" forKey:@"code"];
        [dic setValue:@"设置监听成功" forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }else{
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"202" forKey:@"code"];
        [dic setValue:@"设置监听失败" forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}
//发送被踢
+(void)sendKickOff:(NSString*)message{
    TxIMDelegate* delegate = (TxIMDelegate*)[UIApplication sharedApplication].delegate;
    skyTxIM* plugin = (skyTxIM*)[delegate.viewController.commandDelegate getCommandInstance:@"skyTxIM"];
    CDVPluginResult*pluginResult =nil;
    if (plugin != nil && plugin.m_IMCommand != nil) {
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"200" forKey:@"code"];
        [dic setValue:message forKey:@"obj"];
        [dic setValue:message forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [plugin objectToJson:dic];
        NSString*callbackidStr=  plugin.m_kickCommand.callbackId;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
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
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"200" forKey:@"code"];
        [dic setValue:message forKey:@"obj"];
        [dic setValue:message forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [plugin objectToJson:dic];
        NSString*callbackidStr=  plugin.m_expiredCommand.callbackId;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        pluginResult.keepCallback=  [NSNumber numberWithInt:1];
        [plugin.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }
}

//发送消息给js端
+(void)SendImMessageToJs:(NSString*)message{
    TxIMDelegate* delegate = (TxIMDelegate*)[UIApplication sharedApplication].delegate;
    skyTxIM* plugin = (skyTxIM*)[delegate.viewController.commandDelegate getCommandInstance:@"skyTxIM"];
    CDVPluginResult*pluginResult =nil;
    if (plugin != nil && plugin.m_IMCommand != nil) {
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:@"200" forKey:@"code"];
        [dic setValue:message forKey:@"obj"];
        [dic setValue:@"收到消息成功" forKey:@"message"];
        [dic setValue:boolNumber forKey:@"success"];
        NSString* callStr = [plugin objectToJson:dic];
        NSString*callbackidStr=  plugin.m_IMCommand.callbackId;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
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
            NSNumber *boolNumber = [NSNumber numberWithBool:NO];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
            [dic setValue:@"202" forKey:@"code"];
            [dic setValue:@"发送消息失败" forKey:@"obj"];
            [dic setValue:@"发送消息失败" forKey:@"list"];
            [dic setValue:boolNumber forKey:@"success"];
            NSString* callStr = [self objectToJson:dic];
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }else{
            NSNumber *boolNumber = [NSNumber numberWithBool:YES];
            NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
            [dic2 setValue:@"200" forKey:@"code"];
            [dic2 setValue:info forKey:@"obj"];
            [dic2 setValue:@"发送消息成功" forKey:@"obj"];
            [dic2 setValue:boolNumber forKey:@"success"];
            NSString* callStr = [self objectToJson:dic2];
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
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
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:@"loginsuccess" forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(int code, NSString * _Nonnull msg) {
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"202" forKey:@"code"];
        [dic2 setValue:msg forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        NSLog(@"IM登录失败");
    }];
}

-(void)loginOutIM:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    [ImChatCenter LoginOutIm:^(int code, NSString * _Nonnull msg) {
        if(code==0){  //登出成功
            NSNumber *boolNumber = [NSNumber numberWithBool:YES];
            NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
            [dic2 setValue:@"200" forKey:@"code"];
            [dic2 setValue:@"loginoutsuccess" forKey:@"message"];
            [dic2 setValue:boolNumber forKey:@"success"];
            NSString* callStr = [self objectToJson:dic2];
            CDVPluginResult*pluginResult =nil;
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
        }else if(code == 1)  //登出失败
        {
            NSNumber *boolNumber = [NSNumber numberWithBool:NO];
            NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
            [dic2 setValue:@"202" forKey:@"code"];
            [dic2 setValue:msg forKey:@"message"];
            [dic2 setValue:boolNumber forKey:@"success"];
            NSString* callStr = [self objectToJson:dic2];
            CDVPluginResult*pluginResult =nil;
            pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
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
    [ImChatCenter getMessage:receiverId num:count callBack:^(NSArray * _Nonnull array) {
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:@"历史消息获取成功" forKey:@"message"];
        [dic2 setValue:array forKey:@"list"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(NSString * _Nonnull msgs) {
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"202" forKey:@"code"];
        [dic2 setValue:msgs forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
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
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:@"设置成功" forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(NSString* msg) {
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"202" forKey:@"code"];
        [dic2 setValue:msg forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
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
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:@{@"num":count} forKey:@"obj"];
        [dic2 setValue:@"获取未读数量成功" forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    } error:^(NSString* flag) {
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"202" forKey:@"code"];
        [dic2 setValue:@"获取失败" forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:callStr];
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
    [ImChatCenter getLastMsg:receiverId callBack:^(NSMutableDictionary * _Nonnull dic) {
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:dic forKey:@"obj"];
        [dic2 setValue:@"获取最近一条消息成功" forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }];
}
-(void)getConversationList:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    [ImChatCenter getConversationList:^(NSMutableArray * array) {
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:@"获取会话列表成功" forKey:@"message"];
        [dic2 setValue:array forKey:@"list"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        CDVPluginResult*pluginResult =nil;
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }];
    
}
-(void)setNotificationNum:(CDVInvokedUrlCommand*)command{
    NSString*callbackidStr=  command.callbackId;
    NSString* info = nil;
    if ([command.arguments count]>0) {
        info=[command.arguments objectAtIndex:0];
    }
    int NUM = [info intValue];
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = NUM;
    
    NSNumber *boolNumber = [NSNumber numberWithBool:YES];
    NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic2 setValue:@"200" forKey:@"code"];
    [dic2 setValue:@"设置成功" forKey:@"message"];
    [dic2 setValue:boolNumber forKey:@"success"];
    NSString* callStr = [self objectToJson:dic2];
    CDVPluginResult*pluginResult =nil;
    pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
}
-(void)getOnlineUser:(CDVInvokedUrlCommand*)command{
    
    NSString*callbackidStr=  command.callbackId;
    
    NSNumber *boolNumber = [NSNumber numberWithBool:YES];
    
    
    [ImChatCenter getOnlineUser:^(NSMutableDictionary * _Nonnull dic) {
        CDVPluginResult*pluginResult =nil;
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic2 setValue:@"200" forKey:@"code"];
        [dic2 setValue:dic forKey:@"obj"];
        [dic2 setValue:@"获取用户名和连接状态成功" forKey:@"message"];
        [dic2 setValue:boolNumber forKey:@"success"];
        NSString* callStr = [self objectToJson:dic2];
        pluginResult= [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callStr];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackidStr];
    }];
    
   
}

-(NSString*)objectToJson:(id) o_bject{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o_bject options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}




@end
