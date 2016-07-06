package cn.qpwa.common.easemob.api;

import cn.qpwa.common.easemob.comm.ClientContext;

/**
 * @author honghui
 * @date   2016年4月29日
 */
public abstract class EasemobRestAPI implements RestAPI{

	private ClientContext context;
	
	private RestAPIInvoker invoker;

	public abstract String getResourceRootURI();
	
	public ClientContext getContext() {
		return context;
	}

	public void setContext(ClientContext context) {
		this.context = context;
	}

	public RestAPIInvoker getInvoker() {
		return invoker;
	}

	public void setInvoker(RestAPIInvoker invoker) {
		this.invoker = invoker;
	}
	
}
