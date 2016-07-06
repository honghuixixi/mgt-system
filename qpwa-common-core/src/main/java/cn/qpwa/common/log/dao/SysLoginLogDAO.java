package cn.qpwa.common.log.dao;


import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.entity.SysLoginLog;
import cn.qpwa.common.page.Page;

import java.util.Map;

@SuppressWarnings("rawtypes")
public interface SysLoginLogDAO extends EntityDao<SysLoginLog>{
	/**
	 * 登陆日志统计
	 * @param paramMap
	 * @return
	 */
	public Page getLoginInfoList(Map<String, Object> paramMap);
}
