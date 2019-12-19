package com.skytech.skyimplugin;

import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;
import org.json.JSONException;


/**
 * This class echoes a string called from JavaScript.
 */
public class skyTxIM extends CordovaPlugin {
    public final int REQUESTCODE_CODE = 1;
    private CallbackContext context = null;
    private CallbackContext receiveMsgCallback = null;
    private CallbackContext kickoutLineCallback = null;
    private CallbackContext sigExpiredCallback = null;
    private TrtcIM trtcIM=null;
    private final static String TAG = "TrtcIM";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        this.context = null;
        if (!EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().register(this);
        }
    }

    @Override
    public boolean execute(String action, String args, CallbackContext callbackContext) throws JSONException {
        this.context = callbackContext;
        //登录
        if (action.equals("loginIM")) {
            trtcIM=null;
            trtcIM = new TrtcIM();
            if(!trtcIM.getIMStatus()){
                trtcIM.initIM(cordova.getActivity(), args);
            }
            BackJson backJson = trtcIM.login(args);
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }


            return true;
        }
        //登录
        if (action.equals("getOnlineUser")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }
            BackJson backJson = trtcIM.getUserInfo();
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }


            return true;
        }
        //登出
        if (action.equals("loginOutIM")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }
            BackJson backJson = trtcIM.logOut();
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }
            return true;
        }
        //历史消息
        if (action.equals("histroyMessage")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }

            BackJson backJson = trtcIM.histroyMessage(args);
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }

            return true;
        }
        //设置消息为已读
        if (action.equals("setReadMessage")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }

            BackJson backJson = trtcIM.setReadMessage(args);
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }

            return true;
        }
        //获取未读数量
        if (action.equals("getUnReadMessageNum")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }

            BackJson backJson = trtcIM.getUnReadMessageNum(args);
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }

            return true;
        }
        //获取最近一条消息
        if (action.equals("getLastMsg")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }

            BackJson backJson = trtcIM.getLastMsg(args);
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }

            return true;
        }
        //获取会话列表
        if (action.equals("getConversationList")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }

            BackJson backJson = trtcIM.getConversationList();
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }

            return true;
        }

        //js页面发送消息给原生页面
        if (action.equals("sendMessageJsToIm")) {
            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }

            BackJson backJson = trtcIM.sendMessage(args);
            if (backJson.isSuccess()) {
                context.success(JSONObject.toJSONString(backJson));
            } else {
                context.error(JSONObject.toJSONString(backJson));
            }
            return true;
        }
        //收到消息
        if (action.equals("receiveMsg")) {
            Log.d(TAG, "收到消息");
            this.receiveMsgCallback = callbackContext;

            if (null == trtcIM) {
                trtcIM = new TrtcIM();
            }
            PluginResult pluginResult = null;

            if (trtcIM.getIMStatus()) {
                BackJson backJson = new BackJson();
                backJson.setCode("201");
                backJson.setMessage("设置监听成功");
                backJson.setSuccess(true);
                pluginResult = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backJson));
                pluginResult.setKeepCallback(true);
                receiveMsgCallback.sendPluginResult(pluginResult);
            } else {
                BackJson backJson = new BackJson();
                backJson.setCode("202");
                backJson.setMessage("设置监听失败");
                backJson.setSuccess(false);
                pluginResult = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backJson));
                receiveMsgCallback.sendPluginResult(pluginResult);

            }
            return true;
        }
        //进入下线监听
        if (action.equals("kickoutLine")) {
            Log.d(TAG, "进入下线监听");
            this.kickoutLineCallback = callbackContext;
            PluginResult pluginResult = null;
            BackJson backJson = new BackJson();
            backJson.setCode("201");
            backJson.setMessage("设置监听成功");
            backJson.setSuccess(true);
            pluginResult = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backJson));
            pluginResult.setKeepCallback(true);
            kickoutLineCallback.sendPluginResult(pluginResult);
            return true;
        }
        //进入sig过期监听
        if (action.equals("sigExpired")) {
            Log.d(TAG, "进入sig过期监听");
            this.sigExpiredCallback = callbackContext;
            PluginResult pluginResult = null;
            BackJson backJson = new BackJson();
            backJson.setCode("201");
            backJson.setMessage("设置监听成功");
            backJson.setSuccess(true);
            pluginResult = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backJson));
            pluginResult.setKeepCallback(true);
            sigExpiredCallback.sendPluginResult(pluginResult);
            return true;
        }


        return false;
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onShowMessageEvent(NewMsgEvent messageEvent) {
        switch (messageEvent.getType()) {
            case 1:
                //收到消息监听
                BackJson backJson = new BackJson();
                backJson.setCode("200");
                backJson.setMessage("收到新消息");
                backJson.setSuccess(true);
                backJson.setObj(messageEvent.getObj());
                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backJson));
                pluginResult.setKeepCallback(true);
                receiveMsgCallback.sendPluginResult(pluginResult);
                break;
            case 2:
                //被踢下线监听
                BackJson backickout = new BackJson();
                backickout.setCode("200");
                backickout.setMessage("被挤下线啦");
                backickout.setSuccess(true);
                backickout.setObj(messageEvent.getObj());
                PluginResult kickout = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backickout));
                kickout.setKeepCallback(true);
                kickoutLineCallback.sendPluginResult(kickout);

                break;
            case 3:
                //用户签名过期了，需要刷新 userSig 重新登录 IM SDK
                BackJson backSigExpired = new BackJson();
                backSigExpired.setCode("200");
                backSigExpired.setMessage("用户签名过期了，需要刷新 userSig 重新登录 IM SDK");
                backSigExpired.setSuccess(true);
                backSigExpired.setObj(messageEvent.getObj());
                PluginResult sigExpired = new PluginResult(PluginResult.Status.OK, JSON.toJSONString(backSigExpired));
                sigExpired.setKeepCallback(true);
                sigExpiredCallback.sendPluginResult(sigExpired);
                break;
            default:
                break;
        }


    }

    @Override
    public void onDestroy() {
        // 解绑事件
        if (EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().unregister(this);
        }
        super.onDestroy();
    }

}
