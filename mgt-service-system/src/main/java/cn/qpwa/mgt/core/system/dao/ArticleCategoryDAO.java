package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.SiteArticleCategory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 文章类别数据访问接口，提供店铺类别的CRUD操作
 * @author TheDragonLord
 */
public interface ArticleCategoryDAO extends EntityDao<SiteArticleCategory>{
	
	/**
	 * 查找文章类别标题
	 * @param artId 文章ID
	 * @return list 文章类别
	 */
	List<Map<String, Object>> findArticleByArtid(BigDecimal artId);
	
	/**
	 * 查找顶级地区
	 * 
	 * @return 顶级地区
	 */
	List<SiteArticleCategory> findRoots();
	
	/**
	 * 查找子节点
	 * 
	 * @param parentId
	 *           父ID
	 * @return List 文章类别
	 */
	List<SiteArticleCategory> findChilds(BigDecimal parentId);
}
