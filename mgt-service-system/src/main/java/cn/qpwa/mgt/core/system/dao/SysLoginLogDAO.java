package cn.qpwa.mgt.core.system.dao;


import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.SysLoginLog;

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
