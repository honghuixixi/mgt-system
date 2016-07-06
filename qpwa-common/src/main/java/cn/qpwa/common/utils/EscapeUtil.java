package cn.qpwa.common.utils;

import org.apache.commons.lang.StringEscapeUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Enumeration;

@SuppressWarnings("rawtypes")
public final class EscapeUtil {
	private static String toHex(char c) {
		return Integer.toHexString(c).toUpperCase();
	}

	public static final String escape(String plainText) {
		if (plainText == null)
			return "";
		int i = plainText.length();
		StringBuffer result = new StringBuffer(i);
		for (int j = 0; j < i; j++) {
			char c;
			if ((c = plainText.charAt(j)) > '࿿')
				result.append("%u" + toHex(c));
			else if (c > 'ÿ')
				result.append("%u0" + toHex(c));
			else if (c > '')
				result.append("%u00" + toHex(c));
			else if (((c >= '0') && (c <= '9')) || ((c >= 'A') && (c <= 'Z')) || ((c >= 'a') && (c <= 'z')))
				result.append(c);
			else if (c > '\r')
				result.append("%" + toHex(c));
			else
				result.append("%0" + toHex(c));
		}
		return result.toString();
	}

	public static String UrlEncode(String str) {
		return UrlEncode(str, "UTF-8");
	}

	public static String UrlEncode(String str, String type) {
		try {
			return URLEncoder.encode(str, type);
		} catch (UnsupportedEncodingException ex) {
			throw new RuntimeException("字符串编码错误", ex);
		}
	}

	public static String UrlDecode(String str) {
		return UrlDecode(str,"UTF-8");
	}

	public static String UrlDecode(String str, String type) {
		try {
			return URLDecoder.decode(str, type);
		} catch (UnsupportedEncodingException ex) {
			throw new RuntimeException("字符串解码错误", ex);
		}
	}

	public static final String unescape(String encodedText) {
		if (encodedText == null)
			return "";
		StringBuffer temp = new StringBuffer(4);
		StringBuffer result = new StringBuffer();
		int len = encodedText.length();
		int j = 0;
		int k = 0;
		int l = 0;
		char c1 = '\000';
		for (int i = 0; i < len; i++) {
			char c = encodedText.charAt(i);
			if (k != 0) {
				if (j != 0) {
					j = 0;
					if (c == 'u') {
						l = 1;
						k = 1;
						continue;
					}
				}
				temp.append(c);
				if (temp.length() != (l != 0 ? 4 : 2))
					k = 1;
				else
					try {
						int i2 = Integer.parseInt(temp.toString(), 16);
						result.append((char) i2);
						temp.setLength(0);
						k = 0;
						l = 0;
					} catch (NumberFormatException ex) {
						throw new IllegalArgumentException("Unable to parse unicode value: " + temp);
					}
			} else if ((c == '%') || (c == '$')) {
				j = 1;
				c1 = c;
				k = 1;
			} else {
				result.append(c);
			}
		}
		if (j != 0)
			result.append(c1);
		return result.toString();
	}

	public static final String escapeXml(String xml) throws UnsupportedEncodingException {
		return StringEscapeUtils.escapeXml(xml);
	}

	public static void requestConvertPostUrlEncode(HttpServletRequest request, String FromCodeName, String ToCodeName,
			String qs) {
		String paramName = "";

		Enumeration paramNames = request.getParameterNames();
		while (true) {
			if (!paramNames.hasMoreElements())
				return;
			paramName = (String) paramNames.nextElement();
			if (qs.indexOf(paramName + "=") > -1) {
				String[] paramValues = request.getParameterValues(paramName);
				for (int i = 0; i < paramValues.length; i++)
					paramValues[i] = convertCharacterSet(paramValues[i], FromCodeName, ToCodeName);
			}
		}
	}

	public static final String convertCharacterSet(String str, String formCharacterSet, String toCharacterSet) {
		String convertedStr = null;
		try {
			convertedStr = new String(str.getBytes(formCharacterSet), toCharacterSet);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return convertedStr;
	}

	public static void requestConvertEncode(HttpServletRequest request, String fromCodeName, String toCodeName) {
		String paramName = "";

		Enumeration paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			paramName = (String) paramNames.nextElement();

			String[] paramValues = request.getParameterValues(paramName);
			for (int i = 0; i < paramValues.length; i++)
				paramValues[i] = convertCharacterSet(paramValues[i], fromCodeName, toCodeName);
		}
	}

	public static String getExt(String fileName) {
		return fileName.substring(fileName.lastIndexOf(46) + 1).toLowerCase();
	}
}