package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtSettingDAO;
import cn.qpwa.mgt.facade.system.entity.MgtSetting;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统参数访问层接口实现类，提供CRUD操作
 * @author TheDragonLord
 *
 */
@Repository("mgtSettingDAO")
@SuppressWarnings("all")
public class MgtSettingDAOImpl extends HibernateEntityDao<MgtSetting> implements MgtSettingDAO{

	@Override
	public Page mgtSettingList(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {  //"menuName":"APP","userFlg":"Y"}
		Map<String,Object> param = new HashMap<String,Object>();
		StringBuilder sql = new StringBuilder("SELECT * FROM MGT_SETTING m WHERE 1=1");
		if(paramMap != null){
			if(paramMap.containsKey("menuId") && StringUtils.isNotBlank(paramMap.get("menuId").toString())){
				sql.append("  AND m.MENU_ID = :menuId");
				param.put("menuId",paramMap.get("menuId"));
			}
			//
			if(paramMap.containsKey("menuName") && StringUtils.isNotBlank(paramMap.get("menuName").toString())){
				sql.append(" AND MENU_NAME = :menuName");
				param.put("menuName","%" + paramMap.get("menuName") + "%");

			}
			if(paramMap.containsKey("itemNo") && StringUtils.isNotBlank(paramMap.get("itemNo").toString())){
				sql.append("  AND m.ITEM_NO = :itemNo");
				param.put("itemNo",paramMap.get("itemNo"));
			}
			if(paramMap.containsKey("description") && StringUtils.isNotBlank(paramMap.get("description").toString())){
				sql.append("  AND m.DESCRIPTION = :description");
				param.put("description","%" +paramMap.get("description")+"%" );
			}
			if(paramMap.containsKey("defFlg") && StringUtils.isNotBlank(paramMap.get("defFlg").toString())){
				sql.append("  AND m.DEF_FLG = :defFlg");
				param.put("defFlg",paramMap.get("defFlg"));
			}
			if(paramMap.containsKey("defValue") && StringUtils.isNotBlank(paramMap.get("defValue").toString())){
				sql.append("  AND m.DEF_VALUE = :defValue");
				param.put("defValue",paramMap.get("defValue"));
			}
			//
			if(paramMap.containsKey("userFlg") && StringUtils.isNotBlank(paramMap.get("userFlg").toString())){
				sql.append("  AND USER_FLG = :userFlg");
				param.put("userFlg",paramMap.get("userFlg"));
			}
			if(paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())){
				orderby = new LinkedHashMap<String,String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public BigDecimal findMaxId() {
		String sql = "SELECT MAX(ITEM_NO) FROM MGT_SETTING";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (BigDecimal) query.uniqueResult();
	}
	
	@Override
	public BigDecimal findMaxSort() {
		String sql = "SELECT MAX(SORT_NO) FROM MGT_SETTING";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (BigDecimal) query.uniqueResult();
	}

	@Override
	public List<Map<String,Object>> querySettingListByItemNo(String itemNo) {
		StringBuffer sql = new StringBuffer("select * from MGT_SETTING t where 1=1 ");
		if(!StringUtils.isEmpty(itemNo)){
			sql.append(" and t.item_no = :itemNo");
		}
		Query query = super.getSession().createSQLQuery(sql.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		if(!StringUtils.isEmpty(itemNo)){
			query.setParameter("itemNo", itemNo);
		}
		return query.list();
	}

	/**
	 * 获取制定参数是否有效 
	 * @param code
	 * 	编码
	 * @return Y or N
	 * b2b_misc_util.get_mgt_setting(p_user_name IN VARCHAR2,p_item_no IN NUMBER,p_def_flg OUT VARCHAR2,p_def_value OUT VARCHAR2)
	 */
	@Override
	public Map<String,Object> calcUsersetting(String strUserName, BigDecimal itemNo)
	{
		Map<String,Object> mReturn = new HashMap<String,Object>();
		String strRtuen  = "N";
		try{
			Connection conn = super.getSession().connection();
			CallableStatement call = conn.prepareCall("{call B2B_MISC_UTIL.get_mgt_setting(?,?,?,?)}");
			call.setString(1, strUserName);
			call.setBigDecimal(2, itemNo);
			call.registerOutParameter(3, oracle.jdbc.OracleTypes.VARCHAR);
			call.registerOutParameter(4, oracle.jdbc.OracleTypes.VARCHAR);
			call.execute();
//			strRtuen = call.getString(3);
/*			if(strRtuen.equals("Y"))
			{
				strRtuen = call.getString(4);
				if(StringUtils.isBlank(strRtuen))
				{
					strRtuen = "Y";
				}
			}*/
			mReturn.put("DEF_FLG", call.getString(3));
			mReturn.put("DEF_VALUE", call.getString(4));
//			System.out.println("-----------------------------------------默认设置项 ="+call.getString(3));
//			System.out.println("-----------------------------------------参数项的值 ="+call.getString(4));
			return mReturn;
		}catch (Exception e){
			System.out.println("------------------calcUsersetting--Exception----------------"+e);
		}
		return mReturn;
	}	
	
}
