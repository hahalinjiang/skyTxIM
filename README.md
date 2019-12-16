cordova-plugin-skyTxIM Cordova plugin
========

集成IM聊天的Cordova插件功

Installation
--------

```bash
cordova plugin add cordova-plugin-skyTxIM
```

※ Support Android SDK >= 14

API
--------

### 登录IM

```loginIM
 var userId = "txy_cq_001";
    var userSig = "eJyrVgrxCdZLrSjILEpVsjI0NTU1MjAw0AGLlqUWKVkpGekZKEH4xSnZiQUFmSlAdSYGBkaWxkZGlhCZzJTUvJLMtEywhpKKyvjkwngDA0OYvsx0oHBimqGrflW*eUiAb4pxSaKZkYdrUlBxaHpASK5PUpa-SUZUVa5belhlSVWyLVRjSWYu2FHmpsZmpsYmlrUAPcAzdA__";
    var sdkAppId = "1400293229";
    var params = {
        userId: userId,
        userSig: userSig,
        sdkAppId: sdkAppId,
    };
    sky.cqfw.loginIM(function (success) {
        console.log("success---->", success);
        initKickoutLine();
    }, function (error) {
        console.log("error---->", error);

    },params);
```

#### 登出.
```loginOutIM
sky.cqfw.loginOutIM(function (success) {
        console.log("success---->", success);

    }, function (error) {
        console.log("error---->", error);

    });
```

### 历史消息

```histroyMessage
    var info = {
        receiverId: "txy_cq_002",
        num: 3,
    };
    sky.cqfw.histroyMessage(function (success) {
        console.log("success---->", success);

    }, function (error) {
        console.log("error---->", error);

    }, info);
```
|参数名|类型|说明|
|:-----  |:-----|-----                           |
|MSGID  |string   |消息ID |
|SENDERID  | String  |发送人ID |
|CONTENT  |String   |消息内容 |
|TIME  |String   |发消息事件 |
## 设置消息已读
```setReadMessage
  var info = {
        receiverId: "txy_cq_002",
    };
    sky.cqfw.setReadMessage(function (success) {
        console.log("success---->", success);

    }, function (error) {
        console.log("error---->", error);

    }, info);
```
#### 获取未读消息数量
```getUnReadMessageNum
 var info = {
        receiverId: "txy_cq_002",
    };
    sky.cqfw.getUnReadMessageNum(function (success) {
        console.log("success---->", success);

    }, function (error) {
        console.log("error---->", error);

    }, info);
```
|参数名|类型|说明|
|:-----  |:-----|-----                           |
|num  |string   |消息数量 |

#### 获取最近一条消息
```getLastMsg
  var info = {
        receiverId: "txy_cq_002",
    };
    sky.cqfw.getLastMsg(function (success) {
        console.log("success---->", success);

    }, function (error) {
        console.log("error---->", error);

    }, info);
```

|参数名|类型|说明|
|:-----  |:-----|-----                           |
|MSGID  |string   |消息ID |
|SENDERID  | String  |发送人ID |
|CONTENT  |String   |消息内容 |
|TIME  |String   |发消息事件 |

#### 获取会话列表
```getConversationList
  sky.cqfw.getConversationList(function (success) {
        console.log("success---->", success);

    }, function (error) {
        console.log("error---->", error);

    });
```
|参数名|类型|说明|
|:-----  |:-----|-----                           |
|ConversationId  |string   |发送人的ID |
|Type  | String  |C2C 类型1,群聊 类型2、系统消息 3, |
|GroupName  |String   |分组 |

#### 发送消息
```sendMessageJsToIm
  var msgJO = {
        "flag": "901",
        "sendTid": "txy_cq_002",
        "fromId": "0001",
        "fromName": "admin5",
        "action": "message",
        "content": "发送测试"
    };
    var str = JSON.stringify(msgJO);
    sky.cqfw.sendMessageJsToIm(function (data) {
        console.info("成功---->", data);
    }, function (data) {
        console.info("失败---->", data);
    }, [str]);
```
#### 发送消息
```sendMessageJsToIm
  var msgJO = {
        "flag": "901",
        "sendTid": "txy_cq_002",
        "fromId": "0001",
        "fromName": "admin5",
        "action": "message",
        "content": "发送测试"
    };
    var str = JSON.stringify(msgJO);
    sky.cqfw.sendMessageJsToIm(function (data) {
        console.info("成功---->", data);
    }, function (data) {
        console.info("失败---->", data);
    }, [str]);
```
#### 接收消息监听
```receiveMsg
    sky.cqfw.on("receiveMsg", function (data) {  //消息监听
         console.info("receiveMsg成功---->", data);
 
     }, function (data) {
         console.info("receiveMsg失败---->", data);
 
     });
```

#### 被挤下线监听
```kickoutLine
    sky.cqfw.on("kickoutLine", function (data) {  //被挤下线监听
         console.info("kickoutLine成功---->", data);
 
     }, function (data) {
         console.info("kickoutLine失败---->", data);
 
     });
```
#### sign过期监听
```sigExpired
    sky.cqfw.on("sigExpired", function (data) {  //sign过期监听
         console.info("sigExpired成功---->", data);
 
     }, function (data) {
         console.info("sigExpired失败---->", data);
 
     });
```
####公共返回参数说明

|参数名|类型|说明|
|:-----  |:-----|-----                           |
|code  |string   |三个事件监听，监听成功返回201、有数据返回 200、错误返回202 |
|obj  |Object   |返回单个对象 |
|list  |Object   |返回列表 |
|success  |Boolean   |返回成功失败状态 |


备注
--------

    此插件适用Android和Ios,适用前需要购买腾讯IM服务
    https://cloud.tencent.com/document/product/269
# skyTxIM
