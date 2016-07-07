package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtSettingDtlDAO;
import cn.qpwa.mgt.facade.system.entity.MgtSettingDtl;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Repository("mgtSettingDtlDAOImpl")
@SuppressWarnings({"deprecation","rawtypes","unchecked"})
public class MgtSettingDtlDAOImpl extends HibernateEntityDao<MgtSettingDtl> implements MgtSettingDtlDAO {

	@Override
	public MgtSettingDtl findMgtSettingByItemNoAndCode(String itemNo,
			String merchantCode) {
		StringBuffer sql =  new StringBuffer("SELECT t FROM MgtSettingDtl t WHERE EMPLOYEE_ID = ? AND ITEM_NO = ?");
		Query query = super.getSession().createQuery(sql.toString());
		query.setString(0, merchantCode);
	    query.setBigDecimal(1, new BigDecimal(itemNo));
		return (MgtSettingDtl) query.uniqueResult();
	}


	@Override
	public List<Map<String, Object>> queryMgtSettingDtlList(
			Map<String, Object> param) {
		
		StringBuffer sql = new StringBuffer("select * from MGT_SETTING_DTL t where 1=1 ");
		if(param.containsKey("merchantCode") && !StringUtils.isEmpty(param.get("merchantCode").toString())){
			sql.append(" and t.EMPLOYEE_ID = :merchantCode");	
		}
		if(param.containsKey("itemNo") && !StringUtils.isEmpty(param.get("itemNo").toString())){
			sql.append(" and t.item_no = :itemNo");
		}
		Query query = super.createSQLQuery(sql.toString(),param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}

	
}
