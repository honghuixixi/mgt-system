package cn.qpwa.common.utils;

import cn.qpwa.common.constant.LogConstant;

import java.util.HashMap;
import java.util.Map;

public class MapUtil {

	// 登录标志
	public static int LOGIN = 1;
	// 退出标志
	public static int LOGOUT = 2;

	private static Map<String, String> map = new HashMap<String, String>();

	/**
	 * 登录退出时设置登录日志map入参
	 * @param actionCode
	 * @param actionName
	 * @return
	 */
	public static Map<String, String> orgLoginLogMap(int loginFlag) {
		if (loginFlag == MapUtil.LOGIN) {
			map.put(LogConstant.ACTION_CODE, LogConstant.ACTION_CODE_LOGIN);
			map.put(LogConstant.ACTION_NAME, LogConstant.ACTION_NAME_LOGIN);
		}
		if (loginFlag == MapUtil.LOGOUT) {
			map.put(LogConstant.ACTION_CODE, LogConstant.ACTION_CODE_LOGOUT);
			map.put(LogConstant.ACTION_NAME, LogConstant.ACTION_NAME_LOGOUT);
		}
		return map;
	}

	/**
	 * 业务操作时设置业务日志map入参
	 * @param actionId   涉及到的业务id包括物流号/订单号等信息
	 * @param actionCode 业务行动代码
	 * @param actionName 行动名称
	 * @param actionType 业务类型
	 * @param bizModule  业务模块
	 * @param bizName    业务名称
	 * @return
	 */
	public static Map<String, String> orgBizActionMap(String actionId,String actionCode, String actionName, String actionType,
			String bizModule, String bizName) {
		map.put(LogConstant.ACTION_ID, actionId);
		map.put(LogConstant.ACTION_CODE, actionCode);
		map.put(LogConstant.ACTION_NAME, actionName);
		map.put(LogConstant.ACTION_TYPE, actionType);
		map.put(LogConstant.BIZ_MODULE, bizModule);
		map.put(LogConstant.BIZ_NAME, bizName);
		return map;
	}

}
