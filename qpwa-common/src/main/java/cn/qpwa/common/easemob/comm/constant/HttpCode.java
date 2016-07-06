package cn.qpwa.common.easemob.comm.constant;

/**
 * 环信错误码
 * @author honghui
 * @date   2016-05-27
 */
public enum HttpCode {
	
	SUCCESS("请求成功",200),
	ERROR_REQUEST("错误请求",400),
	UNAUTHORIZED("未授权",401),
	REFUSE("拒绝请求",403),
	NOT_FOUND("未找到",404),
	REQUEST_TIME_OUT("请求超时",408),
	REQUEST_BODY_TOO_LARGE("请求体过大",413),
	SERVICE_INTERNAL_ERROR("服务器内部错误",500),
	NOT_IMPLEMENTED("尚未实施",501),
	BAD_GATEWAY("错误网关",502),
	SERVICE_UNAVAILABLE("服务不可用",503),
	GATEWAY_TIME_OUT("网关超时",504);
	
	private String desc;
	private Integer code;
	
	private HttpCode(String desc, Integer code) {
		this.desc = desc;
		this.code = code;
	}

	public static String getDesc(int code) {
		for (HttpCode c : HttpCode.values()) {
            if (c.code == code) {
                return c.desc;
            }
        }
		return null;
	}
	
	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}
	
}
