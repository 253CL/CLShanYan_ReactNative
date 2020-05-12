package chuanglan.com.shanyantest;

import android.app.Activity;
import android.content.Context;
import android.graphics.Rect;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

/**
 * 获得屏幕相关数据的辅助类
 */
public class AbScreenUtils {
    private static Handler mainHandler;

    private AbScreenUtils() {
        /* cannot be instantiated */
        throw new UnsupportedOperationException("cannot be instantiated");
    }

    /**
     * 设置控件的宽高
     *
     * @param view
     * @param widthPixels
     * @param heightPixels
     */
    public static void setViewWH(View view, int widthPixels, int heightPixels) {
        ViewGroup.LayoutParams params = view.getLayoutParams();
        if (params == null) {
//			AbLogUtil.e(AbViewUtil.class,
//					"setViewSize出错,如果是代码new出来的View，需要设置一个适合的LayoutParams");
            return;
        }
        params.width = widthPixels;
        params.height = heightPixels;
        view.setLayoutParams(params);
        view.requestLayout();
    }

    /**
     * 获得屏幕宽度
     *
     * @param context
     * @return
     */
    public static int getScreenWidth(Context context) {
        WindowManager wm = (WindowManager) context
                .getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.widthPixels;
    }

    /**
     * 获取硬件制造厂商
     *
     * @return
     */
    public static String getManufacturer() {
        return Build.MANUFACTURER;
    }

    /**
     * 获得屏幕高度
     *
     * @param context
     * @return
     */
    public static int getScreenHeight(Context context, boolean isDp) {
        int screenHeight = 0;
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(dm);
        int height = dm.heightPixels;       // 屏幕高度（像素）

        if (!isDp) {
            return height;
        }

        float density = dm.density;         // 屏幕密度（0.75 / 1.0 / 1.5）
        screenHeight = (int) (height / density);// 屏幕高度(dp)
        return screenHeight;
    }

    public static int getScreenWidth(Context context, boolean isDp) {
        int screenWidth = 0;
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;       // 屏幕高度（像素）

        if (!isDp) {
            return width;
        }

        float density = dm.density;         // 屏幕密度（0.75 / 1.0 / 1.5）
        screenWidth = (int) (width / density);// 屏幕高度(dp)
        return screenWidth;
    }

    /**
     * 获得状态栏的高度
     *
     * @param context
     * @return
     */
    public static int getStatusHeight(Context context) {

        int statusHeight = -1;
        try {
            Class<?> clazz = Class.forName("com.android.internal.R$dimen");
            Object object = clazz.newInstance();
            int height = Integer.parseInt(clazz.getField("status_bar_height")
                    .get(object).toString());
            statusHeight = context.getResources().getDimensionPixelSize(height);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return statusHeight;
    }

    public static int getStatusHeight(Context context, boolean isDp) {

        int statusHeight = -1;
        try {
            Class<?> clazz = Class.forName("com.android.internal.R$dimen");
            Object object = clazz.newInstance();
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            DisplayMetrics dm = new DisplayMetrics();
            wm.getDefaultDisplay().getMetrics(dm);
            int height = Integer.parseInt(clazz.getField("status_bar_height")
                    .get(object).toString());
            statusHeight = context.getResources().getDimensionPixelSize(height);
            if (!isDp) {
                return statusHeight;
            }

            float density = dm.density;         // 屏幕密度（0.75 / 1.0 / 1.5）
            Log.e("fff", "dm=" + density);
            statusHeight = (int) (statusHeight / density);// 屏幕高度(dp)
            Log.e("fff", "statusHeight=" + statusHeight);
            return statusHeight;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return statusHeight;
    }

    /**
     * 标题栏的高度
     *
     * @param context
     * @return
     */
    public static int titleBarHeight(Activity context) {
        Rect frame = new Rect();
        context.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        int statusBarHeight = frame.top;
        int contentTop = context.getWindow().findViewById(Window.ID_ANDROID_CONTENT).getTop();
        //statusBarHeight是上面所求的状态栏的高度
        int titleBarHeight = contentTop - statusBarHeight;
        return titleBarHeight;
    }

    /**
     * dp转换成px
     */
    public static int dp2px(Context context, float dpValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    public static void showToast(final Context context, final String msg) {
        mainHandler = new Handler(Looper.getMainLooper());
        execute(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private static void execute(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            mainHandler.post(runnable);
        }
    }

}

