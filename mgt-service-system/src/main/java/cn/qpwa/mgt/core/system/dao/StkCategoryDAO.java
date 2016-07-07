package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.StkCategory;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 商品数据访问层接口，提供商品分类的CRUD操作
 * 
 */
@SuppressWarnings("rawtypes")
public interface StkCategoryDAO extends EntityDao<StkCategory> {
	
	/**
	 * 根据Pid查询商品分类（所有商品分类）
	 * @param parentId
	 * 父ID
	 * @return
	 */
	public List getStkCategoryPID(BigDecimal parentId);
	
	/**
	 * 根据Pid查询商品分类（所有商品分类）
	 * <p>scope： B2B、wap</p>
	 * @param params 父ID
	 * @return
	 */
	public List findStkCategoryPid(BigDecimal params);
	
	/**
	 * 根据Grade查询商品分类（所有商品分类）
	 * <p>scope： B2B、wap</p>
	 * @param params GradeID
	 * @return
	 */
	public List findStkCategoryGrade(BigDecimal params);
	
	/**
     * 根据catId查询商品分类级别
     * @param params catId
     * return grade
     */
	public BigDecimal findGrade(BigDecimal params);
	
	/**
	 *  根据CatId查询商品分类（所有商品分类）
	 * @param params CatId
	 * @return
	 */
	public List findStkCategoryCatId(BigDecimal params);
	
	/**
	 *  根据CatId查询商品分类（指定分类、指定品牌code）
	 * @param param parentId、brandC、orgNo
	 * @return
	 */
	public List<Map<String, Object>> findStkCategoryCatId(Map param);
	
	/**
	 *  根据小类CatId查询超类商品分类（所有商品分类）
	 * @param params 小类CatId
	 * @return
	 */
	public List findStkCategoryParent(BigDecimal params);
	
	
	/**
	 *  根据小类CatId查询超类商品分类（所有商品分类）
	 * @param params 小类CatId
	 * @return
	 */
	public List findStkCategoryPidParent(BigDecimal params);
	
	 /**
     * 通过分类ID查找相关分类
     * @param catId 类别ID
     * @param orgNo
     * 组织机构代码
     * @return
     */
    public List<StkCategory> findRelativeStkCategorysByCatId(BigDecimal catId, BigDecimal orgNo);
    
    /**
     * 查找父类
     * @param stkCategory
     * 	类别ID
     * @param orgNo
     * 	组织机构代码
     * @return
     */
    public List<StkCategory> findParents(StkCategory stkCategory, BigDecimal orgNo);

	/**
	 * 根据上品牌筛选商品
	 * @param CONDITION
	 * 	品牌
	 * @param ORDER_BY
	 * 	排序
	 * @return
	 */
	public Page findProSearch(String CONDITION, String ORDER_BY, BigDecimal areaId);
	   /**
     * 获取分类信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 批量删去分类信息
     * 
     * @param ids
     *            分类ID字符串，使用逗号分割
     */
    public void delete(String[] ids);
    /**
     * 通过分类等级查询
     * @param paramMap
     * @return
     */
    public List findByGradeList(Map<String, Object> paramMap);
    /**
     * 查询排序最大值
     * @return
     */
    public int countMaxSortNo();
    /**
     * 查询是否有下级分类
     * @return
     */
    public int countByParentIds(String[] ids, String orgNo);
    /**
     * 分类菜单穿
     * @param params
     * @return
     */
    public List findByCategoryList(Map<String, Object> params);
    /**
     * 查询分类和下级分类
     * @param catId
     * @return
     */
    public List findByTreepath(String catId);

    /** 
      * @author lly
      * @date2015-6-16 
      * @parameter 
      * @return  获得父类id为parentid 的所有类目
    */
    public List<StkCategory> findChilds(BigDecimal params);
    
	/** 
	  * @author lly
	  * @date2015-6-16 
	  * @parameter 
	  * @return  获得所有的类目
	*/
	public List<StkCategory> findRoots();

	/** 通过父类id获取所有的类别
	  * @author lly
	  * @date2015-8-20 
	  * @parameter 
	  * @return  
	*/
	public List<StkCategory> findCateByParent(String parentId);
	/**
     * 中类商品分类
     * @param param:{Id 小类别ID,areaId 区域id}
     * @param 
     * @return List商品类别
     * @author:liujing
	 * @date 2015-12-31 
     */
    public List<Map<String,Object>> getStkCategoryPidParent(Map<String, Object> param);
    /**
     * 商品分类
     * <p>scope： B2B、wap</p>
     * @param param:{grade 级别,areaId 区域id}
     * @return List商品类别
     * @author:liujing
	 * @date 2015-12-31 
     */
    public List<Map<String,Object>> getStkCategoryGrade(Map<String, Object> param);
    /**
     * 通过分类ID查找相关分类
     * @param param:{catId 类别ID,areaId 区域id,orgNo	组织机构代码}
     * @return List商品类别
     * @author:liujing
	 * @date 2016-01-04 
     */
    public List<Map<String,Object>> findRelativeStkCategorysByCatId(Map<String, Object> param);

	/**
	 * @Description 查找新品分类
	 * @param params
	 * @param level:级别
	 * @return
	 * @date 2016-1-25 下午12:56:30
	 */
	public List findStkCateNew(Map<String, Object> params, int level);

	/**
	 * @Description 查询促销商品分类
	 * @param params
	 * @return
	 * @date 2016-1-27 下午4:02:25
	 */
	public List<Map<String, Object>> findPromStkCate2(Map<String, Object> params);

	/**
	 * @Description 查询促销商品分类
	 * @param params
	 * @return
	 * @date 2016-1-27 下午5:13:29
	 */
	public List<Map<String, Object>> findPromStkCate3(Map<String, Object> params);

	/**
	 * @Description 根据区域id获取商品分类
	 * @param params
	 * @return
	 * @date 2016-1-27 下午5:13:29
	 */
	public List<StkCategory> getStkCate(BigDecimal areaId);
	
	/**
	 * 商品导入excel模板商品分类，查询所有平台分类 大类/中类/小类
	 * @return
	 * @author honghui
	 * @date   2016-04-26
	 */
	public List<Map<String, Object>> findAllStkCategory();
}
