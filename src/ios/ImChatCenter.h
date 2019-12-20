//
//  ImChatCenter.h
//  TRTCDemo
//
//  Created by gu yong on 2019/8/16.
//  Copyright © 2019年 rushanting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImChatCenter : NSObject

+(void)LoginOnlyIm:(void(^)(int code, NSString * msg))success error:(void(^)(int code, NSString * msg))error;
+(void)LoginOutIm:(void(^)(int code, NSString * msg))success;
+(void)onChatWithSingle:(NSString*)message sender:(NSString*)receiverID;
+(void)getMessage:(NSString*)receiverID num:(int)num callBack:(void(^)(NSArray* array))callB_S error:(void(^)(NSString* msgs))callB_E;
+(void)setReadMessage:(NSString*)receiverID callBack:(void(^)(int flag))callB_S error:(void(^)(NSString* msg))callB_E;
+(void)getUnReadMessageNum:(NSString*)receiverID callBack:(void(^)(NSString* flag))callB_S error:(void(^)(NSString* flag))callB_E;
+(void)getLastMsg:(NSString*)receiverID callBack:(void(^)(NSMutableDictionary* dic))callB_S;
//获取会话列表
+(void) getConversationList:(void(^)(NSMutableArray*))callB_S;
//获取用户状态
+(void)getOnlineUser:(void(^)(NSMutableDictionary*))callB_S;
@end

NS_ASSUME_NONNULL_END
