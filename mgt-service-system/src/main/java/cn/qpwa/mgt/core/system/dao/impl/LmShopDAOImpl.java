package cn.qpwa.mgt.core.system.dao.impl;


import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.LmShopDAO;
import cn.qpwa.mgt.facade.system.entity.LmShop;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@Repository("lmShopDAO")
public class LmShopDAOImpl extends HibernateEntityDao<LmShop> implements LmShopDAO {

	@Override
	public LmShop findByUserName(String userName) {
		if (userName == null) {
			return null;
		}
		return this.findUniqueBy("userName", userName);
	}
	
	@Override
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby){
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select LM.ADDRESS, LM.LONGITUDE, LM.LATITUDE, LM.NAME AS LM_NAME, T.STATUS_FLG as SHOP_STATUS_FLG, T.UUID, T.CREATE_DATE, T2.DELIVERY_NOTE," +
				" (select (select AREA_NAME from AREA_MAS_WEB where GRADE = 1 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) || (select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) || AREA_NAME  from AREA_MAS_WEB a where AREA_ID =LM.AREA_ID) as area_name,"+
				"GET_DISTANCE_BY_LL(sc.LONGITUDE,sc.LATITUDE,lm.LONGITUDE,lm.LATITUDE) as distance " +
				"from LM_SHOP T " +
				"left join scuser sc on t.USER_NAME=SC.USER_NAME " +
				"left join B2CAPP_LM_REQ T2 on t.USER_NAME=T2.USER_NAME and T.LM_CODE = T2.LM_CODE " +
				"left join LANDMARK_MAS lm on LM.code= T.lm_code where 1=1 ");
		if (null != paramMap) {
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
				sql.append(" and T2.STATUS_FLG=:statusFlg");
				param.put("statusFlg", paramMap.get("statusFlg"));
			}
			if (paramMap.containsKey("username") && StringUtils.isNotBlank(paramMap.get("username").toString())) {
				sql.append(" and t.USER_NAME = :username");
				param.put("username", paramMap.get("username"));
			}
		}
		
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
}