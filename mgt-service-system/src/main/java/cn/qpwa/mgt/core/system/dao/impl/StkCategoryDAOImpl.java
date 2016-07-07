package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.mgt.core.system.dao.StkCategoryDAO;
import cn.qpwa.mgt.facade.system.entity.StkCategory;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

/**
 * 商品分类数据访问层实现类
 * @param
 */
@Repository("stkCategotyDAO")
@SuppressWarnings({"deprecation" ,"unchecked","rawtypes"})
public class StkCategoryDAOImpl extends HibernateEntityDao<StkCategory> implements StkCategoryDAO {
	
	@Override
	public List getStkCategoryPID(BigDecimal params){
		String sql = "select t.cat_id,t.sort_no,t.grade,t.cat_name,t.tree_path,t.parent_id from STK_CATEGORY t where t.PARENT_ID = ? ";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return  query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, params).list();
	}
	
	@Override
	public List findStkCategoryPid(BigDecimal params) {
		String sql = "select CAT_ID,CAT_NAME,ORG_NO,nvl(URL_ADDR ,'http://image1.qpwa.cn/upload/adimg/c1.jpg') URL_ADDR from STK_CATEGORY where PARENT_ID = ?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, params).list();
	}
	
	@Override
	public List findStkCategoryGrade(BigDecimal params) {
		String sql = "select CAT_ID,CAT_NAME,ORG_NO,PARENT_ID,nvl(URL_ADDR ,'http://image1.qpwa.cn/upload/adimg/c1.jpg') URL_ADDR from STK_CATEGORY where GRADE = ? order by SORT_NO";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, params).list();
	}
		
	@Override
	public BigDecimal findGrade(BigDecimal params) {		
		String sql = "select GRADE from STK_CATEGORY sc where CAT_ID = ?";
		Query query = this.getSession().createSQLQuery(sql).setBigDecimal(0, params);    
	    //2015-12-15，lj更新，修复如果o为空时，toString问题报错
		Object o = query.uniqueResult();
	    if(o==null){
	    	return null;
	    }else{
	    	return new BigDecimal(String.valueOf(o));
	    }
	}
	
	@Override
	public List findStkCategoryCatId(BigDecimal catId) {		
		String sql = "select CAT_ID,CAT_NAME,ORG_NO,PARENT_ID from STK_CATEGORY where CAT_ID = ?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, catId).list();
	}
	
	@Override
	public List<Map<String, Object>> findStkCategoryCatId(Map param) {		
		String sql = "select sc.CAT_ID from STK_CATEGORY sc left join STK_MAS sm on sm.CAT_ID = sc.CAT_ID " +
				//增加上架标志EP_FLG = 'Y' 判断
				"where EP_FLG = 'Y' and PARENT_ID = :parentId and BRAND_C = :brandC  and sc.org_no = :orgNo group by sc.CAT_ID";
		Query query = super.createSQLQuery(sql.toString(), param);
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List findStkCategoryParent(BigDecimal params) {		
		String sql = "select CAT_ID,CAT_NAME,ORG_NO from STK_CATEGORY sc where ( CAT_ID in (select PARENT_ID from STK_CATEGORY where CAT_ID = ?))";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, params).list();
	}
	
	@Override
	public List findStkCategoryPidParent(BigDecimal params) {		
		String sql = "select CAT_ID,CAT_NAME,ORG_NO from STK_CATEGORY sc where ( PARENT_ID in (select PARENT_ID from STK_CATEGORY where CAT_ID = ?))";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, params).list();
	}

	@Override
	public List<StkCategory> findRelativeStkCategorysByCatId(BigDecimal catId,BigDecimal orgNo) {
		String reSql = "select * from STK_CATEGORY where PARENT_ID = (select t.PARENT_ID from STK_CATEGORY t where t.CAT_ID=?) and ORG_NO=?";
		return this.getSession().createSQLQuery(reSql).addEntity(StkCategory.class).setBigDecimal(0, catId).setBigDecimal(1, orgNo).list();
	}

	@Override
	public List<StkCategory> findParents(StkCategory stkCategory, BigDecimal orgNo) {
		//2015-12-11 lj 修改 增加根据级别排序
		String psql = "select * from STK_CATEGORY t where ORG_NO=? and t.CAT_ID in (:ids) order by t.grade ";
		return this.createSQLQuery(psql).addEntity(StkCategory.class).setParameterList("ids", stkCategory.getTreePaths()).setBigDecimal(0, orgNo).list();
	}

	@Override
	public Page findProSearch(String CONDITION,String ORDER_BY,BigDecimal areaId) {
		int offSet = SystemContext.getOffset();
		int pagesize = SystemContext.getPagesize();
		Connection conn = super.getSession().connection();
		List<Map<String, String>> product = null;
		int totalCount = 0;
		int areaid = 0;
		if(areaId != null){
			areaid = areaId.intValue();
		}
		try {
			CallableStatement call = conn.prepareCall("{Call B2B_SITE_UTIL.get_cat_brand_stk_info(?,?,?,?,?,?,?)}");
			call.setString(1,CONDITION);
			call.setString(2,ORDER_BY );
			call.setInt(3,pagesize);
			call.setInt(4,offSet);
			call.setInt(5, areaid);
			call.registerOutParameter(6, oracle.jdbc.OracleTypes.DECIMAL);
			call.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
			call.execute();
			totalCount = Integer.parseInt(call.getObject(6).toString());
			ResultSet rsCursor = (ResultSet) call.getObject(7);
			product = new ArrayList<Map<String, String>>();
		    while (rsCursor.next())
		    {
		    	Map<String, String> map = new HashMap<String, String>();
		        for (int i = 1; i <= rsCursor.getMetaData().getColumnCount(); i++)
		        {
		            map.put(rsCursor.getMetaData().getColumnName(i), rsCursor.getString(rsCursor.getMetaData().getColumnName(i)));
		        }
		        product.add(map); 
		    }
		    
		    Page page = new Page((offSet - offSet % pagesize) / pagesize + 1,
					pagesize);
			page.setTotalCount(totalCount);
			page.setItems(product);
			return page;
		    } catch (SQLException e) {
				e.printStackTrace();
			}
		    return null;
	    }
	

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select t.*,t1.CAT_NAME PARENT_NAME from STK_CATEGORY t  left join STK_CATEGORY t1 on t.parent_id=t1.cat_id where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and t.cat_name like :name");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
		}
		orderby = new LinkedHashMap<String, String>();
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				if (paramMap.get("orderby").toString().equals("PARENT_NAME")) {
					orderby.put("t1.CAT_NAME", paramMap.get("sord").toString());
				} else {
					orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
				}
		}else{
			
			orderby.put("t.GRADE", "ASC");
			
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createSQLQuery("delete from STK_CATEGORY s where s.CAT_ID in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}
	@Override
	public List findByGradeList(Map<String, Object> paramMap) {
		String sql = "select cat_id id,parent_id PID,cat_name name from STK_CATEGORY t where grade in (:grades) and org_no =:orgNO";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameterList("grades", (Integer[]) paramMap.get("grades"));
		query.setParameter("orgNO", Integer.parseInt(paramMap.get("orgNo").toString()));
		return query.list();
	}

	@Override
	public int countMaxSortNo() {

		String sql = "select nvl(max(SORT_NO),0) from STK_CATEGORY t where SORT_NO is not null";
		Query query = super.getSession().createSQLQuery(sql);
		return Integer.parseInt(query.uniqueResult().toString());
	}

	@Override
	public int countByParentIds(String[] ids, String orgNo) {
		Query query = getSession().createSQLQuery("select count(*) from STK_CATEGORY where parent_id in (:ids) and org_no=:orgNo ");
		query.setParameterList("ids", ids);
		query.setParameter("orgNo", orgNo);
		return Integer.parseInt(query.uniqueResult().toString());
	}

	@Override
	public List findByCategoryList(Map<String, Object> params) {
		Query query = getSession().createSQLQuery("select * from STK_CATEGORY"
				+ " where cat_id in ("
				+ "select parent_id from "
				+ "STK_CATEGORY t where cat_id in (:catIds) and grade = 3) "
				+ "union select * from  "
				+ "STK_CATEGORY where  cat_id in (:catIds) and grade in(2,3)").setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameterList("catIds", (Set) params.get("catIds"));
		return query.list();
	}
	
	public List findByTreepath(String catId){
		
		Query query = getSession().createSQLQuery("SELECT CAT_ID FROM stk_category WHERE INSTR(TREE_PATH,','||:catId||',') > 0 or CAT_ID=:catId");
		query.setParameter("catId", catId);
		return query.list();
	}

	@Override
	public List<StkCategory> findChilds(BigDecimal params){
		
		String hql = "select t from StkCategory t where t.parentId=? order by t.catId ";
		return this.find(hql, new Object[] { params });
	}
	@Override
	public List<StkCategory> findRoots() {
		String hql = "select t from StkCategory t where t.parentId=0 order by t.catId";
		return this.find(hql);
	}

	@Override
	public List findCateByParent(String catId ) {
		SQLQuery query = getSession().createSQLQuery("SELECT t.cat_id,t.sort_no,t.grade,t.cat_name,t.tree_path,t.parent_id   FROM stk_category t  WHERE INSTR(t.TREE_PATH,','||:catId||',') > 0");
		query.setParameter("catId", catId);
		return  query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}


	@Override
	public List<Map<String,Object>> getStkCategoryPidParent(Map<String, Object> param) {
		StringBuilder sql = new StringBuilder("select DISTINCT SC.CAT_ID,SC.CAT_NAME,SC.ORG_NO,");
		sql.append("nvl(sc.URL_ADDR ,'http://image1.qpwa.cn/upload/adimg/c1.jpg') URL_ADDR, nvl(sc.SORT_NO,sc.CAT_ID) SORT_NO ");
		sql.append(" from STK_CATEGORY  sc,");
		sql.append(" (select  ");
		if(param.get("level").toString().equals("1")){
			 sql.append("SM.CAT2_ID ");
		}else if(param.get("level").toString().equals("2")){
			 sql.append("SM.CAT_ID  ");
		}
		sql.append(" as cat_id from  stk_mas sm ");
		sql.append("where SM.EP_FLG = 'Y' "); 
		sql.append(" and sm.stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = :areaId");
		sql.append(" OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = :areaId)) ");
		if(param.get("level").toString().equals("1")){
			sql.append(" and sm.CAT1_ID = ");
		}else if(param.get("level").toString().equals("2")){
			sql.append(" and sm.CAT2_ID = ");
		}
		sql.append(":parentId ");
		if(param.containsKey("brandCS") && StringUtils.isNotBlank(param.get("brandCS").toString())){
			sql.append(" and SM.BRAND_C = :brandCS ");
		}
		sql.append(" ) s  where s.CAT_ID = SC.CAT_ID");
		param.remove("level");
		Query query = super.createSQLQuery(sql.toString(),param);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public List<Map<String,Object>> getStkCategoryGrade(Map<String, Object> param) {
		StringBuilder sql  = new StringBuilder("select DISTINCT sc.CAT_ID,sc.CAT_NAME,sc.ORG_NO,sc.PARENT_ID,sc.URL_ADDR,sc.SORT_NO from STK_CATEGORY sc");
	    sql.append(" ,stk_mas sm where SC.CAT_ID = SM.CAT_ID and SC.GRADE = :grade and SM.EP_FLG = 'Y'");
	    if(param.containsKey("brandCS") && param.get("brandCS")!=null){
			sql.append(" and sm.BRAND_C = :brandCS ");
		}
	    sql.append(" and sm.stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = :areaId");
	    sql.append(" OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = :areaId)) order by sc.SORT_NO");
		Query query = super.createSQLQuery(sql.toString(),param);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}


	@Override
	public List<Map<String,Object>> findRelativeStkCategorysByCatId(
			Map<String, Object> param) {
		String sql = "select DISTINCT SC.CAT_ID,SC.CAT_NAME from (select  CAT_ID,CAT_NAME from STK_CATEGORY where PARENT_ID =("+
						"select t.PARENT_ID from STK_CATEGORY t where t.CAT_ID=:cateId and t.ORG_NO=:orgNo)) sc ,"+
						"stk_mas sm where sc.CAT_ID = SM.CAT_ID and SM.EP_FLG = 'Y' "+
						" and sm.stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = :areaId"+
						" OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = :areaId))";
		Query query = super.createSQLQuery(sql,param);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	
	}

	@Override
	public List findStkCateNew(Map<String, Object> params ,int level) {
		StringBuffer sql = new StringBuffer("SELECT DISTINCT SC.CAT_NAME,SC.CAT_ID,SC.PARENT_ID,SC.GRADE FROM STK_CATEGORY sc,");
		sql.append("(select ");
		//根据级别判断取相应的字段
		if(level==2){
			sql.append(" SM.CAT2_ID ");
		}else{
			sql.append(" SM.CAT_ID ");
		}
		sql.append(" as CAT_ID from  stk_mas sm where SM.EP_FLG = 'Y' ");
		Map<String, Object> paraMap = new HashMap<String, Object>();
		if(params.get("days") != null) {
			sql.append(" and round(to_number(SYSDATE-SM.CREATE_DATE))<:days");
			paraMap.put("days", params.get("days"));
		}
		if(params.get("oldCode") != null) {
			sql.append(" and  sm.old_code=:oldCode");
			paraMap.put("oldCode", params.get("oldCode"));
		}
		if(params.get("brandC") != null) {
			sql.append(" and sm.brand_c in (:brandC) ");
			paraMap.put("brandC", params.get("brandC"));
		}
		if(params.get("areaId") != null) {
			sql.append(" and sm.stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = :areaId");
			sql.append(" OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = :areaId))");
			paraMap.put("areaId", params.get("areaId"));
		}
		sql.append(") s    where s.CAT_ID = SC.CAT_ID  ORDER BY SC.CAT_ID");
		return super.createSQLQuery(sql.toString(), paraMap)
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	

	@Override
	public List<Map<String, Object>> findPromStkCate2(Map<String, Object> params) { 
		String str = "SELECT CAT_NAME,CAT_ID,PARENT_ID,GRADE FROM STK_CATEGORY sc WHERE 1=1 AND GRADE = 2 AND CAT_ID IN " +
					 "(SELECT DISTINCT(parent_id) FROM STK_CATEGORY WHERE cat_id in 	(SELECT  DISTINCT(sm.CAT_ID) " +
					 "FROM WEB_PROM_ITEM1 wpi LEFT JOIN stk_mas sm ON wpi.STK_C = sm.STK_C " +
					 "left JOIN WEB_PROM_MAS wpm ON wpm.PK_NO = wpi.MAS_PK_NO  " +
					 "WHERE sm.EP_FLG = 'Y' and wpi.STATUS_FLG = 'P'  " +
					 "AND TO_DATE(:DateTime,'YYYY-MM-DD HH24:MI:SS') >= wpi.BEGIN_DATE AND " +
					 "TO_DATE(:DateTime,'YYYY-MM-DD HH24:MI:SS') <= wpi.END_DATE";
		StringBuffer sql = new StringBuffer(str);
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("DateTime", DateUtil.getCurrDateTime());
		if (params.get("promPkNo") != null) {
			sql.append(" and wpi.pk_no=:promPkNo ");
			paraMap.put("promPkNo", params.get("promPkNo"));
		}
		if (params.get("masCode") != null) {
			sql.append(" AND wpi.mas_code = :masCode");
			paraMap.put("masCode", params.get("masCode"));
		}
		if (params.get("brandC") != null ) {
			sql.append(" AND sm.brand_c IN  ("+params.get("brandC").toString()+") ");
		}
		if (params.get("oldCode") != null ) {
			sql.append(" AND sm.old_code=:oldCode ");
			paraMap.put("oldCode", params.get("oldCode"));
		}
		if(params.get("areaId") != null) {
			sql.append(" and sm.stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = :areaId");
			sql.append(" OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = :areaId))");
			paraMap.put("areaId", params.get("areaId"));
		}
		sql.append("))");
		
		
		return super.createSQLQuery(sql.toString(), paraMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public List<Map<String, Object>> findPromStkCate3(Map<String, Object> params) { 
		String str = "SELECT 	CAT_NAME,	CAT_ID,	PARENT_ID,	GRADE FROM	STK_CATEGORY sc WHERE	1 = 1 AND GRADE = 3 " +
					"AND CAT_ID IN (	SELECT DISTINCT (sm.CAT_ID) FROM	WEB_PROM_ITEM1 wpi	LEFT JOIN stk_mas sm ON wpi.STK_C = sm.STK_C " +
					"LEFT JOIN WEB_PROM_MAS WPM ON  WPI.MAS_PK_NO = WPM.PK_NO   "+
					"WHERE	sm.EP_FLG = 'Y' and wpi.STATUS_FLG = 'P' AND TO_DATE (:DateTime,'YYYY-MM-DD HH24:MI:SS'	) >= wpi.BEGIN_DATE	 " +
					"AND TO_DATE (:DateTime,'YYYY-MM-DD HH24:MI:SS') <= wpi.END_DATE ";
		StringBuffer sql = new StringBuffer(str);
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("DateTime", DateUtil.getCurrDateTime());
		if (params.get("promPkNo") != null) {
			sql.append(" and  wpi.pk_no=:promPkNo ");
			paraMap.put("promPkNo", params.get("promPkNo"));
		}
		if (params.get("masCode") != null) {
			sql.append(" AND wpi.mas_code = :masCode");
			paraMap.put("masCode", params.get("masCode"));
		}
		if (params.get("brandC") != null ) {
			sql.append(" and sm.brand_c in ("+params.get("brandC").toString()+") ");
		}
		if (params.get("oldCode") != null ) {
			sql.append(" AND sm.old_code=:oldCode");
			paraMap.put("oldCode", params.get("oldCode"));
		}
		if(params.get("areaId") != null) {
			sql.append(" and sm.stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = :areaId");
			sql.append(" OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = :areaId))");
			paraMap.put("areaId", params.get("areaId"));
		}
		sql.append(")");
		
		return super.createSQLQuery(sql.toString(), paraMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<StkCategory> getStkCate(BigDecimal areaId) { 
		String str = "SELECT t1.* FROM STK_CATEGORY T1, " +
				"(SELECT DISTINCT CAT_ID from (select CAT_ID, GRADE  from STK_CATEGORY start with CAT_ID " +
				"in(select  SM.CAT2_ID  as cat_id from  stk_mas sm where SM.EP_FLG = 'Y'  and sm.stk_c IN " +
				"(SELECT stk_c FROM STK_AREA SA WHERE SA.area_id = ? OR " +
				"EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = ?))) " +
				"connect by prior parent_id=CAT_ID) aa where GRADE=1) T2 " +
				"WHERE " +
				"INSTR(tree_path,',' || T2.CAT_ID || ',') > 0 or T1.CAT_ID = T2.CAT_ID";
		return this.getSession().createSQLQuery(str).addEntity(StkCategory.class).setBigDecimal(0, areaId).setBigDecimal(1, areaId).list();
	}

	@Override
	public List findAllStkCategory() {
		String sql = "select cat_id,cat_name,cat_id2,cat_name2,cat_id3,cat_name3 from bi_stk_category";
		return super.createSQLQuery(sql.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
}
