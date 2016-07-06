package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.mgt.facade.system.entity.SiteArticleCategory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Service - 文章
 * 
 * @author sy
 * @version 1.0
 */
public interface ArticleCategoryService {

	/**
	 * 获取文章类别
	 * @param acId
	 *  文章类别ID
	 * @return SiteArticleCategory
	 */
	SiteArticleCategory find(BigDecimal acId);
	
	/**
	 * 查找文章类别标题
	 * @param artId
	 * 			文章类别ID
	 * @return 标题
	 */
	List<Map<String, Object>> findArticleByArtid(BigDecimal artId);
	
	/**
	 * 查找顶级文章类别
	 * @return 顶级文章类别
	 */
	List<SiteArticleCategory> findRoots();

	/**
	 * 查找子节点
	 * @param acId
	 * 	文章类别ID 
	 * @return 子节点
	 */
	List<SiteArticleCategory> findChild(BigDecimal acId);
}
