package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.SysBizActionLog;
import cn.qpwa.mgt.facade.system.vo.User;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("rawtypes")
public interface LogService {
	
	/**
	 * 增加登录登出，业务系统日志信息
	 * @param map
	 * @param t
	 * @param busiType
	 */
	<T> void log(Map<String, String> map, T t, int busiType);
	
	/**
	 * 增加登陆登出，业务系统日志信息 -- 为app端提供
	 * @param map
	 * @param t
	 * @param busiType
	 * @param user
	 */
	<T> void logByApp(Map<String, String> map, T t, int busiType, User user);
	
	/**
	 * 分页查询业务系统日志
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page findSysLogPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 根据主键PK_NO查询业务系统实体
	 * @param id
	 * @return
	 */
	public SysBizActionLog get(BigDecimal id);
	
	
	/**
	 * 查询自己本省以及前一条记录
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, Object>> findNearestSysLog(Map<String, Object> paramMap);
	
	/**
	 * 登陆日志数据分页统计
	 * @param param
	 * @return
	 */
	public Page getLoginInfoList(Map<String, Object> param);
}
