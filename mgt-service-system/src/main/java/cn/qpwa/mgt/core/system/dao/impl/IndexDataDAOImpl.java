package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.mgt.core.system.dao.IndexDataDAO;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.*;

@Repository("IndexDataDAO")
@SuppressWarnings({ "deprecation", "rawtypes" })
public class IndexDataDAOImpl extends HibernateEntityDao<Object> implements IndexDataDAO {
	
	/**
	 * 查询热门搜索标题
	 * @param type 文章类型
	 * @retuen  List
	 */
	public List findHotSearch(String type,BigDecimal areaId,String netType){
		String sql = "select box_desc,href from main_page mp,main_page_box mb where mp.pk_no=mb.mas_pk_no and mp.type= ? and mp.AREA_ID=? AND mp.PROD_TYPE=? order by mb.sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, areaId).setString(2, netType).list();
	}
	
	/**
	 * 查询推荐分类
	 * @param boxType 对象类型
	 * @retuen  List
	 */
	@Deprecated 
	public List findTJcate(String boxType){
		String sql = "select mb.box_desc,mb.href,mb.box_type from main_page mp,main_page_box mb where mp.pk_no=mb.mas_pk_no and mp.type='F' and mb.box_type= ? order by mb.sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, boxType).list();
	}
	
	@Override
	public List findADs(String type,BigDecimal areaId,String netType){
		String sql = "select mb.box_desc,mb.box_img,mb.href from main_page mp,main_page_box mb where mp.pk_no=mb.mas_pk_no and mp.type='B' and mb.box_type=? and mp.AREA_ID=? AND mp.PROD_TYPE=? order by mb.sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, areaId).setString(2, netType).list();
	}
	
	@Override
	public List findADs(String type){
		String sql = "select mb.box_desc,mb.box_img,mb.href from main_page mp,main_page_box mb where mp.pk_no=mb.mas_pk_no and mp.type='B' and mb.box_type=? order by mb.sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).list();
	}
	
	/**
	 * 特别推荐
	 * @param type 文章类型
	 * @retuen  List 
	 */
	public List findSpecialRec(String type){
		String sql = "select mb.box_img,mb.stk_c,mb.href,sm.list_price,NVL(prom_price,net_price) as net_price,nvl(mb.stk_name,mb.box_desc) as name from main_page mp,main_page_box mb,STK_MAS sm where mp.pk_no=mb.mas_pk_no and MB.STK_C = SM.STK_C and mp.type= ? order by mb.sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).list();
	}
	
	/**
	 * 每日特价
	 * @param type 文章类型
	 * @retuen  List 
	 */
	public List findDailyspecial(String type,BigDecimal areaId,String netType){
		String DateTime = DateUtil.getCurrDateTime();
		String sql = "select MB.STK_C,MB.STK_NAME,MB.BOX_IMG,SM.PLU_C,wpi.PK_NO,wpi.PROM_PRICE,wpi.SINGLE_CUST_QTY,sm.modle,sm.stk_name_ext "+
					 " from main_page_box MB left join STK_MAS sm on MB.STK_C = SM.STK_C left join (select * from WEB_PROM_ITEM1 where status_flg = 'P') wpi on SM.STK_C = wpi.STK_C"+
					 " where MB.STK_C = wpi.STK_C and MB.mas_pk_no in(select pk_no from main_page mp where mp.type= ? and mp.AREA_ID=? AND mp.PROD_TYPE=? AND mp.SORT_NO=1) and ROWNUM <=4" +
					 " and TO_DATE(?,'YYYY-MM-DD HH24:MI:SS') >= BEGIN_DATE" +
					 " and TO_DATE(?,'YYYY-MM-DD HH24:MI:SS') <= END_DATE" +
					 " order by sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, areaId).setString(2, netType).setString(3, DateTime).setString(4, DateTime).list();
	}
	
	/**
	 * 新品
	 * @param type 文章类型
	 * @retuen  List 
	 */
	public List findNewPro(String type,BigDecimal areaId,String netType){
		String sql = "select MB.STK_C,STK_NAME,BOX_IMG,SM.PLU_C,NVL(prom_price,net_price) as net_price,sm.modle,sm.stk_name_ext from main_page_box MB,STK_MAS sm where MB.STK_C = SM.STK_C and mas_pk_no in(select pk_no from main_page mp where mp.type= ? and mp.AREA_ID=? AND mp.PROD_TYPE=? AND mp.SORT_NO=2) and ROWNUM <=4 order by sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, areaId).setString(2, netType).list();
	}
	
	@Override
	public List findRecmendCombo(BigDecimal areaId) {
		// oracle系统时间有偏差，所以使用web server的时间查询
		String date = DateUtil.getCurrDateTime();
		StringBuffer sql = new StringBuffer("select cm.* from COMBO_MAS cm where STATUS_FLG ='Y' AND TO_DATE(:date,'yyyy-mm-dd hh24:mi:ss') BETWEEN BEGIN_DATE AND END_DATE ");
		boolean flag = null != areaId && areaId.intValue() != -1;
		if (flag) {
			sql.append("AND cm.COMBO_CODE IN (SELECT COMBO_CODE FROM COMBO_AREA CA WHERE (AREA_ID = :areaId OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE AREA_ID = :areaId AND INSTR(TREE_PATH,','||CA.AREA_ID||',') > 0)))");
		}
		sql.append("AND ROWNUM<=6 ORDER BY CREATE_DATE desc");
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		query.setParameter("date", date);
		if (flag) {
			query.setParameter("areaId", areaId);
		}
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List findComboItem(String comboCode,BigDecimal orgNo){
		String sql = "select * from COMBO_ITEM where ORG_NO = ? and COMBO_CODE = ?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, orgNo).setString(1, comboCode).list();
	}
	
	/**
	 * 促销标题
	 * @param type 文章类型
	 * @retuen  List
	 */
	public List findPromotiontitle(String type,BigDecimal areaId,String netType){
		String sql = "select pk_no,box_name from main_page mp where mp.type= ? and mp.AREA_ID=? AND mp.PROD_TYPE=? order by sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, areaId).setString(2, netType).list();
	}
	
	/**
	 * 获取首页分类商品区域数据
	 * @param type 类型
	 * @return Json
	 */
	public List findCate(String type,BigDecimal areaId,String netType){
		String sql = "select pk_no,cat_id,box_name,sort_no from main_page mp where mp.type= ? and mp.AREA_ID=? AND mp.PROD_TYPE=? and show_flg= 'Y' order by sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, areaId).setString(2, netType).list();
	}
	
	@Override
	public List findCate(String type){
		String sql = "select pk_no,cat_id,box_name,sort_no from main_page mp where mp.type= ? and show_flg= 'Y' order by sort_no";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).list();
	}
	
	/**
	 * 获取首页分类商品区域数据
	 * @param obj Map封装参数
	 * @return Json
	 */
	public List findMainPageBox(Map<String, Object> obj) {
		List<Object> parms = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer("select pk_no,mas_pk_no,box_type,href,box_desc,box_img,sort_no,SM.stk_c,SM.list_price,stk_name,sm.stk_name_ext,sm.modle,NVL(prom_price,net_price) as net_price, (CASE BOX_TYPE WHEN 'T' THEN 0 ELSE SORT_NO END )as SORT_NO2 " +
				"from " +
				"main_page_box MB " +
				"LEFT JOIN STK_MAS sm ON MB.STK_C = SM.STK_C " +
				"WHERE 1=1");
		// 通过首页类型、分类ID动态生成查询语句
		if (obj.containsKey("type")) {
			if(obj.get("type").equals("RT")){
				sql.append(" AND (box_type= 'R' OR box_type='T')");
			}else{
				sql.append(" AND box_type= ?");
				parms.add(obj.get("type"));
			}
		}
		if (obj.containsKey("cateID")) {
			sql.append(" AND mas_pk_no=?");
			parms.add(obj.get("cateID"));
		}
		if (obj.containsKey("catId")) {
			sql.append(" AND cat1_id=?");
			parms.add(obj.get("catId"));
		}
		if(obj.get("type").equals("RT")){
			sql.append(" order by SORT_NO2");
		}else{
			sql.append(" order by valid_date,sort_no");
		}
		
		SQLQuery query = super.createSQLQuery(sql.toString(), parms.toArray()) ;
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List findCateAreaCatId(String type,BigDecimal masPkNo){
		String sql = "select distinct SM.cat2_id from main_page_box MB LEFT JOIN STK_MAS sm ON MB.STK_C = SM.STK_C WHERE box_type=? AND mas_pk_no=?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, type).setBigDecimal(1, masPkNo).list();
	}
	
	@Override
	public Page findAllType(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		StringBuffer sql = new StringBuffer("select * from MAIN_PAGE mp where 1=1");
		Map<String, Object> parms = new HashMap<String, Object>();
		if(null!=paramMap){
			if(paramMap.containsKey("areaId") && StringUtils.isNotBlank(paramMap.get("areaId").toString())) {
				sql.append(" AND mp.AREA_ID=:areaId");
				parms.put("areaId", paramMap.get("areaId"));
			}
			if(paramMap.containsKey("prodType") && StringUtils.isNotBlank(paramMap.get("prodType").toString())) {
				sql.append(" AND mp.PROD_TYPE=:prodType");
				parms.put("prodType", paramMap.get("prodType"));
			}
			if(paramMap.containsKey("showFlg") && StringUtils.isNotBlank(paramMap.get("showFlg").toString())) {
				sql.append(" AND mp.SHOW_FLG=:showFlg");
				parms.put("showFlg", paramMap.get("showFlg"));
			}
		}
		orderby = new LinkedHashMap<String, String>();
		if (StringUtils.isNotBlank((String)paramMap.get("orderby"))) {
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}else{
			orderby.put("TYPE", "asc");
		}
		return super.sqlqueryForpage(sql.toString(), parms, orderby);
	}
	
	@Override
	public void showFlgModify(BigDecimal pkNo,String showFlg){
		String sql = "update main_page mp set mp.SHOW_FLG =? where mp.PK_NO =?";
		Query query = super.getSession().createSQLQuery(sql);
		query.setString(0, showFlg).setBigDecimal(1, pkNo).executeUpdate();
	}
	
	@Override
	public Page findIndexDataById(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		StringBuffer sql = new StringBuffer("select ");
		Map<String, Object> parms = new HashMap<String, Object>();
		if(null!=paramMap){
			if(paramMap.containsKey("masPkNo") && StringUtils.isNotBlank(paramMap.get("masPkNo").toString())) {
				if(paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString())&&("D".equals(paramMap.get("type").toString())||"E".equals(paramMap.get("type").toString()))){
					sql.append(" mpb.*,sm.PLU_C,sm.NET_PRICE,sm.UOM,sm.STK_NAME_EXT,sm.MODLE from MAIN_PAGE_BOX mpb left join STK_MAS sm on mpb.STK_C=sm.STK_C");
				}else{
					sql.append(" mpb.* from MAIN_PAGE_BOX mpb");
				}
				sql.append(" where mpb.MAS_PK_NO=:masPkNo");
				parms.put("masPkNo", paramMap.get("masPkNo"));
			}
			if(paramMap.containsKey("boxType") && StringUtils.isNotBlank(paramMap.get("boxType").toString())) {
				sql.append(" and mpb.BOX_TYPE=:boxType");
				parms.put("boxType", paramMap.get("boxType"));
			}
		}
		orderby = new LinkedHashMap<String, String>();
		if (StringUtils.isNotBlank((String)paramMap.get("orderby"))) {
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}else{
			orderby.put("SORT_NO", "asc");
		}
		return super.sqlqueryForpage(sql.toString(), parms, orderby);
	}
}
