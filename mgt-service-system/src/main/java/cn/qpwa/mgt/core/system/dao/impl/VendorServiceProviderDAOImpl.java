package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.mgt.core.system.dao.VendorServiceProviderDAO;
import cn.qpwa.mgt.facade.system.entity.VendorServiceProvider;
import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository("vendorServiceProviderDAO")
@SuppressWarnings("all")
public class VendorServiceProviderDAOImpl extends HibernateEntityDao<VendorServiceProvider>  implements VendorServiceProviderDAO {

	@Override
	public Page findPage(Map<String, Object> paramsMap, LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("select vsr.PK_NO,vsr.SERVICE_NAME,vsr.USER_NO,vsr.USER_NAME,vsr.USER_PASSWORD,vsr.NAME,vsr.VENDOR_CODE,"
				+ "to_char(vsr.WORK_TIME_FROM,'yyyy-MM-dd HH:mm:ss') as WORK_TIME_FROM,to_char(vsr.WORK_TIME_TO,'yyyy-MM-dd HH:mm:ss') as WORK_TIME_TO,"
				+ "to_char(vsr.CREATE_DATE,'yyyy-MM-dd') as CREATE_DATE,vsr.ACTIVE_FLG,vsr.SORT_NO,vsr.TYPE from VENDOR_SERVICE_PROVIDER vsr where 1=1 ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(null != paramsMap){
			if(paramsMap.containsKey("serviceName") && StringUtils.isNotBlank(paramsMap.get("serviceName").toString())){
				sql.append(" and vsr.SERVICE_NAME like :serviceName");
				param.put("serviceName", "%"+paramsMap.get("serviceName").toString()+"%");
			}
			if(paramsMap.containsKey("vendorCode") && StringUtils.isNotBlank(paramsMap.get("vendorCode").toString())){
				sql.append(" and vsr.VENDOR_CODE =:vendorCode");
				param.put("vendorCode",paramsMap.get("vendorCode").toString());
			}
			if(paramsMap.containsKey("activeFlg") && StringUtils.isNotBlank(paramsMap.get("activeFlg").toString())){
				sql.append(" and vsr.ACTIVE_FLG =:activeFlg");
				param.put("activeFlg",paramsMap.get("activeFlg").toString());
			}
			if(paramsMap.containsKey("userNo") && StringUtils.isNotBlank(paramsMap.get("userNo").toString())){
				sql.append(" and vsr.USER_NO =:userNo");
				param.put("userNo",paramsMap.get("userNo").toString());
			}
		}
		sql.append(" order by vsr.type asc, vsr.SORT_NO asc");
		Page page = super.sqlqueryForpage(sql.toString(), param, orderby);
		return page;
	}
	
	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from VendorServiceProvider where PK_NO in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public List<VendorServiceProvider> preview(String vendorCode) {
		StringBuffer hql = new StringBuffer("select vsp from VendorServiceProvider vsp ");
		hql.append("where vsp.vendorCode=:vendorCode and vsp.activeFlg ='A' ")
			.append("order by vsp.type, vsp.sortNO");
		Query query = getSession().createQuery(hql.toString());
		
		return query.setParameter("vendorCode", vendorCode).list();
	}
	
	
	

}

