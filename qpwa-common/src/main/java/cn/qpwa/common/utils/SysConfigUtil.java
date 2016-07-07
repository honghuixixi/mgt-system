package cn.qpwa.common.utils;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class SysConfigUtil implements LogEnabled {
	static ResourceBundle CONFIG = null;

	static Logger log = Logger.getLogger(SysConfigUtil.class);

	public static synchronized String get(String key) {
		try {
			String _key = StringUtils.defaultIfEmpty(key, "");
			if (!CONFIG.containsKey(_key)) {
				return null;
			}
			String str = CONFIG.getString(_key);
			str = StringUtils.defaultIfEmpty(str, "");
			return str.trim();
		} catch (Exception ex) {
			log.error(ExceptionUtils.getFullStackTrace(ex));
		}
		return null;
	}

	public static Map<String, String> getAllConfig() {
		Map map = new HashMap();
		for (String key : CONFIG.keySet()) {
			map.put(StringUtils.trim(key), StringUtils.trim(CONFIG.getString(key)));
		}
		return map;
	}

	static {
		try {
			CONFIG = ResourceBundle.getBundle("config/config");
		} catch (Exception ignored) {
		}
	}
}