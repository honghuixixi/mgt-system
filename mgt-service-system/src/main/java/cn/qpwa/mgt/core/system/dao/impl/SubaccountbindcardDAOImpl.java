package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.SubaccountbindcardDAO;
import cn.qpwa.mgt.facade.system.entity.Subaccountbindcard;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Repository("subaccountbindcardDAO")
public class SubaccountbindcardDAOImpl extends HibernateEntityDao<Subaccountbindcard> implements SubaccountbindcardDAO{
	
	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select t.*,t1.BANK_NAME as BANKTYPENAME from SUBACCOUNTBINDCARD t left join BANK_TYPE_INFO t1 on t.BANK_TYPE = t1.BANK_TYPE where 1=1 ");
		if (null != paramMap) {
 
			if (paramMap.containsKey("subaccountType") && StringUtils.isNotBlank(paramMap.get("subaccountType").toString())) {
				sql.append(" and t.SUBACCOUNT_TYPE=:subaccountType");
				param.put("subaccountType", paramMap.get("subaccountType"));
			}
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	@Override
	public Page queryBankCards(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select t.id,t.bankcardno,t.bankcardname,t.bank_type,t.bank_name,t.user_cert_type,t.user_cardno,t.user_bankmob,t.cardbindtime from subaccountbindcard t where 1=1 ");
		if (null != paramMap) {
 
			if (paramMap.containsKey("subaccountType") && StringUtils.isNotBlank(paramMap.get("subaccountType").toString())) {
				sql.append(" and t.SUBACCOUNT_TYPE=:subaccountType");
				param.put("subaccountType", paramMap.get("subaccountType"));
			}
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
}
