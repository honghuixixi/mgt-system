package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;

import cn.qpwa.mgt.core.system.dao.LandmarkMasDAO;
import cn.qpwa.mgt.facade.system.entity.LandmarkMas;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings({ "unchecked"})
@Repository("landmarkMasDAO")
public class LandmarkMasDAOImpl extends HibernateEntityDao<LandmarkMas> implements LandmarkMasDAO {

	@Override
	public List<Map<String, Object>> findLandmarkMasList() {
		Query query = getSession().createSQLQuery("SELECT * FROM LANDMARK_MAS")
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}

	@Override
	public List<Map<String, Object>> queryLandmarkByAreaId(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("select T.* from LANDMARK_MAS T where T.STATUS_FLG = :statusFlg ");
		if (paramMap.containsKey("areaId") && null!=paramMap.get("areaId")) {
			sql.append(" and T.AREA_ID =:areaId");
		}
		if(paramMap.containsKey("lmCodeList")){
			
			List<String> lmCodeList = (List<String>) paramMap.get("lmCodeList");
			if(lmCodeList.size()>0)
			{
				sql.append(" and  T.CODE in ( ");
				int length = lmCodeList.size();
				for(int i=0;i<length;i++)
				{
					sql.append(" '");
					sql.append(lmCodeList.get(i));
					sql.append("'");
					if(i<length-1)
					{
						sql.append(" , ");
					}
				}
				sql.append(" ) ");
		 }
	   }
		if(paramMap.containsKey("notLmCodeList")){
			List<String> notLmCodeList = (List<String>) paramMap.get("notLmCodeList");
			if(notLmCodeList.size()>0)
			{
				sql.append(" and  T.CODE not in ( ");
				int length = notLmCodeList.size();
				for(int i=0;i<length;i++)
				{
					sql.append(" '");
					sql.append(notLmCodeList.get(i));
					sql.append("'");
					if(i<length-1)
					{
						sql.append(" , ");
					}
				}
				sql.append(" ) ");
			}
		}
		Query query =  super.getSession().createSQLQuery(sql.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("statusFlg", paramMap.get("statusFlg"));
		if (paramMap.containsKey("areaId") && null!=paramMap.get("areaId")) {
			query.setParameter("areaId", paramMap.get("areaId"));
		}
		return query.list();
	}
	
	/**  通过经纬度获得地标主数据
	  * @author lly
	  * @date2015-8-31 
	  * @parameter 
	  * @return  
	*/
	public Page<Map<String, Object>> findLmMas(Map<String, Object> paramMap){
		JSONObject para=new JSONObject();
		StringBuffer sql = new StringBuffer("select " +
				"(select AREA_NAME from AREA_MAS_WEB where AREA_ID_L1 = AREA_ID) as AREA_NAME1," +
				"(select AREA_NAME from AREA_MAS_WEB where AREA_ID_L2 = AREA_ID) as AREA_NAME2," +
				"AREA_NAME,lm.code,lm.Name as lm_name,lm.user_name,lm.LATITUDE,lm.LONGITUDE," +
				"lm.AREA_ID, AREA_ID_L2, lm.AREA_ID_L1,s.CRM_ADDRESS1,(AMW.GRADE) as GRADE " );

				if(paramMap.containsKey("longitude") && paramMap.get("longitude") != null) {
					sql.append(",GET_DISTANCE_BY_LL(lm.LONGITUDE,lm.LATITUDE,:longitude,:latitude) AS DISTANCE ");
					para.put("longitude",paramMap.get("longitude"));
					para.put("latitude",paramMap.get("latitude"));
				}
				
				sql.append(" from LANDMARK_MAS lm " +
						"LEFT JOIN AREA_MAS_WEB A ON LM.AREA_ID = A.AREA_ID " +
						"LEFT JOIN AREA_MAS_WEB T2 ON LM.AREA_ID_L1 = T2.AREA_ID " +
						"LEFT JOIN AREA_MAS_WEB amw ON LM.AREA_ID = amw.AREA_ID " +
						"LEFT JOIN SCUSER s ON lm.USER_NAME = s.USER_NAME " +
						"where 1=1 and lm.STATUS_FLG='Y' ");
				
				if (paramMap.containsKey("areaid") && paramMap.get("areaid") != null) {
					sql.append(" AND lm.AREA_ID_L2 =:areaid");
					para.put("areaid",(String) paramMap.get("areaid"));
				}
				if (paramMap.containsKey("areaid2") && paramMap.get("areaid2") != null) {
					sql.append(" AND lm.AREA_ID_L1 =:areaid2");
					para.put("areaid2",(String) paramMap.get("areaid2"));
				}
				if (paramMap.containsKey("name") && paramMap.get("name") != null) {
					sql.append(" AND lm.Name like :name ");
					para.put("name","%"+(String) paramMap.get("name")+"%");
				}
				if (paramMap.containsKey("range") && paramMap.get("range") != null) {
					sql.append(" AND GET_DISTANCE_BY_LL(lm.LONGITUDE,lm.LATITUDE,:longitude,:latitude) <= :range");
					para.put("range",paramMap.get("range"));
				}
				
				LinkedHashMap<String, String> orderBy = new LinkedHashMap<String, String>();
				
				if(paramMap.containsKey("longitude") && paramMap.get("longitude") != null) {
					orderBy.put("GET_DISTANCE_BY_LL(lm.LONGITUDE,lm.LATITUDE,:longitude,:latitude) ","asc");
				}
				return super.sqlqueryForpage(sql.toString(), para, orderBy);
			}

	@Override
	public Page findLandMarkMasList(Map<String, Object> param, LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("select t.UUID,t.code,t.name,t.description,t.AREA_ID,(select s.NAME from scuser s where s.USER_NAME=t.USER_NAME) as USER_NAME,(SELECT s.NAME FROM SCUSER s WHERE s.USER_NO=t.PIC_NO) as PIC_NAME,(SELECT(SELECT x.area_name FROM AREA_MAS_WEB x WHERE x.area_id= (SELECT parent_id FROM AREA_MAS_WEB y WHERE y.area_id=z.parent_id))||(SELECT y.area_name FROM AREA_MAS_WEB y WHERE y.area_id=z.parent_id )||z.area_name FROM AREA_MAS_WEB z WHERE z.area_id=t.AREA_ID) AS AREA_NAME,t.area_id_l1,t.area_id_l2,t.pic_no,t.status_flg,t.create_date from LANDMARK_MAS t where 1=1 ");
		Map<String, Object> params = new HashMap<String, Object>(); 
		orderby = new LinkedHashMap<String, String>();
		if (!param.containsKey("super")) {
//			if(StringUtils.isNotBlank(param.get("areaIds").toString())){
//				sql.append(" and T.AREA_ID in("+param.get("areaIds")+")");
//			}else{
			sql.append(" and T.AREA_ID in(SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR   area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:userName))");
			params.put("userName", param.get("userName"));
//			}
		}
		if (param.containsKey("areaId") && StringUtils.isNotEmpty(param.get("areaId").toString())) {
			sql.append(" AND t.AREA_ID IN (SELECT amw.AREA_ID FROM AREA_MAS_WEB amw WHERE INSTR(amw.TREE_PATH,','||:areaId||',') > 0 or amw.AREA_ID=:areaId) ");
			params.put("areaId", param.get("areaId"));
		}
		if (param.containsKey("statusFlg") && StringUtils.isNotEmpty(param.get("statusFlg").toString())) {
			sql.append(" AND t.STATUS_FLG=:statusFlg ");
			params.put("statusFlg", param.get("statusFlg"));
		}
		if (param.containsKey("key") && StringUtils.isNotEmpty(param.get("key").toString())) {
			sql.append(" AND (t.NAME like'%"+param.get("key")+"%' or t.CODE ='"+param.get("key")+"')");
		}
		if (StringUtils.isNotBlank((String)param.get("orderby"))) {
			orderby.put(param.get("orderby").toString(), param.get("sord").toString());
		}else{
			orderby.put("t.CREATE_DATE", "DESC");
		}
		return super.sqlqueryForpage(sql.toString(), params, orderby);
	}
	
	@Override
	public void delete(String id) {
		if (id != null) {
			Query query = super.getSession().createQuery("delete from LandmarkMas s where s.uuid in (:ids)");
			query.setParameter("ids", id);
			query.executeUpdate();
		}
	}
	
	@Override
	public List<Map<String, Object>> findShopByAreaId(Map<String, Object> param) {
		// PUBLIC_FLG='Y'外部用户（供应商、店铺） ;COM_FLG='Y'公司;SALESMEN_FLG='Y'客户;GUEST_FLG='Y'已审核;BLOCK_FLG = 'N'未锁定;
		Map<String, Object> params = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select T.USER_NO,T.USER_NAME,T.NAME,T.CRM_ADDRESS1,T.AREA_ID from SCUSER T where T.PUBLIC_FLG='Y' AND T.COM_FLG='Y' AND T.SALESMEN_FLG='Y' AND T.GUEST_FLG='Y' AND T.BLOCK_FLG = 'N' ");
		if (param.containsKey("areaIds") && !param.containsKey("super")) {
			if(StringUtils.isNotBlank(param.get("areaIds").toString())){
				sql.append(" and T.AREA_ID in("+param.get("areaIds")+")");
			}else{
				sql.append(" and T.AREA_ID in('')");
			}
		}
		 return super.createSQLQuery(sql.toString(), params).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	/**  
	 * 通过经纬度获得地标内的店铺列表
	 * @author lly
	 * @date2015-8-31 
	 * @parameter 
	 * @return  
	 */
	public Page<Map<String, Object>> findLmShop(Map<String, Object> paramMap){

		JSONObject para=new JSONObject();
		StringBuffer sql = new StringBuffer("select " +
				"LM_CODE,LM.USER_NAME,(LM.NAME)as LM_NAME,BLM.NAME, BLM.APPROVE_DESC, LONGITUDE,LATITUDE,AREA_ID,AREA_ID_L2,AREA_ID_L1" );

		if(paramMap.containsKey("longitude") && paramMap.get("longitude") != null) {
			sql.append(",GET_DISTANCE_BY_LL(lm.LONGITUDE,lm.LATITUDE,:longitude,:latitude) AS DISTANCE");
			para.put("longitude",paramMap.get("longitude"));
			para.put("latitude",paramMap.get("latitude"));
		}
		
		sql.append(" from LM_SHOP LS " +
				"LEFT JOIN LANDMARK_MAS LM ON LM.CODE = LS.LM_CODE " +
				"LEFT JOIN B2CAPP_LM_REQ BLM ON BLM.LM_CODE = LS.LM_CODE " +
				"where LS.STATUS_FLG = 'Y' ");
		
		if (paramMap.containsKey("lmcode") && paramMap.get("lmcode") != null) {
			sql.append(" AND LM_CODE = :lmcode ");
			para.put("lmcode",paramMap.get("lmcode"));
		}
		if (paramMap.containsKey("lmname") && paramMap.get("lmname") != null) {
			sql.append(" AND lm.Name like :name ");
			para.put("name","%"+(String) paramMap.get("lmname")+"%");
		}
		if (paramMap.containsKey("range") && paramMap.get("range") != null) {
			sql.append(" AND GET_DISTANCE_BY_LL(lm.LONGITUDE,lm.LATITUDE,:longitude,:latitude) <= :range");
			para.put("range",paramMap.get("range"));
		}
		
		LinkedHashMap<String, String> orderBy = new LinkedHashMap<String, String>();
		
		if(paramMap.containsKey("longitude") && paramMap.get("longitude") != null) {
			orderBy.put("GET_DISTANCE_BY_LL(lm.LONGITUDE,lm.LATITUDE,:longitude,:latitude) ","asc");
		}
		return super.sqlqueryForpage(sql.toString(), para, orderBy);
	}

	@Override
	public List<Map<String, Object>> queryLandmarkByAreaIds(Map<String, Object> paramMap) {
		String tableName = "";
		if("Y".equals(paramMap.get("kitFlg"))){
			tableName = "_KIT";
		}
		StringBuilder sql = new StringBuilder("select T.*,P.PROM_CODE from LANDMARK_MAS T "
				+ "LEFT JOIN (select * from B2C"+tableName+"_PROM_LM where MAS_PK_NO = ?)  B ON T.CODE = B.LM_CODE LEFT JOIN B2C"+tableName+"_PROM_MAS P ON B.MAS_PK_NO = P.PK_NO where T.STATUS_FLG = 'Y' and T.AREA_ID IN (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR   area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=?)) order by t.CODE");
		Query query =  super.getSession().createSQLQuery(sql.toString()).setBigDecimal(0, (BigDecimal)paramMap.get("pkNo"))
				.setString(1,  paramMap.get("userName").toString())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}
}
