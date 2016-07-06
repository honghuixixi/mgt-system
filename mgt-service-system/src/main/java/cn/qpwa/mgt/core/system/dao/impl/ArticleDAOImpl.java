package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.ArticleDAO;
import cn.qpwa.mgt.facade.system.entity.SiteArticle;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 文章数据访问接口实现，提供店铺类别的CRUD操作
 * @author sy
 */
@Repository("articleDAO")
@SuppressWarnings({ "rawtypes", "deprecation" })
public class ArticleDAOImpl extends HibernateEntityDao<SiteArticle> implements ArticleDAO {

	@Override
	public List findArticleIndex(BigDecimal acId){
		String sql = "select ART_TITLE,ART_ID,AC_ID from SITE_ARTICLE where ac_id= ? and rownum<=4 order by ORDERS";				
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, acId).list();
	}
	
	@Override
	public List findArticle(BigDecimal acId){
		String sql = "select ART_TITLE,ART_ID,AC_ID from SITE_ARTICLE where ac_id= ?  and IS_PUBLICATION=1 order by ORDERS";				
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, acId).list();
	}
	
	@Override
	public List findArticleByPid(BigDecimal parentAcId){
		String sql = "select AC_ID,ORDERS,NAME from SITE_ARTICLE_CATEGORY sa where sa.PARENT_AC_ID =? order by ORDERS ASC";				
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, parentAcId).list();
	}
	
	@Override
	public SiteArticle findByTitle(String artTitle){	
		if (artTitle == null) {
			return null;
		}
		return this.findUniqueBy("artTitle", artTitle);
	}
	
	@Override
	public Page findArticlePage(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(sa.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') SA_CREATE_DATE,to_char(sa.MODIFY_DATE,'yyyy-mm-dd hh24:mi:ss') SA_MODIFY_DATE, sa.ART_ID,sa.AC_ID,sa.AUTHOR,sa.IS_PUBLICATION,sa.IS_TOP,sa.ART_TITLE,sa.SEO_DESCRIPTION from SITE_ARTICLE sa where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("acId") && StringUtils.isNotBlank(paramMap.get("acId").toString())) {
				sql.append(" and (sa.AC_ID=:AC_ID OR sa.AC_ID IN (SELECT AC_ID FROM SITE_ARTICLE_CATEGORY WHERE INSTR(TREE_PATH,','||:AC_ID||',') > 0))");
				param.put("AC_ID", paramMap.get("acId"));
			}
			if (paramMap.containsKey("isPublication") && StringUtils.isNotBlank(paramMap.get("isPublication").toString())) {
				sql.append(" and sa.IS_PUBLICATION=:IS_PUBLICATION");
				param.put("IS_PUBLICATION", paramMap.get("isPublication"));
			}
			if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		Page page = super.sqlqueryForpage(sql.toString(), param, orderby);
		return page;
	}
	
	@Override
	public void delete(BigDecimal [] ids) {
		if (ids != null && ids.length > 0) {
			Query query = getSession().createQuery("delete from SiteArticle sa where sa.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public void isPublicationFlg(BigDecimal artId,BigDecimal isPublication) {
		String sql = "UPDATE  SITE_ARTICLE SA  SET SA.IS_PUBLICATION=:isPublication WHERE SA.ART_ID=:artId";
		Query query = super.getSession().createSQLQuery(sql);
		query.setParameter("artId", artId);
		query.setParameter("isPublication", isPublication);
		query.executeUpdate();
		
	}

	@Override
	public void isTopFlg(BigDecimal artId,BigDecimal isTop) {
		String sql = "UPDATE  SITE_ARTICLE SA  SET SA.IS_TOP=:isTop WHERE SA.ART_ID=:artId";
		Query query = super.getSession().createSQLQuery(sql);
		query.setParameter("artId", artId);
		query.setParameter("isTop", isTop);
		query.executeUpdate();
		
	}
}