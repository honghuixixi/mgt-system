package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.SysBizLogDAO;
import cn.qpwa.mgt.facade.system.entity.SysBizActionLog;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.*;

@Repository("sysBizLogDAO")
@SuppressWarnings({ "unchecked" })
public class SysBizLogDAOImpl extends HibernateEntityDao<SysBizActionLog> implements SysBizLogDAO {
	
	@Override
	public Page<SysBizActionLog> findSysLogPage(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(s.ACTION_DATE,'yyyy-mm-dd hh24:mi:ss') as ACTION_DATE_CHAR, "
						+ " s.* from SYS_BIZACTION_LOG s where 1=1  " + " ");
		Map<String, Object> param = new HashMap<String, Object>();
		if (paramMap != null) {
			if (paramMap.containsKey("startDate")
					&& StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and s.ACTION_DATE>=to_date(:startDate,'yyyy-mm-dd hh24:mi') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate")
					&& StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and s.ACTION_DATE<=to_date(:endDate,'yyyy-mm-dd hh24:mi') ");
				param.put("endDate", paramMap.get("endDate"));
			}
			if (paramMap.containsKey("actionId")
					&& StringUtils.isNotBlank(paramMap.get("actionId").toString())) {
				sql.append(" AND ACTION_ID = :actionId");
				param.put("actionId", paramMap.get("actionId"));
			}
		}
		if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		} else {
			sql.append(" order by s.ACTION_DATE desc");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public List<Map<String, Object>> findNearestSysLog(Map<String, Object> paramMap) {
		List<Object> para = new ArrayList<Object>();
		boolean nextFlg = false;
		StringBuilder sql = new StringBuilder(
				"SELECT * FROM  (SELECT * FROM (SELECT s.*,substr(s.action_code,instr(s.action_code,'_')+1) "
						+ " AS code from Sys_BizAction_Log s)  a ");
		
		if (paramMap.containsKey("code")
				&& StringUtils.isNotBlank(paramMap.get("code").toString())) {
			sql.append(" WHERE code = ? ");
			para.add(paramMap.get("code"));
		}
		if(paramMap.containsKey("pkNoStr")
				&& StringUtils.isNotBlank(paramMap.get("pkNoStr").toString())){
			sql.append(" and biz_content Like '%"+ paramMap.get("pkNoStr")+"%' ");
		}
		if(paramMap.containsKey("nextFlg")
				&& StringUtils.isNotBlank(paramMap.get("nextFlg").toString())
				&& paramMap.get("nextFlg").toString().equals("true")){
			nextFlg = true;
		}
		if(nextFlg){
			sql.append(" ORDER BY a.action_date ASC,a.pk_no ASC) WHERE ");
		}else{
			sql.append(" ORDER BY a.action_date DESC,a.pk_no DESC) WHERE ");
		}
		if (paramMap.containsKey("actionDate")
				&& StringUtils.isNotBlank(paramMap.get("actionDate").toString())) {
			if(nextFlg){
				sql.append(" action_date >= to_date(?,'yyyy-mm-dd hh24:mi:ss')  AND ");
			}else{
				sql.append(" action_date <= to_date(?,'yyyy-mm-dd hh24:mi:ss')  AND ");
			}
			para.add(paramMap.get("actionDate"));
		}
		if(paramMap.containsKey("pkNo")
				&& StringUtils.isNotBlank(paramMap.get("pkNo").toString())){
			if(nextFlg){
				sql.append(" pk_no >= ? AND ");
			}else{
				sql.append(" pk_no <= ? AND ");
			}
			para.add(paramMap.get("pkNo"));
		}
		sql.append(" ROWNUM < 3 ");
		
		return super.sqlQueryForList(sql.toString(), para.toArray(),null);
	}

	
}
