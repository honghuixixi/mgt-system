package cn.qpwa.mgt.common.constant;

/**
 * 业务常量类
 * 
 */
public class BizConstant {

	/**
	 * 超级管理员账号名称
	 */
	public static final String USER_ACCOUNT = "superadmin";
	/**
	 * 初始化数据标识
	 */
	public static final String CREATE_BY = "sysinit";
	/**
	 * 本地sessionkey
	 */
	public static final String SESSION_KEY = "mgt_user";

	/**
	 * backurl
	 */
	public static final String BACK_URL = "back_url";

	/**
	 * 登陆用户权限(菜单)
	 */
	public static final String SESSION_USER_AUTHORITY_MENU = "user_authority_menu";

	/**
	 * 登陆用户权限(角色)
	 */
	public static final String SESSION_USER_AUTHORITY_ROLE = "user_authority_role";

	/**
	 * 超级管理员角色（0：不是 1：是）
	 */
	public static final String SESSION_USER_SUPER = "user_super";

	/**
	 * 机构类型
	 */
	public static final String DEPTCHANNEL = "qpwa";

	/**
	 * 机构状态标识 （0：未启用 1：已启用 2:已删除）
	 */
	public static final String ORG_STATUS_NO = "0";
	public static final String ORG_STATUS_YES = "1";
	public static final String ORG_STATUS_DELETE = "2";

	/**
	 * 状态 enable,disable
	 */
	public static final String STATUS_ENABLE = "enable";
	public static final String STATUS_DISABLE = "disable";

	/**
	 * 商户状态 状态0：申请 1：通过 2:不通过3:已删除
	 */
	public static final String MERCHANT_STATUS_INIT = "0";
	public static final String MERCHANT_STATUS_PASS = "1";
	public static final String MERCHANT_STATUS_NOPASS = "2";
	public static final String MERCHANT_STATUS_DEL = "3";
	
	public static final String PROMTYPE_DISCOUNT = "WEBPROMA";
	public static final String PROMTYPE_PRESENT = "WEBPROMB";
	public static final String PROMTYPE_COMBO = "WEBPROMC";
	public static final String PROMTYPE_LIMBUY = "WEBPROMD";
}
