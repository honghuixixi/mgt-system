package cn.qpwa.common.easemob.api;

import cn.qpwa.common.easemob.comm.wrapper.BodyWrapper;
import cn.qpwa.common.easemob.comm.wrapper.HeaderWrapper;
import cn.qpwa.common.easemob.comm.wrapper.QueryWrapper;
import cn.qpwa.common.easemob.comm.wrapper.ResponseWrapper;

import java.io.File;

/**
 * @author honghui
 * @date   2016年4月29日
 */
public interface RestAPIInvoker {

	ResponseWrapper sendRequest(String method, String url, HeaderWrapper header, BodyWrapper body, QueryWrapper query);
	ResponseWrapper uploadFile(String url, HeaderWrapper header, File file);
    ResponseWrapper downloadFile(String url, HeaderWrapper header, QueryWrapper query);
    
}
