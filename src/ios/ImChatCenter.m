//
//  ImChatCenter.m
//  TRTCDemo
//
//  Created by gu yong on 2019/8/16.
//  Copyright © 2019年 rushanting. All rights reserved.
//

#import "ImChatCenter.h"
#import "CashData.h"

@implementation ImChatCenter

+(void)LoginOnlyIm:(void(^)(int code, NSString * msg))success error:(void(^)(int code, NSString * msg))error {
    int sdkAppId = [[[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Appid] intValue];
    TIMSdkConfig* sdkconfig = [[TIMSdkConfig alloc]init];
    sdkconfig.sdkAppId = sdkAppId;
    [[TIMManager sharedInstance] initSdk:sdkconfig];
//    [[TIMManager sharedInstance] addMessageListener:[CashData shareConstance].m_delegate];
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.identifier = [[NSUserDefaults standardUserDefaults] objectForKey:key_UserInfo_Id];
    param.userSig =[[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Sig];
    [[TIMManager sharedInstance] login:param succ:^{
        CashData* delegate = [CashData shareConstance];
        NSData *deviceToken = delegate.deviceToken;
        if (deviceToken) {
            TIMTokenParam *param = [[TIMTokenParam alloc] init];
            /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
            //企业证书 ID
            param.busiId = sdkBusiId;
            [param setToken:deviceToken];
            [[TIMManager sharedInstance] setToken:param succ:^{
                NSLog(@"-----> 上传 token 成功 ");
                [[TIMManager sharedInstance] addMessageListener:[CashData shareConstance].m_delegate];
                TIMUserConfig* userConfig = [[TIMUserConfig alloc]init];
                [userConfig setUserStatusListener:[CashData shareConstance].m_delegate];
                [[TIMManager sharedInstance] setUserConfig:userConfig];
            } fail:^(int code, NSString *msg) {
                NSLog(@"-----> 上传 token 失败 ");
            }];
        }
        success(0,@"成功");
        
    } fail:^(int code, NSString *msg) {
        error(code,@"失败");
    }];
}

+(void)LoginOutIm:(void(^)(int code, NSString * msg))success{
    [[TIMManager sharedInstance] logout:^{
        NSLog(@"登出成功");
        success(0,@"登出成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"登出失败code=%i, msg = %@",code,msg.description);
        success(1,msg.description);
    }];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:NULL forKey:key_UserInfo_Id];
    [userDefault setValue:NULL forKey:Key_UserInfo_Sig];
}

+(void)onChatWithSingle:(NSString*)message sender:(NSString*)receiverID{
    //单聊
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:receiverID];
    //群聊
    //    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:@"TGID1JYSZEAEQ"];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:message];
    
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo* offlinePushInfo = [[TIMOfflinePushInfo alloc]init];
    offlinePushInfo.desc = message;
    offlinePushInfo.pushFlag = TIM_OFFLINE_PUSH_DEFAULT;
    [msg setOfflinePushInfo:offlinePushInfo];
    [msg addElem:text_elem];
    [c2c_conversation sendMessage:msg succ:^{
    } fail:^(int code, NSString *error) {
    }];
    
    
}

+(void)getMessage:(NSString*)receiverID num:(int)num callBack:(void(^)(NSArray* array))callB_S error:(void(^)(NSString*))callB_E{
     TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:receiverID];
    [c2c_conversation getMessage:num last:nil succ:^(NSArray *msgs) {
        NSMutableArray* g_array = [[NSMutableArray alloc] initWithCapacity:2];
        for (int i = 0; i<[msgs count]; i++) {
            TIMMessage* message = [msgs objectAtIndex:i];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
            
            //日期
            NSDate* date = [message timestamp];
            NSDateFormatter* g_dateformate = [[NSDateFormatter alloc]init];
            [g_dateformate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString* g_dateStr = [g_dateformate stringFromDate:date];
            [dic setValue:g_dateStr forKey:@"TIME"];
            //内容
            TIMElem* t_elem= [message getElem:0];
            if (![t_elem isKindOfClass:[TIMTextElem class]]) {  //非文本的不接收
                continue;
            }
            TIMTextElem* elem =  (TIMTextElem*)t_elem;
            NSString* content = elem.text;
            [dic setValue:content forKey:@"CONTENT"];
            //发送人
            NSString* senderId = message.sender;
            [dic setValue:senderId forKey:@"SENDERID"];
            //消息id
            NSString* msgID =message.msgId;
            [dic setValue:msgID forKey:@"MSGID"];
            [g_array addObject:dic];
        }
        NSLog(@"msgs = %@",msgs);
//        NSData *data = [NSJSONSerialization dataWithJSONObject:g_array
//                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
//                                                         error:nil];
//        NSString *string = [[NSString alloc] initWithData:data
//                                                 encoding:NSUTF8StringEncoding];
        callB_S(g_array);
    } fail:^(int code, NSString *msg) {
        NSLog(@"msg = %@",msg);
        callB_E(msg);
    }];
}
//设置已读
+(void)setReadMessage:(NSString*)receiverID callBack:(void(^)(int flag))callB_S error:(void(^)(NSString* msg))callB_E{
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:receiverID];
        [c2c_conversation setReadMessage:nil  succ:^{
            callB_S(0);
        } fail:^(int code, NSString *msg) {
            callB_E(msg);
        }];
}
+(void)getUnReadMessageNum:(NSString*)receiverID callBack:(void(^)(NSString* flag))callB_S error:(void(^)(NSString* flag))callB_E{
        TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:receiverID];
        int count = [c2c_conversation getUnReadMessageNum];
        NSString* g_count = [NSString stringWithFormat:@"%d",count];
        callB_S(g_count);
}
+(void)getLastMsg:(NSString*)receiverID callBack:(void(^)(NSMutableDictionary* dic))callB_S
{
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:receiverID];
    TIMMessage* message = [c2c_conversation getLastMsg];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    //日期
    NSDate* date = [message timestamp];
    NSDateFormatter* g_dateformate = [[NSDateFormatter alloc]init];
    [g_dateformate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString* g_dateStr = [g_dateformate stringFromDate:date];
    [dic setValue:g_dateStr forKey:@"TIME"];
    //内容
    TIMTextElem* elem =  (TIMTextElem*)[message getElem:0];
    if (![elem isKindOfClass:[TIMTextElem class]]) {
        NSMutableDictionary* mulDic = [[NSMutableDictionary alloc]initWithCapacity:2];
        callB_S(mulDic);
        return;
    }
    NSString* content = elem.text;
    [dic setValue:content forKey:@"CONTENT"];
    //发送人
    NSString* senderId = message.sender;
    [dic setValue:senderId forKey:@"SENDERID"];
    //消息id
    NSString* msgID =message.msgId;
    [dic setValue:msgID forKey:@"MSGID"];
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
//                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
//                                                     error:nil];
//    NSString *string = [[NSString alloc] initWithData:data
//                                             encoding:NSUTF8StringEncoding];
    callB_S(dic);
}
//获取会话列表
+(void) getConversationList:(void(^)(NSMutableArray*))callB_S{
    
    NSArray* g_array = [[TIMManager sharedInstance] getConversationList];
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i<[g_array count]; i++) {
        TIMConversation* TimCon = [g_array objectAtIndex:i];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setValue:TimCon.getReceiver forKey:@"ConversationId"];
        /**
          C2C 类型1,
          群聊 类型2
          系统消息 3,
         */
        [dic setValue:[NSString stringWithFormat:@"%d",(int)TimCon.getType] forKey:@"Type"];
        [dic setValue:TimCon.getGroupName forKey:@"GroupName"];
        [array addObject:dic];
    }
//    NSData *data = [NSJSONSerialization dataWithJSONObject:array
//                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
//                                                     error:nil];
//    NSString *string = [[NSString alloc] initWithData:data
//                                             encoding:NSUTF8StringEncoding];
    callB_S(array);
    
}

+(void)getOnlineUser:(void(^)(NSMutableDictionary*))callB_S{
    
    NSString* userId = [[TIMManager sharedInstance] getLoginUser];
    TIMLoginStatus status =  [[TIMManager sharedInstance] getLoginStatus];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setValue:userId forKey:@"userId"];
    NSNumber *boolNumber = [NSNumber numberWithBool:YES];
    if (status==TIM_STATUS_LOGINED) {
        boolNumber = [NSNumber numberWithBool:YES];
    }else{
        boolNumber = [NSNumber numberWithBool:false];
    }
    [dic setValue:boolNumber forKey:@"offline"];
    callB_S(dic);
    
}

@end
