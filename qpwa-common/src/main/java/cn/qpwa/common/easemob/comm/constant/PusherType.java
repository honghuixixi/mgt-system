package cn.qpwa.common.easemob.comm.constant;

/**
 * 消息推送类型 
 * @author honghui
 * @date   2016-05-30
 */
public enum PusherType {

	LOGISTICS("WLW_SYS_WL","101","物流服务"),
	NOTICE("WLW_SYS_TZ","102","通知消息"),
	INSTANT("WLW_SYS_TX","103","即时通讯"),
	ACTIVITY("WLW_SYS_HD","104","物恋活动");
	
	private String username;  //消息推送账户名FROM
	private String code;      //编码
	private String desc;      //描述
	
	private PusherType(String username, String code, String desc) {
		this.username = username;
		this.code = code;
		this.desc = desc;
	}

	public String getUsername() {
		return username;
	}
	
	public static String getUsername(String code) {
		for (PusherType c : PusherType.values()) {
            if (c.code == code) {
                return c.username;
            }
        }
		return null;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}
	
}
