package cn.qpwa.common.utils;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.httpclient.util.DateUtil;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 提供常用的方法工具类。
 * 
 */
public class CommonUtil {
	/**2015-06-23 17:32:24*/
	static final String DATETIMEMS_FORMAT = "yyyyMMddHHmmss";
	/**2015-06-23 17*/
	static final String MINMEMS_FORMAT = "yyyyMMddHH";

	/**
	 * 通过日期生成20 位的编码字符串
	 * 
	 * @param date
	 *            日期
	 * @return 编码
	 */
	public static String getGenerateCode(Date date) {
		String generateCode = null;
		try {
			// 获取日期字符串yyyyMMddHHmmss
			generateCode = new SimpleDateFormat(DATETIMEMS_FORMAT).format(date);
			// 生成6位的随机数
			generateCode = generateCode + RandomStringUtils.randomNumeric(6);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return generateCode;
	}
	/**
	 * 通过日期生成15位的编码字符(位数 BigDecimal 能容纳)
	 * @param date
	 *            日期
	 * @return 编码
	 */
	public static String autoGenerateCode(Date date) {
		String generateCode = null;
		try {
			// 获取日期字符串yyyyMMddHH
			generateCode = new SimpleDateFormat(MINMEMS_FORMAT).format(date);
			// 生成5位的随机数
			generateCode = generateCode + RandomStringUtils.randomNumeric(5);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return generateCode;
	}

	/**
	 * 反射方法调用
	 *
	 * @param obj  需要反射的方法
	 * @param methodName	方法名
	 * @param params		方法参数
	 */
	public static Object invokeMethod(Object obj, String methodName, Object... params) {
		try {
			return MethodUtils.invokeMethod(obj, methodName, params);
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 通过长度获取由大小写字母、数字随机组成的字符串
	 * 
	 * @param length
	 *            获取随机字符串的长度
	 * @return 随机字符串
	 */
	public static String getRandomStr(int length) {
		StringBuffer buffer = new StringBuffer(
				"0123456789abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ");
		StringBuffer res = new StringBuffer();
		Random r = new Random();
		int range = buffer.length();
		for (int i = 0; i < length; i++) {
			res.append(buffer.charAt(r.nextInt(range)));
		}
		return res.toString();
	}
	
	/**
	 * 通过资源名称，读取相关的properties文件，返回相应的Properties实体
	 * 
	 * @param name 资源名称，如："/resources/config.properties"
	 * 
	 * @return Properties实体
	 * @throws Exception
	 */
	public static Properties loadProp(String name) throws Exception {
		if (StringUtils.isNotBlank(name)) {
			// 获取配置文件路径
			String configFile = CommonUtil.class.getResource(name).getPath();
			Properties p = new Properties();
			// 读取、加载配置文件
			FileInputStream in = new FileInputStream(configFile);
			BufferedReader bf = new BufferedReader(new InputStreamReader(in));
			p.load(bf);
			if (in != null) {
				in.close();
				in = null;
			}
			return p;
		}
		return null;
	}

	/**
	 * 判断字符串是否数值  
	 * @param str 数值类型的字符串  
	 * @return true为数值 
	 */
	public static boolean isNumber(String str) {
		Pattern pattern = Pattern.compile("^[0-9]+(.[0-9]*)?$");
		Matcher match = pattern.matcher(str);
		return match.matches();
	}

    /**
     * 通过长度获取由数字随机组成的字符串
     *
     * @param length
     *            获取随机字符串的长度
     * @return 随机字符串
     */
    public static String getRandomNumberStr(int length) {
        StringBuffer buffer = new StringBuffer(
                "0123456789");
        StringBuffer res = new StringBuffer();
        Random r = new Random();
        int range = buffer.length();
        for (int i = 0; i < length; i++) {
            res.append(buffer.charAt(r.nextInt(range)));
        }
        return res.toString();
    }
    
	
	/**获得当前时间，格式为 yyyyMMddHHmmss
	 * * @author  lly
	 * @date 创建时间：2015-8-10 下午4:47:09 
	 * @parameter  
	 * @return 
	 */
	public static String getCurrentTime() {
		return DateUtil.formatDate(new Date(), "yyyyMMddHHmmss");
	}
	
	/**获得当前时间，格式为 yyyyMMdd
	 * * @author  lly
	 * @date 创建时间：2015-8-10 下午4:47:09 
	 * @parameter  
	 * @return 
	 */
	public static String getTime() {
		return DateUtil.formatDate(new Date(), "yyyyMMdd");
	}
	
	/**得到日期的前一天  日期的格式为yyyyMMdd 
	 * * @author  lly
	 * @date 创建时间：2015-8-13 上午11:25:14 
	 * @parameter  
	 * @return 
	 */
	public static String getSpecifiedDayBefore(String specifiedDay) {
	    Calendar c = Calendar.getInstance();  
	    Date date = null;  
	    try {  
	        date = new SimpleDateFormat("yyyyMMdd").parse(specifiedDay);  
	    } catch (Exception e) {  
	        e.printStackTrace();  
	    }  
	    c.setTime(date);  
	    int day = c.get(Calendar.DATE);  
	    c.set(Calendar.DATE, day - 1);  
	    String dayBefore = new SimpleDateFormat("yyyyMMdd").format(c  
	            .getTime());  
	    return dayBefore;  
	}
	
	/**
	 * 计算验证码，输入12位条码， 返回带验证码的条码
	 */
	public static String ean13(String code) {
		int sumj=0,sume=0;
		int result=0;
		for(int i =0;i< code.length()-1;i=i+2)
		{
			sumj += code.charAt(i) - '0';
			sume += code.charAt(i+1) - '0';
		}
		
		result = sumj + sume *3;
		result = result % 10;
		if(result == 10 || result == 0)
			result = 0;
		else
			result = 10 -result;
		return code + result;
	}
}