package cn.qpwa.mgt.common.constant;

public class LogConstant {
	/**
	 * 1.登录日志  2.系统业务日志
	 */
	public static final int SYS_LOGIN_LOG = 1;
	public static final int SYS_BIZ_ACTION_LOG = 2;
	
	/** 业务ID 物流号/订单号等信息*/
	public static final String ACTION_ID = "actionId";
	/** 行动代码  LOGIN/LOGOUT等*/
	public static final String ACTION_CODE = "actionCode";
	/** 行动名称：登录/退出*/
	public static final String ACTION_NAME = "actionName";
	/** 行动类型*/
	public static final String ACTION_TYPE = "actionType";
	/** 业务模块*/
	public static final String BIZ_MODULE = "bizModule";
	/** 业务名称*/
	public static final String BIZ_NAME = "bizName";
	
	/**行动代码value LOGIN/LOGOUT*/
	public static final String ACTION_CODE_LOGIN = "LOGIN";
	public static final String ACTION_CODE_LOGOUT = "LOGOUT";
	
	/**行动名称value 登录/退出*/
	public static final String ACTION_NAME_LOGIN = "登录";
	public static final String ACTION_NAME_LOGOUT = "退出";
	
	/** 行动类型增删改查 */
	public static final String ACTION_TYPE_SELECT = "select";
	public static final String ACTION_TYPE_UPDATE = "update";
	public static final String ACTION_TYPE_INSERT = "insert";
	public static final String ACTOIN_TYPE_DELETE = "delete";
	
}
