package chuanglan.com.shanyantest;


import android.content.Context;
import android.util.Log;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.AuthenticationExecuteListener;
import com.chuanglan.shanyan_sdk.listener.GetPhoneInfoListener;
import com.chuanglan.shanyan_sdk.listener.InitListener;
import com.chuanglan.shanyan_sdk.listener.OnClickPrivacyListener;
import com.chuanglan.shanyan_sdk.listener.ActionListener;
import com.chuanglan.shanyan_sdk.listener.OneKeyLoginListener;
import com.chuanglan.shanyan_sdk.listener.OpenLoginAuthListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


public class ShanYanSDKModule extends ReactContextBaseJavaModule {

    private ReactApplicationContext reactContext;
    private String baseUrl;
    public static final String OPEN_LOGIN_AUTH_EVENT = "getOpenLoginAuthStatus";


    public ShanYanSDKModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ShanYanSDKModule";
    }

    /**
     * 闪验SDK 设置debug模式
     *
     * @param isDebug true 开启；false 关闭
     */
    @ReactMethod
    public void setDebugMode(boolean isDebug){
        OneKeyLoginManager.getInstance().setDebug(isDebug);
    }

    /**
     * 闪验SDK 初始化
     *
     * @param readableMap   初始化所需参数
     * @param callback 初始化回调监听
     */
    @ReactMethod
    public void init(ReadableMap  readableMap, final Callback callback) {
        String appid = readableMap.getString("appid");
       // baseUrl = mWXSDKInstance.getBundleUrl();
        OneKeyLoginManager.getInstance().init(reactContext.getApplicationContext(), appid, new InitListener() {
            @Override
            public void getInitStatus(int code, String result) {
                if (null != callback){
                    callback.invoke(convertToResult(code,result));
                }
            }
        });
    }


    /**
     * 闪验SDK 预取号
     *
     * @param callback 预取号监听
     */
    @ReactMethod
    public void getPhoneInfo(final Callback callback) {
        OneKeyLoginManager.getInstance().getPhoneInfo(new GetPhoneInfoListener() {
            @Override
            public void getPhoneInfoStatus(int code, String result) {
                if (null != callback){
                    callback.invoke(convertToResult(code,result));
                }
            }
        });
    }

    /**
     * 闪验SDK 配置授权页方法
     *
     */
    @ReactMethod
    public void setAuthThemeConfig( final Callback callback) {
        OneKeyLoginManager.getInstance().setAuthThemeConfig(ConfigUtils.getCJSConfig(reactContext.getApplicationContext(), callback),ConfigUtils.getCJSLandscapeUiConfig(reactContext.getApplicationContext(), callback));
    }

    /**
     * 闪验SDK 拉起授权页
     *
     */
    @ReactMethod
    public void openLoginAuth(Boolean isFinish) {
        //开始拉取授权页
        OneKeyLoginManager.getInstance().openLoginAuth(isFinish, new OpenLoginAuthListener() {
            @Override
            public void getOpenLoginAuthStatus(int code, String result) {
                sendEvent(OPEN_LOGIN_AUTH_EVENT,convertToResult(0,code,result));
            }
        }, new OneKeyLoginListener() {
            @Override
            public void getOneKeyLoginStatus(int code, String result) {
                sendEvent(OPEN_LOGIN_AUTH_EVENT,convertToResult(1,code,result));
            }
        });
    }

    /**
     * 闪验SDK 本机号校验获取token
     *
     */
    @ReactMethod
    public void startAuthentication(final Callback authenticationRespondListener) {
        OneKeyLoginManager.getInstance().startAuthentication(new AuthenticationExecuteListener() {
            @Override
            public void authenticationRespond(int code, String result) {
                if (null != authenticationRespondListener){
                    authenticationRespondListener.invoke(convertToResult(code,result));
                }
            }
        });
    }

    /**
     * 闪验SDK 授权页点击事件监听（checkbox和协议链接）
     *
     */
    @ReactMethod
    public void setOnActionListener(final Callback OnActionListener) {
        OneKeyLoginManager.getInstance().setActionListener(new ActionListener() {
            @Override
            public void ActionListner(int type, int code, String message) {
                if (null != OnActionListener){
                    OnActionListener.invoke(actionToResult(type,code,message));
                }
            }
        });
    }

    /**
     * 闪验SDK 授权页销毁方法
     *
     */
    @ReactMethod
    public void finishAuthActivity() {
        OneKeyLoginManager.getInstance().finishAuthActivity();
    }

    /**
     * 闪验SDK 获取预取号状态
     *
     */
    @ReactMethod
    public void getPreIntStatus(Callback preIntStatusListener) {
        preIntStatusListener.invoke(OneKeyLoginManager.getInstance().getPreIntStatus());
    }

    /**
     * 闪验SDK 获取运营商类型
     *
     */
    @ReactMethod
    public void getOperatorType(Callback getOperatorTypeListener) {
        getOperatorTypeListener.invoke(OneKeyLoginManager.getInstance().getOperatorType(reactContext.getApplicationContext()));
    }

    /**
     * 闪验SDK 授权页loading显示隐藏
     *
     */
    @ReactMethod
    public void setLoadingVisibility(boolean visibility){
        OneKeyLoginManager.getInstance().setLoadingVisibility(visibility);
    }

    /**
     * 闪验SDK 授权页协议复选框是否选中
     *
     */
    @ReactMethod
    public void setCheckBoxValue(boolean isChecked){
        OneKeyLoginManager.getInstance().setCheckBoxValue(isChecked);
    }

    private WritableMap convertToResult(int code,String content){
        WritableMap writableMap = Arguments.createMap();
        writableMap.putInt("code",code);
        writableMap.putString("result",content);
        return writableMap;
    }

    private WritableMap actionToResult(int type,int code,String message){
        WritableMap writableMap = Arguments.createMap();
        writableMap.putInt("type",type);
        writableMap.putInt("code",code);
        writableMap.putString("message",message);
        return writableMap;
    }

    private WritableMap convertToResult(int type,int code,String content){
        WritableMap writableMap = Arguments.createMap();
        writableMap.putInt("type",type);
        writableMap.putInt("code",code);
        writableMap.putString("result",content);
        return writableMap;
    }

    private void sendEvent(String eventName, WritableMap params) {
        try {
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, params);
        }catch (Throwable throwable){
            Log.e("RN-shanyan","sendEvent error:"+throwable.getMessage());
        }
    }


}
