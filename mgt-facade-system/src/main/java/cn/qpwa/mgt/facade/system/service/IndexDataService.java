package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.page.Page;
import net.sf.json.JSONObject;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 主页数据业务逻辑接口
 * @author sy
 * @version 1.0
 */
@SuppressWarnings("rawtypes")
public interface IndexDataService {

	/**
	 * 查询热门搜索标题
	 * @param type 文章类型
	 * @param areaId 区域id
	 * @param netType 文章所属网站
	 * @return  List 热搜列表
	 */
	List findHotSearch(String type, BigDecimal areaId, String netType);
	
	/**
	 * 查询推荐分类
	 * @param boxType 对象类型
	 * @return  List 列表
	 */
	List findTJcate(String boxType);

	/**
	 * 查询首页轮播广告
	 * @param type 文章类型
	 * @param areaId 所在一级区域Id
	 * @param netType 站点 ：B2BWEB|B2BWAP|B2BAPP|B2CWEB|B2CWAP|B2CAPP
	 * @return  List 广告图片列表
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
	 * @param type 文章类型
	 * @return  List 列表
	 */
	List findSpecialRec(String type);	

	/**
	 * 每日特价
	 * @param type 文章类型
	 * @param areaId 区域id
	 * @param netType 文章所属网站
	 * @return  List 列表
	 */
	List findDailyspecial(String type, BigDecimal areaId, String netType);
	
	/**
	 * 新品
	 * @param type 文章类型
	 * @param areaId 区域id
	 * @param netType 文章所属网站
	 * @return  List 列表
	 */
	List findNewPro(String type, BigDecimal areaId, String netType);
	
	/**
	 * 推荐套餐
	 * @param areaId 登录者3级区域id
	 * @return  JSONObject json集合
	 */
	JSONObject findRecmendCombo(BigDecimal areaId);

	/**
	 * 促销标题
	 * @param type 文章类型
	 * @param areaId 区域id
	 * @param netType 文章所属网站
	 * @return  List 列表
	 */
	List findPromotiontitle(String type, BigDecimal areaId, String netType);

	/**
	 * 获取首页分类商品区域数据
	 * @param areaId 区域id
	 * @param netType 文章所属网站
	 * @return Json json对象
	 */
	JSONObject findCateArea(BigDecimal areaId, String netType);
	
	/**
	 * App 专用
	 * 获取首页分类商品区域数据
	 * @author zld 1015。11.25修改
	 * @param areaId 区域id 
	 * @param netType 类型
	 * @return Json json对象
	 */
	JSONObject findAppCateArea(BigDecimal areaId, String netType);
	
	/**
	 * 获取首页分类商品区域商品所属类别
	 * @param type 主页数据类型
	 * @param masPkNo id
	 * @return list 列表
	 */
	List findCateAreaCatId(String type, BigDecimal masPkNo);
	
	/**
	 * 获取首页数据所有类型
	 * @return Page
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

	/**
	 * 添加"A"类型的首页数据 
	 * @param masPkNo 外键
	 * @param items 页面表单数据封装集合
	 */
	void addItemA(BigDecimal masPkNo, String items);
	/**
	 * 根据区域id查询是否有首页数据
	 * @author: lj
	 * @param type
	 * @param rootAreaId
	 * @return
	 * @date : 2016-1-26上午11:46:10
	 */
	List findIndexListByAreaId(String type, String rootAreaId);
}
