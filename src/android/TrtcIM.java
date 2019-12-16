package com.skytech.skyimplugin;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.ConditionVariable;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.safframework.log.L;
import com.tencent.imsdk.TIMCallBack;
import com.tencent.imsdk.TIMConversation;
import com.tencent.imsdk.TIMConversationType;
import com.tencent.imsdk.TIMManager;
import com.tencent.imsdk.TIMMessage;
import com.tencent.imsdk.TIMMessageListener;
import com.tencent.imsdk.TIMOfflinePushListener;
import com.tencent.imsdk.TIMOfflinePushNotification;
import com.tencent.imsdk.TIMSdkConfig;
import com.tencent.imsdk.TIMTextElem;
import com.tencent.imsdk.TIMUserConfig;
import com.tencent.imsdk.TIMUserStatusListener;
import com.tencent.imsdk.TIMValueCallBack;
import com.tencent.imsdk.ext.message.TIMMessageReceipt;
import com.tencent.imsdk.ext.message.TIMMessageReceiptListener;
import com.tencent.openqq.protocol.imsdk.msg;
import com.tencent.qcloud.tim.uikit.config.TUIKitConfigs;
import com.tencent.qcloud.tim.uikit.modules.chat.C2CChatManagerKit;
import com.tencent.qcloud.tim.uikit.utils.TUIKitLog;
import com.yanzhenjie.permission.Action;
import com.yanzhenjie.permission.AndPermission;
import com.yanzhenjie.permission.Permission;

import org.greenrobot.eventbus.EventBus;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*

 * File: TrtcIM.java

 * Author: jianglj

 * Create: 2019-12-09 17:09

 */public class TrtcIM implements TIMMessageListener {
    private TIMConversation mCurrentConversation;
    private final static String TAG = "TrtcIM";
    private static TUIKitConfigs sConfigs;
    public String userId;
    @SuppressLint("CheckResult")

    /**
     * 初始化
     *
     * @param context
     */
    public void initIM(Context context, String arg) {
        // EventBus.getDefault().register(context);
        setPermission(context);
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = (JSONObject) JSONObject.toJSON(objlist.getJSONObject(0));
        sConfigs = new ConfigHelper().getConfigs();
        TIMSdkConfig sdkConfig = sConfigs.getSdkConfig();
        if (sdkConfig == null) {
            sdkConfig = new TIMSdkConfig(Integer.valueOf(obj.getString("sdkAppId")));
            sConfigs.setSdkConfig(sdkConfig);
        }
        TIMManager.getInstance().init(context, sdkConfig);
        // 设置离线消息通知
        TIMManager.getInstance().setOfflinePushListener(new TIMOfflinePushListener() {
            @Override
            public void handleNotification(TIMOfflinePushNotification timOfflinePushNotification) {

            }
        });
        TIMManager.getInstance().addMessageListener(this);

        onForceOfflineOrSigExpired();
    }



    /**
     * 登录
     */
    public BackJson login(String arg) {
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = (JSONObject) JSONObject.toJSON(objlist.getJSONObject(0));
        BackJson backJson = new BackJson();
        // identifier 为用户名，userSig 为用户登录凭证
        userId=obj.getString("userId");
        final ConditionVariable conditionVariable = new ConditionVariable();
        new Thread(new Runnable() {
            @Override
            public void run() {
                TIMManager.getInstance().login(obj.getString("userId"), obj.getString("userSig"), new TIMCallBack() {
                    @Override
                    public void onError(int code, String desc) {
                        //错误码 code 和错误描述 desc，可用于定位请求失败原因
                        //错误码 code 列表请参见错误码表
                        backJson.setCode(code + "");
                        backJson.setMessage(desc);
                        backJson.setSuccess(false);
                        Log.d(TAG, "login failed. code: " + code + " errmsg: " + desc);
                        conditionVariable.open();
                    }

                    @Override
                    public void onSuccess() {
                        Log.d(TAG, "login succ");
                        backJson.setCode("");
                        backJson.setMessage("login succ");
                        backJson.setSuccess(true);
                        conditionVariable.open();
                    }
                });

            }
        }).start();
        conditionVariable.block();
        return backJson;

    }

    /**
     * 登出
     */
    public BackJson logOut() {
        BackJson backJson = new BackJson();
        final ConditionVariable conditionVariable = new ConditionVariable();
        new Thread(new Runnable() {
            @Override
            public void run() {
                TIMManager.getInstance().logout(new TIMCallBack() {
                    @Override
                    public void onError(int code, String desc) {

                        //错误码 code 和错误描述 desc，可用于定位请求失败原因`
                        //错误码 code 列表请参见错误码表
                        Log.d(TAG, "logout failed. code: " + code + " errmsg: " + desc);
                        backJson.setCode(code + "");
                        backJson.setMessage(desc);
                        backJson.setSuccess(false);
                        conditionVariable.open();
                    }

                    @Override
                    public void onSuccess() {
                        //登出成功
                        Log.d(TAG, "logout success");
                        backJson.setCode("");
                        backJson.setMessage("logout success");
                        backJson.setSuccess(true);
                        conditionVariable.open();
                    }
                });
            }
        }).start();
        conditionVariable.block();
        return backJson;
    }


    /**
     * 历史消息
     *
     * @return
     */
    public BackJson histroyMessage(String arg) {
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = (JSONObject) JSONObject.toJSON(objlist.getJSONObject(0));
        BackJson backJson = new BackJson();
        if (null == mCurrentConversation) {
            mCurrentConversation = TIMManager.getInstance().getConversation(TIMConversationType.C2C, obj.getString("receiverId"));
        }
        final ConditionVariable conditionVariable = new ConditionVariable();
        new Thread(new Runnable() {
            @Override
            public void run() {
                mCurrentConversation.getMessage(obj.getIntValue("num")
                        , null, new TIMValueCallBack<List<TIMMessage>>() {
                            @Override
                            public void onError(int code, String desc) {
                                TUIKitLog.e(TAG, "loadChatMessages() getMessage failed, code = " + code + ", desc = " + desc);
                                backJson.setCode(code + "");
                                backJson.setMessage(desc);
                                backJson.setSuccess(false);
                                conditionVariable.open();
                            }

                            @Override
                            public void onSuccess(List<TIMMessage> timMessages) {
                                List<Object> list = new ArrayList<>();
                                for (TIMMessage msg : timMessages) {
                                    Map<String, String> map = new HashMap<>();
                                    TIMTextElem elem = (TIMTextElem) msg.getElement(0);
                                    map.put("MSGID", msg.getMsgId());
                                    map.put("SENDERID", msg.getSender());
                                    map.put("CONTENT", elem.getText());
                                    map.put("TIME", getDateToString(msg.timestamp()));
                                    list.add(map);
                                    Log.d(TAG, map.toString());

                                }
                                backJson.setCode("");
                                backJson.setMessage("历史消息获取成功");
                                backJson.setSuccess(true);
                                backJson.setList(list);
                                conditionVariable.open();
                            }
                        });
            }
        }).start();
        conditionVariable.block();
        return backJson;
    }

    /**
     * 设置消息为已读
     *
     * @return
     */
    public BackJson setReadMessage(String arg) {
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = (JSONObject) JSONObject.toJSON(objlist.getJSONObject(0));
        BackJson backJson = new BackJson();
        if (null == mCurrentConversation) {
            mCurrentConversation = TIMManager.getInstance().getConversation(TIMConversationType.C2C, obj.getString("receiverId"));
        }
        final ConditionVariable conditionVariable = new ConditionVariable();
        new Thread(new Runnable() {
            @Override
            public void run() {
                mCurrentConversation.setReadMessage(null, new TIMCallBack() {
                    @Override
                    public void onError(int code, String desc) {
                        TUIKitLog.e(TAG, "loadChatMessages() setReadMessage failed, code = " + code + ", desc = " + desc);
                        backJson.setCode(code + "");
                        backJson.setMessage(desc);
                        backJson.setSuccess(false);
                        conditionVariable.open();

                    }

                    @Override
                    public void onSuccess() {
                        backJson.setCode("");
                        backJson.setMessage("设置消息为已读");
                        backJson.setSuccess(true);
                        conditionVariable.open();
                    }
                });
            }
        }).start();
        conditionVariable.block();
        return backJson;
    }
    private void setPermission(Context context){
        AndPermission.with(context)
                .permission(
                        Permission.RECORD_AUDIO,
                        Permission.READ_EXTERNAL_STORAGE,
                        Permission.WRITE_EXTERNAL_STORAGE,
                        Permission.READ_PHONE_STATE,
                        Permission.CAMERA
                )
                .onGranted(new Action() {
                    @Override
                    public void onAction(List<String> permissions) {

                    }
                })
                .onDenied(new Action() {
                    @Override
                    public void onAction(List<String> permissions) {

                    }
                }).start();
    }
    /**
     * 获取未读数量
     *
     * @return
     */
    public BackJson getUnReadMessageNum(String arg) {
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = (JSONObject) JSONObject.toJSON(objlist.getJSONObject(0));
        BackJson backJson = new BackJson();
        if (null == mCurrentConversation) {
            mCurrentConversation = TIMManager.getInstance().getConversation(TIMConversationType.C2C, obj.getString("receiverId"));
        }
        try {
            int num = (int) mCurrentConversation.getUnreadMessageNum();
            Map<String, String> map = new HashMap<>();
            map.put("num", num + "");
            backJson.setObj(map);
            backJson.setCode("");
            backJson.setMessage("获取未读数量成功");
            backJson.setSuccess(true);
        } catch (Exception e) {
            backJson.setObj(e);
            backJson.setCode("");
            backJson.setMessage("获取未读数量识别");
            backJson.setSuccess(false);
        }

        return backJson;
    }

    /**
     * 获取最近一条消息
     *
     * @return
     */
    public BackJson getLastMsg(String arg) {
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = (JSONObject) JSONObject.toJSON(objlist.getJSONObject(0));
        BackJson backJson = new BackJson();

        if (null == mCurrentConversation) {
            mCurrentConversation = TIMManager.getInstance().getConversation(TIMConversationType.C2C, obj.getString("receiverId"));
        }
        try {
            TIMMessage msg = mCurrentConversation.getLastMsg();
            Map<String, String> map = new HashMap<>();
            TIMTextElem elem = (TIMTextElem) msg.getElement(0);
            map.put("MSGID", msg.getMsgId());
            map.put("SENDERID", msg.getSender());
            map.put("CONTENT", elem.getText());
            map.put("TIME", getDateToString(msg.timestamp()));
            backJson.setObj(map);
            backJson.setCode("");
            backJson.setMessage("获取最近一条消息成功");
            backJson.setSuccess(true);
        } catch (Exception e) {
            backJson.setObj(e);
            backJson.setCode("");
            backJson.setMessage("获取最近一条消息失败");
            backJson.setSuccess(false);
        }


        return backJson;
    }

    /**
     * 获取会话列表
     *
     * @return
     */
    public BackJson getConversationList() {
        BackJson backJson = new BackJson();
        List<Object> listObj = new ArrayList<>();
        try {
            List<TIMConversation> list = TIMManager.getInstance().getConversationList();
            for (TIMConversation im :
                    list) {
                Map<String, String> map = new HashMap<>();
                map.put("Type", im.getType().value() + "");
                map.put("ConversationId", im.getPeer());
                map.put("GroupName", TextUtils.isEmpty(im.getGroupName())? "":im.getGroupName() );

                listObj.add(map);
                backJson.setList(listObj);
                backJson.setCode("");
                backJson.setMessage("获取会话列表成功");
                backJson.setSuccess(true);


                Log.d(TAG, "TYPE=" + im.getType().value() + " GroupName=" + im.getGroupName() + "ConversationId=" + im.getPeer());

            }
        } catch (Exception e) {
            backJson.setObj(e);
            backJson.setCode("");
            backJson.setMessage("获取会话列表失败");
            backJson.setSuccess(false);
        }
        return backJson;
    }


    /**
     * 消息发送
     */
    public BackJson sendMessage(String arg) {
        BackJson backJson = new BackJson();
        JSONArray objlist = JSON.parseArray(arg);
        JSONObject obj = JSONObject.parseObject((String) objlist.get(0));
        if (null == mCurrentConversation) {
            mCurrentConversation = TIMManager.getInstance().getConversation(TIMConversationType.C2C, obj.getString("sendTid"));
        }
        TIMMessage message = new TIMMessage();
        TIMTextElem elem = new TIMTextElem();
        elem.setText(obj.getString("content"));
        message.addElement(elem);
        final ConditionVariable conditionVariable = new ConditionVariable();
        new Thread(new Runnable() {
            @Override
            public void run() {
                mCurrentConversation.sendMessage(message, new TIMValueCallBack<TIMMessage>() {
                    @Override
                    public void onError(final int code, final String desc) {
                        TUIKitLog.i(TAG, "sendMessage fail:" + code + "=" + desc);
                        backJson.setCode(code + "");
                        backJson.setMessage(desc);
                        backJson.setSuccess(false);
                        conditionVariable.open();

                    }

                    @Override
                    public void onSuccess(TIMMessage timMessage) {

                        TUIKitLog.i(TAG, "sendMessage onSuccess");
                        backJson.setCode("");
                        backJson.setMessage("消息发送成功");
                        backJson.setSuccess(true);
                        conditionVariable.open();

                    }
                });
            }
        }).start();
        conditionVariable.block();
        return backJson;
    }


    public void onForceOfflineOrSigExpired() {
        Log.d(TAG,"开始监听");
        TIMUserConfig userConfig = new TIMUserConfig();
        userConfig.disableAutoReport(false);
        userConfig.setUserStatusListener(new TIMUserStatusListener() {
            @Override
            public void onForceOffline() {
                Log.d(TAG,"消息来了被其他终端踢下线");
                NewMsgEvent newMsgEvent =new NewMsgEvent();
                BackJson backJson = new BackJson();
                backJson.setCode("200");
                backJson.setMessage("消息来了被其他终端踢下线");
                backJson.setSuccess(true);
                newMsgEvent.setObj(backJson);
                newMsgEvent.setType(2);
                EventBus.getDefault().post(newMsgEvent);
            }

            @Override
            public void onUserSigExpired() {
                Log.d(TAG,"用户签名过期了，需要刷新 userSig 重新登录 IM SDK");
                NewMsgEvent newMsgEvent =new NewMsgEvent();
                BackJson backJson = new BackJson();
                backJson.setCode("200");
                backJson.setMessage("用户签名过期了，需要刷新 userSig 重新登录 IM SDK");
                backJson.setSuccess(true);
                newMsgEvent.setObj(backJson);
                newMsgEvent.setType(3);
                EventBus.getDefault().post(newMsgEvent);

            }
        });
        TIMManager.getInstance().setUserConfig(userConfig);
    }


    @Override
    public boolean onNewMessages(List<TIMMessage> list) {
        if (list != null && list.size()>0) {
            if (list.get(0).getElement(0) instanceof TIMTextElem) {
                TIMMessage msg=list.get(0);
                TIMTextElem textElem = (TIMTextElem) msg.getElement(0);
                L.e("消息来了" + textElem.getText());
                Map<String, String> map = new HashMap<>();
                TIMTextElem elem = (TIMTextElem) msg.getElement(0);
                map.put("MSGID", msg.getMsgId());
                map.put("SENDERID", msg.getSender());
                map.put("CONTENT", elem.getText());
                map.put("TIME", getDateToString(msg.timestamp()));
                NewMsgEvent newMsgEvent =new NewMsgEvent();
                newMsgEvent.setObj(map);
                newMsgEvent.setType(1);
                EventBus.getDefault().post(newMsgEvent);

            }
        }
        return false;
    }

    /**
     * 获取当前登录信息和连接状态
     * @return
     */
    public BackJson getUserInfo(){
        BackJson backJson = new BackJson();
        Map<String, Object> map = new HashMap<>();
        map.put("userId", TextUtils.isEmpty(TIMManager.getInstance().getLoginUser()) ? "":TIMManager.getInstance().getLoginUser());
        map.put("online", TIMManager.getInstance().isInited());
        backJson.setCode("200");
        backJson.setMessage("获取用户名和连接状态成功");
        backJson.setObj(map);
        backJson.setSuccess(true);
        return backJson;
    }

    public Boolean getIMStatus() {
        return TIMManager.getInstance().isInited();
    }



    /**
     * 时间戳转换成字符串
     */
    public String getDateToString(long time) {
        Date date = new Date(time * 1000);
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return format.format(date);
    }
}
