package cn.qpwa.mgt.facade.system.service;



import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.ErrorLog;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 错误日志业务逻辑接口，提供错误日志的相关业务操作
 * @author TheDragonLord
 *
 */
@SuppressWarnings({"rawtypes"})
public interface ErrorLogService {

	/**
	 * 跳转到错误日志页面
	 * @param modelMap
	 * @return
	 */
	public Page getErrorLogList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

	/**
	 * 跳转到错误日志详情页面
	 * @param errorCode
	 * @return
	 */
	public Map<String, Object> getErrorLogDetail(String errorCode);

	/**
	 * 根据ID查询错误日志
	 * @param string
	 * @return
	 */
	public ErrorLog findById(String errorCode);

	/**
	 * 更新错误日志
	 * @param errorLog
	 */
	public void saveOrUpdate(ErrorLog errorLog);
	
}
