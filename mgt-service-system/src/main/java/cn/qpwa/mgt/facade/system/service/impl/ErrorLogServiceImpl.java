package cn.qpwa.mgt.facade.system.service.impl;


import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.ErrorLogDAO;
import cn.qpwa.mgt.facade.system.entity.ErrorLog;
import cn.qpwa.mgt.facade.system.service.ErrorLogService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 错误日志接口实现类，提供相关的业务逻辑操作
 * @author TheDragonLord
 *
 */
@Service("errorLogService")
@Transactional(readOnly = false,propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
@SuppressWarnings("rawtypes")
public class ErrorLogServiceImpl implements ErrorLogService{

	@Autowired
	private ErrorLogDAO errorLogDAO;

	@Override
	public Page getErrorLogList(Map<String, Object> paramMap,
								LinkedHashMap<String, String> orderby) {
		return errorLogDAO.getErrorLogList(paramMap,orderby);
	}

	@Override
	public Map<String, Object> getErrorLogDetail(String errorCode) {
		if(StringUtils.isNotBlank(errorCode) && StringUtils.isNotEmpty(errorCode)){
			return (Map<String,Object>) errorLogDAO.getErrorLogDetail(errorCode);
		}
		return null;
	}

	@Override
	public ErrorLog findById(String errorCode) {
		if(StringUtils.isNotBlank(errorCode) && StringUtils.isNotEmpty(errorCode)){
			return errorLogDAO.findUniqueBy(ErrorLog.class, "errorCode", errorCode);
		}
		return null;
	}

	@Override
	public void saveOrUpdate(ErrorLog errorLog) {
		errorLogDAO.save(errorLog);
	}
	
	
	
	
}
