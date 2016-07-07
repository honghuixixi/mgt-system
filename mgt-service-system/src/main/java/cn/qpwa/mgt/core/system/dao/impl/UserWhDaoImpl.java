package cn.qpwa.mgt.core.system.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.UserWhDAO;
import cn.qpwa.mgt.facade.system.entity.UserWh;

@Repository("userWhDaoImpl")
@SuppressWarnings("unchecked")
public class UserWhDaoImpl extends HibernateEntityDao<UserWh> implements
		UserWhDAO {
	@Override
	public List<Map<String, Object>> getUserWhList(Map<String, Object> param) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		StringBuffer sql = new StringBuffer("SELECT UW.USER_NAME, UW.WH_C, UW.CREATE_USER_NAME,WM.NAME, WM.LONGITUDE, WM.LATITUDE FROM USER_WH UW LEFT JOIN WH_MAS WM ON UW.WH_C =WM.WH_C WHERE 1=1");
		if(param.containsKey("userName")){
			sql.append(" AND USER_NAME=:userName");
			paramMap.put("userName", param.get("userName"));
		}
		if(param.containsKey("fbpLbpFlg")){
			sql.append(" AND WM.FBP_LBP_FLG =:fbpLbpFlg");
			paramMap.put("fbpLbpFlg", param.get("fbpLbpFlg"));
		}
		if(param.containsKey("activeFlg")){
			sql.append(" AND WM.ACTIVE_FLG =:activeFlg");
			paramMap.put("activeFlg", param.get("activeFlg"));
		}
		Query query = super.createSQLQuery(sql.toString(), paramMap);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> getMerchentUserWhList(Map<String, Object> param){
		Map<String, Object> paramMap = new HashMap<String, Object>();
		StringBuffer sql = new StringBuffer("SELECT * FROM  WH_MAS WM WHERE WM.ACTIVE_FLG='Y' ");
		if(param.containsKey("merchantUserName")){
			sql.append(" AND WM.ACC_CODE=:merchantUserName");
			paramMap.put("merchantUserName", param.get("merchantUserName"));
		}
		Query query = super.createSQLQuery(sql.toString(), paramMap);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> findUserWhByUsername(String username){
		Query query = getSession().createSQLQuery("SELECT wh_c from USER_WH WHERE user_name=?").setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, username);
		return query.list();
	}
	
	@Override
	public void deleteUserWhByUsername(String username){
		Query query = super.getSession().createQuery("delete from UserWh uw where uw.id.userName =?").setString(0, username);
		query.executeUpdate();
	}
}
