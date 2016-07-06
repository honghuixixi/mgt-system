package cn.qpwa.common.easemob.api;

/**
 * @author honghui
 * @date   2016年4月29日
 */
public interface AuthTokenAPI {

	Object getAuthToken(String clientId, String clientSecret);
	
}
