package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.SiteArticle;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 文章数据访问接口，提供店铺类别的CRUD操作
 * @author TheDragonLord
 */
@SuppressWarnings({"rawtypes"})
public interface ArticleDAO extends EntityDao<SiteArticle> {
	
	/**
	 * 查找首页快报、公告
	 * @param acId 文章类别ID
	 * @return List 首页快报，公告列表
	 */
	List findArticleIndex(BigDecimal acId);
	
	/**
	 * 查找文章
	 * @param acId 文章类别ID
	 * @return List 文章列表
	 */
	List findArticle(BigDecimal acId);
	
	/**
	 * 查找快报、公告类别
	 * @param parentAcId 父类ID
	 * @return List 快报，公告列表
	 */
	List findArticleByPid(BigDecimal parentAcId);
	
	/**
	 * 查找快报、公告
	 * @param artTitle 文章标题
	 * @return SiteArticle 文章实体
	 */
	SiteArticle findByTitle(String artTitle);
	
	/**
	 * 获取快报、公告 page
	 * scope： MGT、B2B
	 * @param paramMap 查询参数
	 * @param orderby 排序参数
	 * @return Page 分页对象
	 */
	Page findArticlePage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
    /**
     * 删除  快报、公告
     * @param  ids 文章ID
     */
	void delete(BigDecimal[] ids);
	
	/**
     * 修改发布状态
     * @param  artId
     * 		文章ID
     * @param  isPublication
     * 		发布状态
     */
	void isPublicationFlg(BigDecimal artId, BigDecimal isPublication);
	
	 /**
     * 修改置顶状态
     * @param  artId
     * 		文章ID
     * @param  isTop
     * 		置顶状态
     */
	void isTopFlg(BigDecimal artId, BigDecimal isTop);

}