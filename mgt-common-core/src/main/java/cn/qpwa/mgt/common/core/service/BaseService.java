package cn.qpwa.mgt.common.core.service;

import cn.qpwa.mgt.common.utils.LogEnabled;

public interface BaseService<T> extends LogEnabled {

	public void removeUnused(String paramString);

	public T get(String paramString);

	public void saveOrUpdate(T paramT);
	
}