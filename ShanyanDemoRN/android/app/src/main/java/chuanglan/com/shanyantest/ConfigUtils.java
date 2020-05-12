package chuanglan.com.shanyantest;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.chuanglan.shanyan_sdk.listener.ShanYanCustomInterface;
import com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig;
import com.facebook.react.bridge.Callback;

public class ConfigUtils {
    private static final String TAG = "RN-ShanYan";
    private static String PrivacyTitle = "title";
    private static String PrivacyUrl = "url";
    private static String PrivacyColor = "privacyColor";
    private static String PrivacyBaseColor = "privacyBaseColor";
    private static String PrivacyTextOne = "privacyTextOne";
    private static String PrivacyTextTwo = "privacyTextTwo";
    private static String PrivacyTextThree = "privacyTextThree";
    private static String PrivacyTextFour = "privacyTextFour";
    private static String PrivacyTextFive = "privacyTextFive";
    private static String Width = "width";
    private static String Height = "height";
    private static String MarginLeft = "marginLeft";
    private static String MarginTop = "marginTop";
    private static String MarginRight = "marginRight";
    private static String MarginBottom = "marginBottom";
    private static String IsBottom = "isBottom";
    private static String Type = "type";


    /**
     * 闪验三网运营商授权页配置类
     *
     * @param context
     * @return
     */

    //dialog竖屏样式设置
    public static ShanYanUIConfig getDialogUiConfig(final Context context) {
        /************************************************自定义控件**************************************************************/
        //其他方式登录
        TextView otherTV = new TextView(context);
        otherTV.setText("其他方式登录");
        otherTV.setTextColor(0xff3a404c);
        otherTV.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13);
        RelativeLayout.LayoutParams mLayoutParams1 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        mLayoutParams1.setMargins(0, AbScreenUtils.dp2px(context, 230), 0, 0);
        mLayoutParams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
        otherTV.setLayoutParams(mLayoutParams1);
        //标题栏下划线
     /*   View view = new View(context);
        view.setBackgroundColor(0xffe8e8e8);
        RelativeLayout.LayoutParams mLayoutParams3 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, AbScreenUtils.dp2px(context, 1));
        mLayoutParams3.setMargins(0, AbScreenUtils.dp2px(context, 0), 0, 0);
        view.setLayoutParams(mLayoutParams3);*/

        //loading自定义加载框
        LayoutInflater inflater = LayoutInflater.from(context);
        RelativeLayout view_dialog = (RelativeLayout) inflater.inflate(R.layout.dialog_white_layout, null);
        RelativeLayout.LayoutParams mLayoutParams3 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        view_dialog.setLayoutParams(mLayoutParams3);
        view_dialog.setVisibility(View.GONE);

        LayoutInflater inflater1 = LayoutInflater.from(context);
        RelativeLayout relativeLayout = (RelativeLayout) inflater1.inflate(R.layout.relative_item_view, null);
        RelativeLayout.LayoutParams layoutParamsOther = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        layoutParamsOther.setMargins(0, AbScreenUtils.dp2px(context, 190), 0, 0);
        layoutParamsOther.addRule(RelativeLayout.CENTER_HORIZONTAL);
        relativeLayout.setLayoutParams(layoutParamsOther);
        otherLogin(context, relativeLayout);

        /****************************************************设置授权页*********************************************************/
        Drawable authNavHidden = context.getResources().getDrawable(R.drawable.sysdk_login_bg);
        Drawable navReturnImgPath = context.getResources().getDrawable(R.drawable.close_black);
        Drawable logoImgPath = context.getResources().getDrawable(R.drawable.sy_logo);

        Drawable logBtnImgPath = context.getResources().getDrawable(R.drawable.authentication_button);
        Drawable uncheckedImgPath = context.getResources().getDrawable(R.drawable.sysdk_dialog_uncheck);
        Drawable checkedImgPath = context.getResources().getDrawable(R.drawable.sysdk_dialog_check);
        ShanYanUIConfig uiConfig = new ShanYanUIConfig.Builder()
                .setDialogTheme(true, AbScreenUtils.getScreenWidth(context, true) - 66, 400, 0, 0, false)

                //授权页导航栏：
                .setNavColor(Color.parseColor("#ffffff"))  //设置导航栏颜色
                .setNavText("")  //设置导航栏标题文字
                .setNavTextColor(0xff080808) //设置标题栏文字颜色
                .setNavReturnImgPath(navReturnImgPath)  //
                .setNavReturnBtnWidth(25)
                .setNavReturnBtnHeight(25)
                .setNavReturnBtnOffsetRightX(15)
                .setAuthBGImgPath(authNavHidden)

                //授权页logo（logo的层级在次底层，仅次于自定义控件）
                .setLogoImgPath(logoImgPath)  //设置logo图片
                .setLogoWidth(108)   //设置logo宽度
                .setLogoHeight(45)   //设置logo高度
                .setLogoOffsetY(25)  //设置logo相对于标题栏下边缘y偏移
                .setLogoHidden(false)   //是否隐藏logo

                //授权页号码栏：
                .setNumberColor(0xff397BF9)  //设置手机号码字体颜色
                .setNumFieldOffsetY(74)    //设置号码栏相对于标题栏下边缘y偏移
                .setNumberSize(18)

                //授权页登录按钮：
                .setLogBtnText("本机号码一键登录")  //设置登录按钮文字
                .setLogBtnTextColor(0xffffffff)   //设置登录按钮文字颜色
                .setLogBtnImgPath(logBtnImgPath)   //设置登录按钮图片
                .setLogBtnOffsetY(140)   //设置登录按钮相对于标题栏下边缘y偏移
                .setLogBtnTextSize(15)
                .setLogBtnWidth(250)
                .setLogBtnHeight(40)

                //授权页隐私栏：
                .setAppPrivacyOne("闪验用户协议", "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html")  //设置开发者隐私条款1名称和URL(名称，url)
                .setAppPrivacyTwo("闪验隐私政策", "https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html")  //设置开发者隐私条款2名称和URL(名称，url)
                //.setAppPrivacyColor(0xff666666, 0xff0085d0)   //	设置隐私条款名称颜色(基础文字颜色，协议文字颜色)
                .setPrivacyOffsetBottomY(10)//设置隐私条款相对于屏幕下边缘y偏
                .setUncheckedImgPath(uncheckedImgPath)
                .setCheckedImgPath(checkedImgPath)
                .setPrivacyState(true)

                //授权页slogan：
                .setSloganTextColor(0xff999999)  //设置slogan文字颜色
                .setSloganOffsetY(104)  //设置slogan相对于标题栏下边缘y偏移
                .setSloganTextSize(9)
                //设置loading样式
                .setLoadingView(view_dialog)
                // 添加自定义控件:
                .addCustomView(relativeLayout, false, false, null)
                .build();
        return uiConfig;

    }


    //沉浸式竖屏样式
    public static ShanYanUIConfig getCJSConfig(final Context context, Callback callback) {
        /************************************************自定义控件**************************************************************/
        Drawable logoImgPath = context.getResources().getDrawable(R.drawable.shanyan_logo);
        Drawable logBtnImgPath = context.getResources().getDrawable(R.drawable.authentication_button);
        Drawable uncheckedImgPath = context.getResources().getDrawable(R.drawable.sysdk_dialog_uncheck);
        Drawable checkedImgPath = context.getResources().getDrawable(R.drawable.sysdk_dialog_check);
        Drawable navReturnImgPath = context.getResources().getDrawable(R.drawable.umcsdk_return_bg);

        //loading自定义加载框
        LayoutInflater inflater = LayoutInflater.from(context);
        RelativeLayout view_dialog = (RelativeLayout) inflater.inflate(R.layout.dialog_layout, null);
        RelativeLayout.LayoutParams mLayoutParams3 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        view_dialog.setLayoutParams(mLayoutParams3);
        view_dialog.setVisibility(View.GONE);

        LayoutInflater inflater1 = LayoutInflater.from(context);
        RelativeLayout relativeLayout = (RelativeLayout) inflater1.inflate(R.layout.relative_item_view, null);
        RelativeLayout.LayoutParams layoutParamsOther = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        layoutParamsOther.setMargins(0, AbScreenUtils.dp2px(context, 325), 0, 0);
        layoutParamsOther.addRule(RelativeLayout.CENTER_HORIZONTAL);
        relativeLayout.setLayoutParams(layoutParamsOther);
        otherLogin(context, relativeLayout);


        /****************************************************设置授权页*********************************************************/
        ShanYanUIConfig uiConfig = new ShanYanUIConfig.Builder()
                //授权页导航栏：
                .setNavColor(Color.parseColor("#ffffff"))  //设置导航栏颜色
                .setNavText("")  //设置导航栏标题文字
                .setNavTextColor(0xff080808) //设置标题栏文字颜色
                .setNavReturnImgPath(navReturnImgPath)
                .setNavReturnBtnWidth(35)
                .setNavReturnBtnHeight(35)

                //授权页logo（logo的层级在次底层，仅次于自定义控件）
                .setLogoImgPath(logoImgPath)  //设置logo图片
                .setLogoWidth(108)   //设置logo宽度
                .setLogoHeight(44)   //设置logo高度
                .setLogoOffsetY(90)  //设置logo相对于标题栏下边缘y偏移
                .setLogoHidden(false)   //是否隐藏logo

                //授权页号码栏：
                .setNumberColor(0xff397BF9)  //设置手机号码字体颜色
                .setNumFieldOffsetY(155)    //设置号码栏相对于标题栏下边缘y偏移
                .setNumberSize(18)


                //授权页登录按钮：
                .setLogBtnText("本机号码一键登录")  //设置登录按钮文字
                .setLogBtnTextColor(0xffffffff)   //设置登录按钮文字颜色
                .setLogBtnImgPath(logBtnImgPath)   //设置登录按钮图片
                .setLogBtnOffsetY(220)   //设置登录按钮相对于标题栏下边缘y偏移
                .setLogBtnTextSize(15)
                .setLogBtnHeight(45)
                .setLogBtnWidth(AbScreenUtils.getScreenWidth(context, true) - 40)

                //授权页隐私栏：
                .setAppPrivacyOne("闪验用户协议", "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html")  //设置开发者隐私条款1名称和URL(名称，url)
                .setAppPrivacyTwo("闪验隐私政策", "https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html")  //设置开发者隐私条款2名称和URL(名称，url)
                .setAppPrivacyColor(0xff797894, 0xff0085d0)   //	设置隐私条款名称颜色(基础文字颜色，协议文字颜色)
                .setPrivacyOffsetBottomY(20)//设置隐私条款相对于屏幕下边缘y偏
                .setUncheckedImgPath(uncheckedImgPath)
                .setCheckedImgPath(checkedImgPath)
                .setPrivacyState(true)
                .setPrivacyOffsetX(24)


                //授权页slogan：
                .setSloganTextColor(0xff999999)  //设置slogan文字颜色
                .setSloganOffsetY(190)  //设置slogan相对于标题栏下边缘y偏移

                .setLoadingView(view_dialog)
                // 添加自定义控件:
                .addCustomView(relativeLayout, false, false, new ShanYanCustomInterface() {
                    @Override
                    public void onClick(Context context, View view) {
                        callback.invoke(view.getId());
                    }
                })
                //标题栏下划线，可以不写
                .build();
        return uiConfig;

    }


    //沉浸式横屏样式设置
    public static ShanYanUIConfig getCJSLandscapeUiConfig(final Context context,Callback callback) {

        /************************************************自定义控件**************************************************************/

        //其他方式登录
        LayoutInflater inflater1 = LayoutInflater.from(context);
        RelativeLayout relativeLayout = (RelativeLayout) inflater1.inflate(R.layout.relative_item_view, null);
        RelativeLayout.LayoutParams layoutParamsOther = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        layoutParamsOther.setMargins(0, AbScreenUtils.dp2px(context, 170), 0, 0);
        layoutParamsOther.addRule(RelativeLayout.CENTER_HORIZONTAL);
        relativeLayout.setLayoutParams(layoutParamsOther);
        otherLogin(context, relativeLayout);


        /****************************************************设置授权页*********************************************************/
        Drawable authNavHidden = context.getResources().getDrawable(R.drawable.cjs_landscape_bg);
        Drawable navReturnImgPath = context.getResources().getDrawable(R.drawable.close_black);
        Drawable logoImgPath = context.getResources().getDrawable(R.drawable.sy_logo_white);
        Drawable logBtnImgPath = context.getResources().getDrawable(R.drawable.authentication_button);
        Drawable uncheckedImgPath = context.getResources().getDrawable(R.drawable.sysdk_uncheck_image);
        Drawable checkedImgPath = context.getResources().getDrawable(R.drawable.sysdk_check_image);

        //loading自定义加载框
        LayoutInflater inflater = LayoutInflater.from(context);
        RelativeLayout view_dialog = (RelativeLayout) inflater.inflate(R.layout.dialog_white_layout, null);
        RelativeLayout.LayoutParams mLayoutParams3 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        view_dialog.setLayoutParams(mLayoutParams3);
        view_dialog.setVisibility(View.GONE);
        ShanYanUIConfig uiConfig = new ShanYanUIConfig.Builder()
                // .setDialogTheme(true, 460, 240, 0, 0, false)
                //授权页导航栏：
                .setNavColor(Color.parseColor("#ffffff"))  //设置导航栏颜色
                .setNavText("")  //设置导航栏标题文字
                .setNavTextColor(0xff080808) //设置标题栏文字颜色
                .setNavReturnImgPath(navReturnImgPath)  //
                .setNavReturnImgPath(navReturnImgPath)
                .setNavReturnBtnWidth(25)
                .setNavReturnBtnHeight(25)
                .setNavReturnBtnOffsetRightX(15)
                .setAuthBGImgPath(authNavHidden)

                //授权页logo（logo的层级在次底层，仅次于自定义控件）
                .setLogoImgPath(logoImgPath)  //设置logo图片
                .setLogoWidth(108)   //设置logo宽度
                .setLogoHeight(36)   //设置logo高度
                .setLogoOffsetY(14)  //设置logo相对于标题栏下边缘y偏移
                .setLogoHidden(false)   //是否隐藏logo

                //授权页号码栏：
                .setNumberColor(0xffffffff)  //设置手机号码字体颜色
                .setNumFieldOffsetY(65)    //设置号码栏相对于标题栏下边缘y偏移
                .setNumberSize(18)


                //授权页登录按钮：
                .setLogBtnText("本机号码一键登录")  //设置登录按钮文字
                .setLogBtnTextColor(0xffffffff)   //设置登录按钮文字颜色
                .setLogBtnImgPath(logBtnImgPath)   //设置登录按钮图片
                .setLogBtnOffsetY(120)   //设置登录按钮相对于标题栏下边缘y偏移
                .setLogBtnTextSize(15)
                .setLogBtnWidth(330)
                .setLogBtnHeight(45)

                //授权页隐私栏：
                .setAppPrivacyOne("闪验用户协议", "https://api.253.com/api_doc/yin-si-zheng-ce/wei-hu-wang-luo-an-quan-sheng-ming.html")  //设置开发者隐私条款1名称和URL(名称，url)
                .setAppPrivacyTwo("闪验隐私政策", "https://api.253.com/api_doc/yin-si-zheng-ce/ge-ren-xin-xi-bao-hu-sheng-ming.html")  //设置开发者隐私条款2名称和URL(名称，url)
                .setAppPrivacyColor(0xffffffff, 0xff0085d0)   //	设置隐私条款名称颜色(基础文字颜色，协议文字颜色)
                .setPrivacyOffsetBottomY(10)
                .setUncheckedImgPath(uncheckedImgPath)
                .setCheckedImgPath(checkedImgPath)
                .setCheckBoxMargin(10, 5, 10, 5)
                .setPrivacyState(true)


                //授权页slogan：
                .setSloganTextColor(0xff999999)  //设置slogan文字颜色
                .setSloganOffsetY(100)  //设置slogan相对于标题栏下边缘y偏移
                .setSloganTextSize(10)
                .setLoadingView(view_dialog)
                .addCustomView(relativeLayout, false, false, null)
                .build();
        return uiConfig;
    }

    private static void otherLogin(final Context context, RelativeLayout relativeLayout) {
        ImageView weixin = relativeLayout.findViewById(R.id.weixin);
        ImageView qq = relativeLayout.findViewById(R.id.qq);
        ImageView weibo = relativeLayout.findViewById(R.id.weibo);
        weixin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AbScreenUtils.showToast(context, "点击微信登录");
            }
        });
        qq.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AbScreenUtils.showToast(context, "点击qq登录");

            }
        });
        weibo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AbScreenUtils.showToast(context, "点击微博登录");
            }
        });
    }

}
