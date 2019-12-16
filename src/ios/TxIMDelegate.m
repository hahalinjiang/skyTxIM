//
//  TxIMDelegate.m
//  YTH
//
//  Created by guyong on 2019/12/3.
//

#import "TxIMDelegate.h"
#import "CashData.h"
#import "skyTxIM.h"
#import "ImChatCenter.h"

@implementation TxIMDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [CashData shareConstance].m_delegate = self;
    [self registNotification];
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(void)sendIMMessage:(NSDictionary*) senderDic{
//
//    NSString* myOwnTXId = [[NSUserDefaults standardUserDefaults] objectForKey:key_UserInfo_Id];
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
//    [dic setValue:@"201" forKey:@"flag"];
//    [dic setValue:myOwnTXId forKey:@"fromId"];
//    [dic setValue:@"refuse" forKey:@"action"];
//
//    NSString* senderId =[senderDic objectForKey:@"sendTid"];
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString;
//    if (!jsonData) {
//        NSLog(@"%@",error);
//    }else{
//        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//    [ImChatCenter onChatWithSingle:mutStr sender:senderId];
//}

- (void)onNewMessage:(NSArray*) msgs{
    NSLog(@"msgs = %@",msgs);
    if (msgs.count>0) {
        TIMMessage * message = [msgs objectAtIndex:[msgs count]-1];
        if (message.elemCount>0) {
            TIMElem * elem = [message getElem:0];
            if ([elem isKindOfClass:[TIMTextElem class]]) {  //文本信息
                TIMTextElem * text_elem = (TIMTextElem * )elem;
                NSLog(@"text = %@",text_elem.text);
                //发送给js端信息
                NSString*replacedStr = [text_elem.text stringByReplacingOccurrencesOfString:@"&quot;"withString:@"\""];
                [self SendJsImMessage:replacedStr];
            }else{  //非文本信息不接收
                
            }
            
        }

    }
}
#pragma mark- 用户状态回调
- (void)onForceOffline{
    [self BackLogin:1];
    NSLog(@"onForceOffline");
}
/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err{
    NSLog(@"onReConnFailed");
}
/**
 *  用户登录的 userSig 过期（用户需要重新获取 userSig 后登录）
 */
- (void)onUserSigExpired{
    [self BackLogin:2];
    NSLog(@"onUserSigExpired");
}


#pragma mark - 推送注册

- (void)registNotification
{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken API_AVAILABLE(ios(3.0)){
      [CashData shareConstance].deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error API_AVAILABLE(ios(3.0)){
    NSLog(@"error = %@",error.description);
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];

    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
 [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //doBackground
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[TIMManager sharedInstance] doForeground:^() {
        NSLog(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}

void uncaughtExceptionHandler(NSException*exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}

-(void)BackLogin:(int)flag{
  
    if (flag == 1) {  //被踢下线的
        NSString* g_str = @"{\"flag\":\"902\",\"action\":\"offline\",\"content\":\"被踢下线\"}";
        [skyTxIM sendKickOff:g_str];
    }else if(flag == 2){  //用户usersig过期
        NSString* g_str = @"{\"flag\":\"903\",\"action\":\"expired\",\"content\":\"sig过期\"}";
        [skyTxIM sendSigExpired:g_str];
    }
}
#pragma mark -和js端互相发送消息
-(void)SendJsImMessage:(NSString*)messgae{
    [skyTxIM SendImMessageToJs:messgae];
}


@end
