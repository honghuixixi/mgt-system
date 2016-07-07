package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.ErrorLogDAO;
import cn.qpwa.mgt.facade.system.entity.ErrorLog;
import org.apache.commons.lang.StringUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 错误日志访问层接口实现类，提供错误日志的CRUD操作
 * @author TheDragonLord
 *
 */
@Repository("errorLogDAO")
@SuppressWarnings("all")
public class ErrorLogDAOImpl extends HibernateEntityDao<ErrorLog> implements ErrorLogDAO{

	@Override
	public Page getErrorLogList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String,Object> param = new HashMap<String,Object>();
		StringBuilder sql = new StringBuilder("SELECT e.ERROR_CODE,e.GRADE,e.APP_CODE,e.Description,e.STATUS_FLG,e.CREATE_DATE,e.USER_NO,e.WORK_DATE,e.WORK_RESULT,e.USER_NAME FROM ERROR_LOG e WHERE 1=1");
		if(null != paramMap){
			if(paramMap.containsKey("grade") && StringUtils.isNotBlank(paramMap.get("grade").toString())){
				sql.append(" AND GRADE =:grade");
				param.put("grade", paramMap.get("grade"));
			}
			if(paramMap.containsKey("appCode") && StringUtils.isNotBlank(paramMap.get("appCode").toString())){
				sql.append(" AND APP_CODE =:appCode");
				param.put("appCode", paramMap.get("appCode"));
			}
			if(paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())){
				sql.append(" AND STATUS_FLG =:statusFlg");
				param.put("statusFlg", paramMap.get("statusFlg"));
			}
			if(paramMap.containsKey("description") && StringUtils.isNotBlank(paramMap.get("description").toString())){
				sql.append(" AND DESCRIPTION like:description");
				param.put("description", "%" + paramMap.get("description") + "%");
			}
			
			if(paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())){
				orderby = new  LinkedHashMap<String,String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Map<String, Object> getErrorLogDetail(String errorCode) {
		String sql = "SELECT * FROM ERROR_LOG WHERE ERROR_CODE = :errorCode";
		SQLQuery sqlQuery = super.getSession().createSQLQuery(sql);
		return (Map<String,Object>)sqlQuery.setString("errorCode", errorCode).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}
	
	



}
