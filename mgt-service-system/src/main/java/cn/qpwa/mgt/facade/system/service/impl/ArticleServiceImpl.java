package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.mgt.core.system.dao.ArticleDAO;
import cn.qpwa.mgt.facade.system.entity.SiteArticle;
import cn.qpwa.mgt.facade.system.service.ArticleService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *文章接口实现类，提供相关业务逻辑操作
 * @author TheDragonLord
 */
@Service("articleService")
@SuppressWarnings({"rawtypes","unchecked"})
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ArticleServiceImpl implements ArticleService {
	
    @Autowired
	ArticleDAO articleDAO;
    
    @Override
	public List findArticleIndex(BigDecimal acId){
		return articleDAO.findArticle(acId);
	}
	
    @Override
	public List findArticle(BigDecimal acId){
		return articleDAO.findArticle(acId);
	}  
	
    @Override
	public List findArticleByPid(BigDecimal parentAcId){
		return articleDAO.findArticleByPid(parentAcId);
	}
	
    @Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public SiteArticle findArticleById(BigDecimal artId) {
		SiteArticle art = articleDAO.get(artId);
		return art;
	}
	
    @Override
	public SiteArticle findByTitle(String artTitle){		
		SiteArticle art = articleDAO.findByTitle(artTitle);
		return art;
	}
	
    @Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public PageView findArticlePage(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		if (null != paramMap && paramMap.containsKey("orderby")
				&& ("SA_CREATE_DATE".equals(paramMap.get("orderby").toString())
				|| "".equals(paramMap.get("orderby").toString()))) {
			paramMap.put("orderby", "sa.CREATE_DATE");
		}
		Page page = articleDAO.findArticlePage(paramMap, orderby);
			// 拼装分页信息
		PageView result = new PageView(SystemContext.getPagesize(),
				SystemContext.getOffset());
		result.setQueryResult(page);
		return result;
	}
	
    @Override
	public JSONObject findArticleCache(BigDecimal acId) {
		JSONObject result = null;
		// 获取大类
		List cate_h = articleDAO.findArticleByPid(acId);
		if (cate_h != null && cate_h.size() > 0) {
			result = new JSONObject();
			result.put("success", "true");
			result.put("msg", "成功");
			JSONArray jarray = new JSONArray();
			for (int i = 0; i < cate_h.size(); i++) {
				JSONObject content = new JSONObject();
				Map<String, Object> catMap = (Map<String, Object>) cate_h.get(i);
				BigDecimal AcId = (BigDecimal) catMap.get("AC_ID");
				//文章类别标题
				content.put("cateTitle", JSONTools.toJson(cate_h.get(i)));
				// 获取该类下的文章标题
				List artTitle = articleDAO.findArticle(AcId);
				content.put("artTitle", JSONTools.toJson(artTitle));
				if(artTitle != null && artTitle.size() > 0){
					content.put("show", "true");
				}
				jarray.add(content);
			}
			result.put("content", jarray);
		}
		return result;
	}
	
    @Override
	public void save(SiteArticle siteArticle) {		
		articleDAO.save(siteArticle);
	}
	
    @Override
	public void delete(BigDecimal [] ids){
		articleDAO.delete(ids);
	}

	@Override
	public void isPublicationFlg(BigDecimal artId,BigDecimal isPublication) {
		articleDAO.isPublicationFlg(artId,isPublication);
		
	}

	@Override
	public void isTopFlg(BigDecimal artId,BigDecimal isTop) {
		articleDAO.isTopFlg(artId,isTop);
		
	}
}
