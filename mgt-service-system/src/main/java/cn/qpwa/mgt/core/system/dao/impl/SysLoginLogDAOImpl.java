package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.SysLoginLogDAO;
import cn.qpwa.mgt.facade.system.entity.SysLoginLog;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Repository("sysLoginLogDao")
@SuppressWarnings("rawtypes")
public class SysLoginLogDAOImpl extends HibernateEntityDao<SysLoginLog> implements SysLoginLogDAO {
	
	@Override
	public Page getLoginInfoList(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("select s.* from sys_login_log s where 1=1 ");
		Map<String, Object> param = new HashMap<String, Object>();
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		if(paramMap != null){
			if (paramMap.containsKey("user_name") && StringUtils.isNotBlank(paramMap.get("user_name").toString())) {
				sql.append(" and s.user_name like :user_name");
				param.put("user_name", "%"+paramMap.get("user_name")+"%");
			}
			/*if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and name =:name");
				param.put("name", paramMap.get("name"));
			}*/
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and to_char(s.action_date,'yyyy-mm-dd hh24:mi') >=:startDate");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and to_char(s.action_date,'yyyy-mm-dd hh24:mi') <=:endDate");
				param.put("endDate", paramMap.get("endDate"));
			}
			if (paramMap.containsKey("actionCode") && StringUtils.isNotBlank(paramMap.get("actionCode").toString())) {
				sql.append(" and s.action_code = :actionCode");
				param.put("actionCode", paramMap.get("actionCode"));
			}
		}
		if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}else{
			orderby.put("action_date", "desc");
		}
		return super.sqlqueryForpage(sql.toString(),param,orderby);
	}
}
