package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.page.PageView;
import cn.qpwa.mgt.facade.system.entity.SiteArticle;
import net.sf.json.JSONObject;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Service - 文章
 * 
 * @author sy
 * @version 1.0
 */
@SuppressWarnings("rawtypes")
public interface ArticleService {
	/**
	 * 查找首页快报、公告
	 * @param acId 
	 * 		文章类别ID
	 * @return List
	 */
	List findArticleIndex(BigDecimal acId);
	
	/**
	 * 查找文章
	 * @param acId
	 * 			文章类别ID
	 * @return List
	 */
	List findArticle(BigDecimal acId);
	
	/**
	 * 查找快报、公告类别
	 * @param parentAcId
	 * 			文章父类类别ID
	 * @return List
	 */
	List findArticleByPid(BigDecimal parentAcId);
	
	/**
	 * 快报、公告 单条记录查询
	 * scope： MGT、B2B
	 * @param artId
	 * 		文章ID
	 * @return 文章实体
	 */
	SiteArticle findArticleById(BigDecimal artId);
	
	/**
	 * 快报、公告 查询
	 * @param artTitle
	 * 			文章标题
	 * @return 文章实体
	 */
	SiteArticle findByTitle(String artTitle);
	
	/**
	 * 获取快报、公告page
	 * scope： MGT、B2B
	 * @param paramMap 查询参数
	 * @param orderby	排序参数
	 * @return page分页对象
	 */
	PageView findArticlePage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 获取文章标题缓存
	 * @param acId
	 * 			文章类别ID
	 * @return Json
	 */
	JSONObject findArticleCache(BigDecimal acId);

	/**
	 * 添加  快报、公告 
	 * @param siteArticle 文章实体
	 */
    void save(SiteArticle siteArticle);
    
    /**
     * 删除  快报、公告
     * @param  ids
     * 		文章ID
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
