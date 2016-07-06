package cn.qpwa.common.utils;

import java.math.BigDecimal;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ValidateUtil {

	/**
	 * 验证手机号的正确性的（空号、错号都不行），支持的号段有： 移动：139 138 137 136 135 134 147 150 151 152
	 * 157 158 159 178 182 183 184 187 188 联通：130 131 132 155 156 185 186 145
	 * 176 电信：133 153 177 180 181 189
	 * 
	 * @param mobiles
	 *            手机号码
	 * @return boolean
	 */
	public static boolean isMobileNO(String mobiles) {
		Pattern p = Pattern.compile("^0?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}

	/**
	 * 验证固定电话号码的格式是否正确
	 * 
	 * @param tel
	 *            规定电话号码
	 * @return
	 */
	public static boolean isTelNO(String tel) {
		Pattern p = Pattern.compile("^((\\+?86)|(\\(\\+86\\)))?(\\d{3,4})?(-)?\\d{7,8}(-\\d{3,4})?$");
		Matcher m = p.matcher(tel);
		return m.matches();
	}

	public static boolean userNameCheck(String username) {
		Pattern p = Pattern.compile("^[0-9a-z_A-Z\u4e00-\u9fa5]+$");
		Matcher m = p.matcher(username);
		return m.matches();
	}

	/**
	 * 校验字符串是否为BigDecimal
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isBigDecimal(String str) {
		try {
			new BigDecimal(str);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 得到一个字符串的长度,显示的长度,一个汉字或日韩文长度为3,英文字符长度为1
	 * 
	 * @param String
	 *            s 需要得到长度的字符串
	 * @return int 得到的字符串长度
	 */
	public static int length(String s) {
		if (s == null)
			return 0;
		char[] c = s.toCharArray();
		int len = 0;
		for (int i = 0; i < c.length; i++) {
			len++;
			if (!isLetter(c[i])) {
				len = len + 2;
			}
		}
		return len;
	}

	public static boolean isLetter(char c) {
		int k = 0x80;
		return c / k == 0 ? true : false;
	}

	/**
	 * 验证日期格式是否为yyyy-mm格式的,例如2014-01
	 * @param time
	 * @return
	 */
	public static boolean isDateToMonth(String time) {
		Pattern p = Pattern.compile("^\\d{4}?(?:0[1-9]|1[0-2])$");
		Matcher m = p.matcher(time);
		return m.matches();
	}
	
}
