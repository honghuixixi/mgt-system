package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.core.system.dao.ArticleCategoryDAO;
import cn.qpwa.mgt.facade.system.entity.SiteArticleCategory;
import cn.qpwa.mgt.facade.system.service.ArticleCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 文章类别接口实现类，提供相关业务逻辑操作
 * @author TheDragonLord
 */
@Service("articleCategoryService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ArticleCategoryServiceImpl implements ArticleCategoryService {

    @Autowired
	ArticleCategoryDAO articleCategoryDAO;
	
    @Override
	public SiteArticleCategory find(BigDecimal acId) {
		return articleCategoryDAO.findUniqueBy(SiteArticleCategory.class, articleCategoryDAO
				.getIdName(SiteArticleCategory.class), acId);
	}
    
    @Override
	public List<Map<String, Object>> findArticleByArtid(BigDecimal artId){
		return articleCategoryDAO.findArticleByArtid(artId);
	}
    
    @Override
	public List<SiteArticleCategory> findRoots(){
		return articleCategoryDAO.findRoots();
	}

    @Override
	public List<SiteArticleCategory> findChild(BigDecimal acId) {
		return articleCategoryDAO.findChilds(acId);
	}
}
