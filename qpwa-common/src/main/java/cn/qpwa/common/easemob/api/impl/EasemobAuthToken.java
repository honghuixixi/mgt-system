package cn.qpwa.common.easemob.api.impl;

import cn.qpwa.common.easemob.api.AuthTokenAPI;
import cn.qpwa.common.easemob.api.EasemobRestAPI;
import cn.qpwa.common.easemob.comm.body.AuthTokenBody;
import cn.qpwa.common.easemob.comm.constant.HTTPMethod;
import cn.qpwa.common.easemob.comm.helper.HeaderHelper;
import cn.qpwa.common.easemob.comm.wrapper.BodyWrapper;
import cn.qpwa.common.easemob.comm.wrapper.HeaderWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class EasemobAuthToken extends EasemobRestAPI implements AuthTokenAPI{
	
	public static final String ROOT_URI = "/token";
	
	private static final Logger log = LoggerFactory.getLogger(EasemobAuthToken.class);
	
	@Override
	public String getResourceRootURI() {
		return ROOT_URI;
	}

	public Object getAuthToken(String clientId, String clientSecret) {
		String url = getContext().getSeriveURL() + getResourceRootURI();
		BodyWrapper body = new AuthTokenBody(clientId, clientSecret);
		HeaderWrapper header = HeaderHelper.getDefaultHeader();
		
		return getInvoker().sendRequest(HTTPMethod.METHOD_POST, url, header, body, null);
	}
}
