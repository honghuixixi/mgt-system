package cn.qpwa.common.core.service;

import cn.qpwa.common.utils.LogEnabled;

public interface BaseService<T> extends LogEnabled {

	public void removeUnused(String paramString);

	public T get(String paramString);

	public void saveOrUpdate(T paramT);
	
}