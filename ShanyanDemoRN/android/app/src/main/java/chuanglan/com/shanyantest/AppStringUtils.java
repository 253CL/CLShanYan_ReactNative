package chuanglan.com.shanyantest;

/**
 * 主要功能： 字符串判断工具类
 */
public class AppStringUtils {
    /**
     * 判断字符串是否为空
     * @param str 字符串
     * @return
     */
    public static boolean isEmpty(String str) {
        return str == null || "".equals(str) || str.trim().length() == 0;
    }
    /**
     * 判断str null,"","null" 均视为空.
     * @param str      字符
     * @return 结果 boolean
     */
    public static boolean isNotEmpty(String str) {
        boolean bool;
        bool = str != null && !"null".equals(str) && !"".equals(str);
        return bool;
    }

    /**
     * 将对象转为字符串,如果对象为null,则返回null,而不是"null"
     *
     * @param object 要转换的对象
     * @return 转换后的对象
     */
    public static String toString(Object object) {
        return toString(object, null);
    }

    /**
     * 将对象转为字符串,如果对象为null,则使用默认值
     *
     * @param object       要转换的对象
     * @param defaultValue 默认值
     * @return 转换后的字符串
     */
    private static String toString(Object object, String defaultValue) {
        if (object == null) return defaultValue;
        return String.valueOf(object);
    }
}
