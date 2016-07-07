package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.ErrorLog;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 错误日志访问层接口，提供错误日志的CRUD操作
 * @author TheDragonLord
 *
 */
@SuppressWarnings("all")
public interface ErrorLogDAO extends EntityDao<ErrorLog> {

	/**
	 * 获取错误日志信息
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page getErrorLogList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

	/**
	 * 获取错误日志详情
	 * @param errorCode
	 * @return
	 */
	public Map<String, Object> getErrorLogDetail(String errorCode);

}
