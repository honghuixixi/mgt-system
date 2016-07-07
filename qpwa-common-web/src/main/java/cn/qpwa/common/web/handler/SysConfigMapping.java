package cn.qpwa.common.web.handler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class SysConfigMapping {
	public static Map<String, String> loadUrlMap = new ConcurrentHashMap();
	public static Map<String, String> loadFrameworkMap = new ConcurrentHashMap();
	public static Map<String, String> loadAuthorityMap = new ConcurrentHashMap();
}