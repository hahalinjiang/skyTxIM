//
//  skyTxIM.h
//  YTH
//
//  Created by guyong on 2019/12/3.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface skyTxIM : CDVPlugin
@property(nonatomic,retain)CDVInvokedUrlCommand* m_IMCommand;
@property(nonatomic,retain)CDVInvokedUrlCommand* m_kickCommand;
@property(nonatomic,retain)CDVInvokedUrlCommand* m_expiredCommand;
-(void)sendMessageJsToIm:(CDVInvokedUrlCommand*)command;
-(void)receiveMsg:(CDVInvokedUrlCommand*)command;
- (void)sigExpired:(CDVInvokedUrlCommand*)command;
- (void)kickoutLine:(CDVInvokedUrlCommand*)command;
-(void)loginOutIM:(CDVInvokedUrlCommand*)command;
-(void)loginIM:(CDVInvokedUrlCommand*)command;
-(void)histroyMessage:(CDVInvokedUrlCommand*)command;
+(void)SendImMessageToJs:(NSString*)messgae;
+(void)sendKickOff:(NSString*)message;
+(void)sendSigExpired:(NSString*)message;

-(void)getConversationList:(CDVInvokedUrlCommand*)command;
-(void)getLastMsg:(CDVInvokedUrlCommand*)command;
//获取未读数目
-(void)getUnReadMessageNum:(CDVInvokedUrlCommand*)command;
//设置已读
-(void)setReadMessage:(CDVInvokedUrlCommand*)command;

@end

NS_ASSUME_NONNULL_END
