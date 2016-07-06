package cn.qpwa.common.web.utils;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.InetAddress;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.util.Assert;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.request.ServletWebRequest;

import cn.qpwa.common.utils.setting.Setting;
import cn.qpwa.common.utils.setting.SettingUtils;
import cn.qpwa.common.web.vo.UserVO;

/**
 * Utils - Web
 * 
 * @author 
 * @version 1.0
 */
public final class WebUtils {

	public static final String SESSION_USER_PARAM = "user";
	//session区域id
	public static final String SESSION_AREAID_PARAM = "sessionAreaId";

	/**
	 * 不可实例化
	 */
	private WebUtils() {
	}

	/**
	 * 添加cookie
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param name
	 *            cookie名称
	 * @param value
	 *            cookie值
	 * @param maxAge
	 *            有效期(单位: 秒)
	 * @param path
	 *            路径
	 * @param domain
	 *            域
	 * @param secure
	 *            是否启用加密
	 */
	public static void addCookie(HttpServletRequest request, HttpServletResponse response,
			String name, String value, Integer maxAge, String path, String domain, Boolean secure) {
		Assert.notNull(request);
		Assert.notNull(response);
		Assert.hasText(name);
		try {
			name = URLEncoder.encode(name, "UTF-8");
			value = URLEncoder.encode(value, "UTF-8");
			Cookie cookie = new Cookie(name, value);
			if (maxAge != null) {
				cookie.setMaxAge(maxAge);
			}
			if (StringUtils.isNotEmpty(path)) {
				cookie.setPath(path);
			}
			if (StringUtils.isNotEmpty(domain)) {
				cookie.setDomain(domain);
			}
			if (secure != null) {
				cookie.setSecure(secure);
			}
			response.addCookie(cookie);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 添加cookie
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param name
	 *            cookie名称
	 * @param value
	 *            cookie值
	 * @param maxAge
	 *            有效期(单位: 秒)
	 */
	public static void addCookie(HttpServletRequest request, HttpServletResponse response,
			String name, String value, Integer maxAge) {
		Setting setting = SettingUtils.get();
		addCookie(request, response, name, value, maxAge, setting.getCookiePath(),
				setting.getCookieDomain(), null);
	}

	/**
	 * 添加cookie
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param name
	 *            cookie名称
	 * @param value
	 *            cookie值
	 */
	public static void addCookie(HttpServletRequest request, HttpServletResponse response,
			String name, String value) {
		Setting setting = SettingUtils.get();
		addCookie(request, response, name, value, null, setting.getCookiePath(),
				setting.getCookieDomain(), null);
	}

	/**
	 * 获取cookie
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param name
	 *            cookie名称
	 * @return 若不存在则返回null
	 */
	public static String getCookie(HttpServletRequest request, String name) {
		Assert.notNull(request);
		Assert.hasText(name);
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			try {
				name = URLEncoder.encode(name, "UTF-8");
				for (Cookie cookie : cookies) {
					if (name.equals(cookie.getName())) {
						return URLDecoder.decode(cookie.getValue(), "UTF-8");
					}
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * 移除cookie
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param name
	 *            cookie名称
	 * @param path
	 *            路径
	 * @param domain
	 *            域
	 */
	public static void removeCookie(HttpServletRequest request, HttpServletResponse response,
			String name, String path, String domain) {
		Assert.notNull(request);
		Assert.notNull(response);
		Assert.hasText(name);
		try {
			name = URLEncoder.encode(name, "UTF-8");
			Cookie cookie = new Cookie(name, null);
			cookie.setMaxAge(0);
			if (StringUtils.isNotEmpty(path)) {
				cookie.setPath(path);
			}
			if (StringUtils.isNotEmpty(domain)) {
				cookie.setDomain(domain);
			}
			response.addCookie(cookie);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 移除cookie
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param name
	 *            cookie名称
	 */
	public static void removeCookie(HttpServletRequest request, HttpServletResponse response,
			String name) {

		Assert.notNull(request);
		Assert.notNull(response);
		Assert.hasText(name);
		try {
			name = URLEncoder.encode(name, "UTF-8");
			Cookie cookie = new Cookie(name, null);
			cookie.setMaxAge(0);
			response.addCookie(cookie);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取参数
	 * 
	 * @param queryString
	 *            查询字符串
	 * @param encoding
	 *            编码格式
	 * @param name
	 *            参数名称
	 * @return 参数
	 */
	public static String getParameter(String queryString, String encoding, String name) {
		String[] parameterValues = getParameterMap(queryString, encoding).get(name);
		return parameterValues != null && parameterValues.length > 0 ? parameterValues[0] : null;
	}

	/**
	 * 获取参数
	 * 
	 * @param queryString
	 *            查询字符串
	 * @param encoding
	 *            编码格式
	 * @param name
	 *            参数名称
	 * @return 参数
	 */
	public static String[] getParameterValues(String queryString, String encoding, String name) {
		return getParameterMap(queryString, encoding).get(name);
	}

	/**
	 * 获取参数
	 * 
	 * @param queryString
	 *            查询字符串
	 * @param encoding
	 *            编码格式
	 * @return 参数
	 */
	public static Map<String, String[]> getParameterMap(String queryString, String encoding) {
		Map<String, String[]> parameterMap = new HashMap<String, String[]>();
		Charset charset = Charset.forName(encoding);
		if (StringUtils.isNotEmpty(queryString)) {
			byte[] bytes = queryString.getBytes(charset);
			if (bytes != null && bytes.length > 0) {
				int ix = 0;
				int ox = 0;
				String key = null;
				String value = null;
				while (ix < bytes.length) {
					byte c = bytes[ix++];
					switch ((char) c) {
					case '&':
						value = new String(bytes, 0, ox, charset);
						if (key != null) {
							putMapEntry(parameterMap, key, value);
							key = null;
						}
						ox = 0;
						break;
					case '=':
						if (key == null) {
							key = new String(bytes, 0, ox, charset);
							ox = 0;
						} else {
							bytes[ox++] = c;
						}
						break;
					case '+':
						bytes[ox++] = (byte) ' ';
						break;
					case '%':
						bytes[ox++] = (byte) ((convertHexDigit(bytes[ix++]) << 4) + convertHexDigit(bytes[ix++]));
						break;
					default:
						bytes[ox++] = c;
					}
				}
				if (key != null) {
					value = new String(bytes, 0, ox, charset);
					putMapEntry(parameterMap, key, value);
				}
			}
		}
		return parameterMap;
	}

	private static void putMapEntry(Map<String, String[]> map, String name, String value) {
		String[] newValues = null;
		String[] oldValues = map.get(name);
		if (oldValues == null) {
			newValues = new String[] { value };
		} else {
			newValues = new String[oldValues.length + 1];
			System.arraycopy(oldValues, 0, newValues, 0, oldValues.length);
			newValues[oldValues.length] = value;
		}
		map.put(name, newValues);
	}

	private static byte convertHexDigit(byte b) {
		if ((b >= '0') && (b <= '9')) {
			return (byte) (b - '0');
		}
		if ((b >= 'a') && (b <= 'f')) {
			return (byte) (b - 'a' + 10);
		}
		if ((b >= 'A') && (b <= 'F')) {
			return (byte) (b - 'A' + 10);
		}
		throw new IllegalArgumentException();
	}

	/**
	 * 获取系统的reqeust对象
	 * 
	 * @return 当前的request
	 */
	public static final HttpServletRequest getRequest() {
		return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
	}

	/**
	 * 获取response对象
	 * 
	 * @return 当前的response
	 */
	public static final HttpServletResponse getResponse() {
		ServletWebRequest servletWebRequest = new ServletWebRequest(getRequest());
		return servletWebRequest.getResponse();
	}

	/**
	 * 获取session对象
	 * 
	 * @return 当前的session
	 */
	public static final HttpSession getSession() {
		return getRequest().getSession();
	}

	/***
	 * 获取URI的路径,如路径为http://www.qpwa.cn/product/list.html?method=add,
	 * 得到的值为"product/list.html"
	 * 
	 * @return URI的路径
	 */
	public static String getRequestURI() {
		return getRequest().getRequestURI();
	}

	/**
	 * 获取完整请求路径(包含内容路径及请求参数)
	 * 
	 * @return URI完整请求路径
	 */
	public static String getRequestURIWithParam() {
		return getRequestURI()
				+ (getRequest().getQueryString() == null ? "" : "?" + getRequest().getQueryString());
	}

	/**
	 * 在session中获取登录用户信息
	 * 
	 * @return
	 */
	public static UserVO getSessionUser() {
		UserVO vo = (UserVO) getSession().getAttribute(SESSION_USER_PARAM);
		return vo != null ? vo : null;
	}

	/**
	 * 在session中设置登录用户信息
	 * 
	 */
	public static void setSessionUser(UserVO vo) {
		getSession().setAttribute(SESSION_USER_PARAM, vo);
	}

	/**
	 * 在session中删除登录用户信息
	 * 
	 */
	public static void removeSessionUser() {
		getSession().removeAttribute(SESSION_USER_PARAM);
	}

	/**
	 * 判断是否为ajax操作
	 * 
	 * @param request
	 *            Http请求对象
	 * @return
	 */
	public static boolean isAjaxRequest(HttpServletRequest request) {
		return request.getHeader("x-requested-with") != null
				&& request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest");
	}

	/**
	 * 获取用户IP地址
	 * 
	 * @returnIP地址
	 */
	public static String getIpAddr() {
		String ipAddress = null;
		// ipAddress = this.getRequest().getRemoteAddr();
		ipAddress = getRequest().getHeader("x-forwarded-for");
		if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = getRequest().getHeader("Proxy-Client-IP");
		}
		if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = getRequest().getHeader("WL-Proxy-Client-IP");
		}
		if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
			ipAddress = getRequest().getRemoteAddr();
			if (ipAddress.equals("127.0.0.1")) {
				// 根据网卡取本机配置的IP
				InetAddress inet = null;
				try {
					inet = InetAddress.getLocalHost();
				} catch (UnknownHostException e) {
					e.printStackTrace();
				}
				ipAddress = inet.getHostAddress();
			}

		}

		// 对于通过多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
		if (ipAddress != null && ipAddress.length() > 15) { // "***.***.***.***".length()
			if (ipAddress.indexOf(",") > 0) {
				ipAddress = ipAddress.substring(0, ipAddress.indexOf(","));
			}
		}
		Logger.getLogger(WebUtils.class.getName()).log(Level.INFO, "IP:" + ipAddress);
		return ipAddress;
	}
	
	/**
	 * 在session中获取区域id
	 * 
	 * @return
	 */
	public static BigDecimal getSessionAreaId() {
		BigDecimal areaId = (BigDecimal) getSession().getAttribute(SESSION_AREAID_PARAM);
		return areaId != null ? areaId : null;
	}

	/**
	 * 在session中设置区域id
	 * 
	 */
	public static void setSessionAreaId(BigDecimal areaId) {
		getSession().setAttribute(SESSION_AREAID_PARAM, areaId);
	}

	/**
	 * 在session中删除区域id
	 * 
	 */
	public static void removeSessionAareId() {
		getSession().removeAttribute(SESSION_AREAID_PARAM);
	}
}