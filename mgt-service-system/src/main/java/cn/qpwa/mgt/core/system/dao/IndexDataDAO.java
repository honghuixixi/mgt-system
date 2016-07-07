package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 首页数据访问层接口
 * @author wei
 */
@SuppressWarnings("rawtypes")
public interface IndexDataDAO extends EntityDao<Object> {
	
	/**
	 * 查询热门搜索标题
	 * @param type 类型
	 * @param areaId 区域id
	 * @param netType 网站类型
	 * @return list 热搜列表
	 */
	List findHotSearch(String type, BigDecimal areaId, String netType);
	
	/**
	 * 查询推荐分类
	 * @param boxType 类型
	 * @return list 推荐列表
	 */
	List findTJcate(String boxType);

	/**
	 * 查询首页轮播广告
	 * @param type 文章类型
	 * @param areaId 所在一级区域Id
	 * @param netType 站点 ：B2BWEB|B2BWAP|B2BAPP|B2CWEB|B2CWAP|B2CAPP
	 * @return  List
	 */
	List findADs(String type, BigDecimal areaId, String netType);
	
	/**
	 * 查询大中小类轮播广告
	 * @param type 文章类型
	 * @return  List 列表
	 */
	List findADs(String type);
	
	/**
	 * 特别推荐
	 * @param type 类型
	 * @return  List 列表
	 */
	List findSpecialRec(String type);

	/**
	 * 每日特价
	 * @param type 类型
	 * @param areaId 区域id
	 * @param netType 网站类型
	 * @return  List 列表
	 */
	List findDailyspecial(String type, BigDecimal areaId, String netType);
	
	/**
	 * 新品
	 * @param type 类型
	 * @param areaId 区域id
	 * @param netType 网站类型
	 * @return list 列表
	 */
	List findNewPro(String type, BigDecimal areaId, String netType);
	
	/**
	 * 推荐套餐
	 * @param areaId 登陆者3 级区域ID  
	 * @return list 列表
	 */
	List findRecmendCombo(BigDecimal areaId);
	
	/**
	 * 推荐套餐
	 * @param orgNo 组织机构代码
	 * @param comboCode 套餐代码
	 * @return list 列表
	 */
	List findComboItem(String comboCode, BigDecimal orgNo);

	/**
	 * 促销标题
	 * @param type 类型
	 * @param areaId 区域id
	 * @param netType 网站类型
	 * @return list 列表
	 */
	List findPromotiontitle(String type, BigDecimal areaId, String netType);
	
	/**
	 * 大类类别
	 * @param type 类型
	 * @return list 列表
	 */
    List findCate(String type);
	
	/**
	 * 大类类别
	 * @param type 类型
	 * @param areaId 区域id
	 * @param netType 网站类型
	 * @return list 列表
	 */
	List findCate(String type, BigDecimal areaId, String netType);

	/**
	 * 获取首页分类商品区域数据
	 * @param obj 查询参数
	 * @return list 列表
	 */
	List findMainPageBox(Map<String, Object> obj);
	
	/**
	 * 获取首页分类商品区域商品所属类别
	 * @param type 主页数据类型
	 * @param masPkNo id
	 * @return list 列表
	 */
	List findCateAreaCatId(String type, BigDecimal masPkNo);
	
	/**
	 * 获取首页数据所有类型
	 * @return list 列表
	 */
	Page findAllType(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 修改首页数据显示、隐藏状态
	 * @param pkNo 记录id
	 * @param showFlg 状态位
	 */
	void showFlgModify(BigDecimal pkNo, String showFlg);

	/**
	 * 获取首页各种数据类型的数据
	 * @param id 主键
	 * @param boxType 数据区域类型“子类型”
	 * @return Page
	 */
	Page findIndexDataById(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
}
