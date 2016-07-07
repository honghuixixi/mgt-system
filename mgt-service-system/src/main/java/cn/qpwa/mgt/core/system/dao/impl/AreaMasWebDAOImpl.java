package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.AreaMasWebDAO;
import cn.qpwa.mgt.facade.system.entity.AreaMasWeb;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("areaMasWebDAO")
@SuppressWarnings({"unchecked","deprecation"})
public class AreaMasWebDAOImpl extends HibernateEntityDao<AreaMasWeb> implements AreaMasWebDAO {

	@Override
	public List<AreaMasWeb> findRoots() {
		String hql = "select areaMasWeb from AreaMasWeb areaMasWeb where areaMasWeb.parentId is null and areaMasWeb.statusFlg = 'Y' order by areaMasWeb.areaId";
		return this.find(hql);
	}

	@Override
	public List<AreaMasWeb> findChilds(BigDecimal parent) {
		String hql = "select areaMasWeb from AreaMasWeb areaMasWeb where areaMasWeb.parentId = ? and areaMasWeb.statusFlg = 'Y' order by areaMasWeb.areaId";
		return this.find(hql, new Object[] { parent });
	}
	
	@Override
	public Map<String, Object> findAll(BigDecimal areaId) {
		String sql= "select (select AREA_NAME from AREA_MAS_WEB where GRADE = 1 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) as A1,(select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) as A2,AREA_NAME as A3 from AREA_MAS_WEB a where AREA_ID =?";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, areaId).uniqueResult();
	}
	@Override
	public Map<String, Object> findAllParntIdByAreaId(BigDecimal areaId) {
		String sql= "select (select AREA_ID from AREA_MAS_WEB where GRADE = 1 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) as A1,(select AREA_ID from AREA_MAS_WEB where GRADE = 2 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) as A2,AREA_ID as A3 from AREA_MAS_WEB a where AREA_ID =?";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, areaId).uniqueResult();
	}

	@Override
	public Map<String, Object> findFullName(BigDecimal areaId) {
		String sql= "SELECT (SELECT area_name FROM AREA_MAS_WEB z WHERE z.area_id = (SELECT parent_id FROM AREA_MAS_WEB y WHERE y.AREA_ID = x.parent_id)) || (SELECT area_name FROM AREA_MAS_WEB y WHERE y.AREA_ID = x.parent_id)  ||  area_name as FULLNAME FROM AREA_MAS_WEB x WHERE area_id = ? ";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, areaId).uniqueResult();
	}


	@Override
	public Map<String, Object> findRootsByAreaId(BigDecimal areaId) {
		String sql= "SELECT AREA_ID from (select AREA_ID ,GRADE from AREA_MAS_WEB start with AREA_ID=? connect by prior parent_id=AREA_ID) aa where GRADE='1' ";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, areaId).uniqueResult();
	}


	@Override
	public Map<String, Object> findChildByRootAreaId(BigDecimal rootAreaId) {
		String sql= "SELECT * FROM AREA_MAS_WEB WHERE INSTR(tree_path,',"+rootAreaId+",') > 0 AND grade = 3 AND ROWNUM = 1 and STATUS_FLG='Y' ORDER BY area_id";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public List<AreaMasWeb> findAllParentArea() {
		String hql = "from AreaMasWeb where parentId is null order by areaId";
		return this.find(hql);
	}

	@Override
	public List<Map<String, Object>> findAllAreaId(Map<String, Object> paramMap){
		String sql= "select " +
				"(CASE GRADE WHEN 1 THEN lpad(AREA_ID,4,0) ELSE (select lpad(AREA_ID,4,0) " +
				"from AREA_MAS_WEB " +
				"where GRADE = 1 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) END) || " +
				"(CASE GRADE WHEN 2 THEN lpad(AREA_ID,4,0)ELSE (select lpad(AREA_ID,4,0) " +
				"from AREA_MAS_WEB " +
				"where GRADE = 2 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0) END) || " +
				"(CASE GRADE WHEN 3 THEN lpad(AREA_ID,4,0) ELSE null END) AS AREA_ID, " +
				"AREA_NAME,AREA_ID as AREA_ID_2	 " +
				"from AREA_MAS_WEB a";
		if(paramMap.containsKey("areaId"))
		{
			if(paramMap.containsKey("GRADE")){
				sql += " where (a.TREE_PATH like '%,"+paramMap.get("areaId")+",%' OR AREA_ID = :areaId) and GRADE = :GRADE";
			}else{
				sql += " where a.TREE_PATH like '%,"+paramMap.get("areaId")+",%' OR AREA_ID = :areaId";
			}
			sql=sql+" order by AREA_ID";
			return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		}else{
			sql=sql+" order by AREA_ID";
			SQLQuery query = super.getSession().createSQLQuery(sql);
			return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		}
	}
	
	@Override
	public List<Map<String, Object>> findAllAreaId(String [] areaIdS){
		if(areaIdS == null || areaIdS.length<1){
			return null;
		}
		String sql= "select " +
				"T1.AREA_ID,T1.TREE_PATH from AREA_MAS_WEB T1 LEFT JOIN AREA_MAS_WEB T2 on T1.AREA_ID in(select AREA_ID from AREA_MAS_WEB  where  TREE_PATH like '%,'|| T2.AREA_ID ||',%' and Status_Flg = 'Y'  OR AREA_ID=T2.AREA_ID)" +
				"where T1.GRADE = 3 " +
				"and T2.AREA_ID in (:areaIdS)";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("areaIdS", areaIdS);
		sql=sql+" order by AREA_ID";
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<AreaMasWeb> findAllAreaId(BigDecimal areaId){
		String sql= "select * from AREA_MAS_WEB where TREE_PATH like '%," + areaId + ",%' or area_id = :areaId";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("areaId", areaId);
		return super.createSQLQuery(sql.toString(), paramMap).addEntity(AreaMasWeb.class).list();
	}

	@Override
	public List<Map<String, Object>> findCityAreaId(Map<String, Object> param) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userNo", param.get("userNo"));
		paramMap.put("areaId", ((String)param.get("areaId")).split(","));
		StringBuffer sql = new StringBuffer("select " +
				"(CASE GRADE WHEN 2 THEN T1.AREA_ID ELSE (select AREA_ID from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH, ',' || AREA_ID || ',') > 0) END) AS AREA_ID, " +
				"(CASE GRADE WHEN 2 THEN AREA_NAME ELSE (select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH, ',' || AREA_ID || ',') > 0) END) AS AREA_NAME, " +
				"(CASE WHEN T3.AREA_ID_L2 = T1.AREA_ID THEN 1 ELSE 0 END)as PICK from AREA_MAS_WEB T1 " +
				"LEFT JOIN (select AREA_ID_L2 from SELLER_AREA where USER_NO = :userNo group by AREA_ID_L2 ) T3 on T3.AREA_ID_L2 = T1.AREA_ID " +
				"where AREA_ID in(select AREA_ID from AREA_MAS_WEB  where (PARENT_ID in (:areaId) or AREA_ID in (:areaId)) and GRADE = 2)");
//	"where (T1.PARENT_ID in (:areaId) or T1.AREA_ID in (:areaId)) and GRADE = 2");
//	"where (T1.PARENT_ID in (:areaId) or T1.AREA_ID in (:areaId)) and GRADE = 2");
//						"where (T1.TREE_PATH like '%,"+param.get("areaId")+",%' or T1.AREA_ID = "+param.get("areaId")+") and GRADE = 2");
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
//		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> findWLCityAreaId(Map<String, Object> param) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userNo", param.get("userNo"));
		paramMap.put("areaId", ((String)param.get("areaId")).split(","));
		StringBuffer sql = new StringBuffer("select " +
				"(CASE GRADE WHEN 2 THEN T1.AREA_ID ELSE (select AREA_ID from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH, ',' || AREA_ID || ',') > 0) END) AS AREA_ID, " +
				"(CASE GRADE WHEN 2 THEN AREA_NAME ELSE (select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH, ',' || AREA_ID || ',') > 0) END) AS AREA_NAME, " +
				"(CASE WHEN T3.AREA_ID_L2 = T1.AREA_ID THEN 1 ELSE 0 END)as PICK from AREA_MAS_WEB T1 " +
				"LEFT JOIN (select AREA_ID_L2 from WL_SERVICE_AREA where USER_NO = :userNo group by AREA_ID_L2 ) T3 on T3.AREA_ID_L2 = T1.AREA_ID " +
				"where AREA_ID in(select AREA_ID from AREA_MAS_WEB  where (PARENT_ID in (:areaId) or AREA_ID in (:areaId)) and GRADE = 2)");
//				"where (T1.TREE_PATH like '%,"+param.get("areaId")+",%' or T1.AREA_ID = "+param.get("areaId")+") and GRADE = 2");
//		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
//		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> findDistAreaId(Map<String, Object> param) {
		StringBuffer sql = new StringBuffer("select " +
				"T1.AREA_ID, T1.AREA_NAME, " +
				"(CASE GRADE WHEN 2 THEN T1.AREA_ID ELSE (select AREA_ID from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH,',' || AREA_ID || ',') > 0) END) AS AREA_ID2, " +
				"(CASE GRADE WHEN 2 THEN AREA_NAME ELSE (select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH,',' || AREA_ID || ',') > 0) END) AS AREA_NAME2, " +
//				"(select 1 from STK_AREA T3 where t3.AREA_ID = T1.AREA_ID group by AREA_ID) as CP_TYPE, " +
//				"(SELECT CASE WHEN count(STK_C) > 0 THEN 1 ELSE 0 END FROM STK_AREA SA WHERE SA.area_id = T1.AREA_ID OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = T1.AREA_ID)) as CP_TYPE, " +
				" NVL((select DS_C from DS_AREA T3 where t3.AREA_ID = T1.AREA_ID group by AREA_ID, DS_C), 0) as CP_TYPE, " +
				"(CASE WHEN T3.AREA_ID = T1.AREA_ID THEN 1 ELSE 0 END)as PICK," +
//				"(CASE WHEN T3.SELF_WL_FLG = 'Y' THEN 1 ELSE 0 END)as SELF_WL_FLG, " +
				"(CASE WHEN T3.SELF_WL_FLG = 'Y' THEN 1 ELSE 0 END)as SELF_WL_FLG " +
//				"(CASE WHEN T4.AREA_ID is null THEN 1 ELSE 0 END)as DS_FLAG " +
				"from " +
				"AREA_MAS_WEB T1 " +
				"LEFT JOIN SELLER_AREA T3 on T3.AREA_ID = T1.AREA_ID AND USER_NO = "+param.get("userNo") +
//				" LEFT JOIN DS_AREA T4 on T4.AREA_ID = T1.AREA_ID " +
				" where " +
//				"(T1.TREE_PATH like '%,"+param.get("areaId")+",%' or T1.AREA_ID = "+param.get("areaId")+")and GRADE = 3 " +
//				"order by AREA_ID2";
				"(T1.PARENT_ID in("+param.get("areaId")+") or T1.AREA_ID in("+param.get("areaId")+")) and GRADE = 3 ");
		if(param.containsKey("pick"))
		{
			sql.append(" and (CASE WHEN T3.AREA_ID = T1.AREA_ID THEN 1 ELSE 0 END) = " + param.get("pick"));
		}
		if(param.containsKey("cp_type"))
		{
			sql.append(" and (SELECT CASE WHEN count(STK_C) > 0 THEN 1 ELSE 0 END FROM STK_AREA SA WHERE SA.area_id = T1.AREA_ID OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = T1.AREA_ID)) = " + param.get("cp_type"));
		}
		sql.append(" order by AREA_ID2,T1.AREA_ID");
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> findWLDistAreaId(Map<String, Object> param) {
		StringBuffer sql = new StringBuffer("select " +
				"T1.AREA_ID, T1.AREA_NAME, " +
				"(CASE GRADE WHEN 2 THEN T1.AREA_ID ELSE (select AREA_ID from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH,',' || AREA_ID || ',') > 0) END) AS AREA_ID2, " +
				"(CASE GRADE WHEN 2 THEN AREA_NAME ELSE (select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(T1.TREE_PATH,',' || AREA_ID || ',') > 0) END) AS AREA_NAME2, " +
				"NVL((select DS_C from DS_AREA T3 where t3.AREA_ID = T1.AREA_ID group by AREA_ID, DS_C), 0) as CP_TYPE, " +
				"(CASE WHEN T3.AREA_ID = T1.AREA_ID THEN 1 ELSE 0 END)as PICK " +
				"from " +
				"AREA_MAS_WEB T1 " +
				"LEFT JOIN WL_SERVICE_AREA T3 on T3.AREA_ID = T1.AREA_ID AND USER_NO = "+param.get("userNo") +
				" where " +
//				"(T1.TREE_PATH like '%,"+param.get("areaId")+",%' or T1.AREA_ID = "+param.get("areaId")+")and GRADE = 3";
				"(T1.PARENT_ID in("+param.get("areaId")+") or T1.AREA_ID in("+param.get("areaId")+")) and GRADE = 3");
		if(param.containsKey("pick"))
		{
			sql.append(" and (CASE WHEN T3.AREA_ID = T1.AREA_ID THEN 1 ELSE 0 END) = " + param.get("pick"));
		}
		if(param.containsKey("cp_type"))
		{
			sql.append(" and (select 1 from DS_AREA T3 where t3.AREA_ID = T1.AREA_ID group by AREA_ID) = " + param.get("cp_type"));
		}
		sql.append("order by AREA_ID2,T1.AREA_ID");
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public String findGradeByAreaId(BigDecimal areaId){
		String sql= "select GRADE from AREA_MAS_WEB where area_id =?";
	    SQLQuery query = this.getSession().createSQLQuery(sql);  
	    return query.setBigDecimal(0, areaId).uniqueResult().toString();  
	}
	
	/**
	 * SELECT T1.AREA_ID, T1.GRADE, T1.AREA_NAME FROM AREA_MAS_WEB T1,
	 * (SELECT AREA_ID from (select AREA_ID ,GRADE from AREA_MAS_WEB where STATUS_FLG='Y' start with AREA_NAME = '云南省' connect by prior parent_id=AREA_ID) aa where GRADE='1' ) T2
	 * WHERE INSTR(tree_path,',' || T2.AREA_ID || ',') > 0 AND grade = 3 AND ROWNUM = 1 and STATUS_FLG='Y' --ORDER BY area_id
	 */
	@Override
	public Map<String, Object> findChildByRootAreaId(String areaName, BigDecimal grade) {
		
		String sql= "SELECT T1.AREA_ID, T1.GRADE, T1.AREA_NAME " +
				"FROM " +
				"AREA_MAS_WEB T1, " +
				"(SELECT AREA_ID from (select AREA_ID ,GRADE from AREA_MAS_WEB where STATUS_FLG='Y' start with AREA_NAME = ? connect by prior parent_id=AREA_ID) aa where GRADE=1) T2 " +
				"WHERE (INSTR(tree_path,',' || T2.AREA_ID || ',') > 0  or T1.AREA_ID = T2.AREA_ID) AND grade = ? AND ROWNUM = 1 and STATUS_FLG='Y'";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, areaName).setBigDecimal(1, grade).uniqueResult();
	}
	
	@Override
	public List<Map<String, Object>> findBelongAreaId(BigDecimal areaId){
		String sql= "SELECT * FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||"+areaId+"||',') > 0 OR area_id = :areaId ";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("areaId", areaId);
		return super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
}
