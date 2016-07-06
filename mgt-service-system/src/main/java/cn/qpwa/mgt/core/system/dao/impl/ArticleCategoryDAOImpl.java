package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.ArticleCategoryDAO;
import cn.qpwa.mgt.facade.system.entity.SiteArticleCategory;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 文章类别数据访问接口实现，提供店铺类别的CRUD操作
 * @author sy
 */
@Repository("articleCategoryDAO")
@SuppressWarnings({"deprecation","unchecked"})
public class ArticleCategoryDAOImpl extends HibernateEntityDao<SiteArticleCategory> implements ArticleCategoryDAO {

	@Override
	public List<Map<String, Object>> findArticleByArtid(BigDecimal artId){	
		String sql="select NAME,AC_ID from SITE_ARTICLE_CATEGORY sc where sc.AC_ID IN (select AC_ID from SITE_ARTICLE sa WHERE sa.ART_ID = ?)";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, artId).list();
	}
	
	@Override
	public List<SiteArticleCategory> findRoots() {
		String hql = "select siteArticleCategory from SiteArticleCategory siteArticleCategory where siteArticleCategory.parentAcId is null order by siteArticleCategory.orders";
		return this.find(hql);
	}

	@Override
	public List<SiteArticleCategory> findChilds(BigDecimal parent) {
		String hql = "select siteArticleCategory from SiteArticleCategory siteArticleCategory where siteArticleCategory.parentAcId = ? order by siteArticleCategory.orders";
		return this.find(hql, new Object[] { parent });
	}
}
