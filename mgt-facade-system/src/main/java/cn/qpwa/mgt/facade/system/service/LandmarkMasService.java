package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.mgt.facade.system.entity.LandmarkMas;


import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description 地标业务层接口，提供业务逻辑相关操作
 * @author L.Dragon
 * @date 2015-10-25 下午3:36:08
 */
public interface LandmarkMasService extends BaseService<LandmarkMas> {

	/**
	 * @Description 查找地标列表
	 * @author L.Dragon
	 * @return
	 * @date 2015-10-25 下午6:37:11
	 */
	List<Map<String, Object>> findLandmarkMasList();
	
	/**
	 * 根据查询条件查找地标
	 * @author: lj
	 * @param paramMap
	 * @return
	 * @date : 2015-10-22下午5:22:11
	 */
	public List queryLandmarkByAreaId(Map<String, Object> paramMap);

	/**
	 * 通过任意字段查询列表
	 * @param keys
	 * @param values
	 * @return
	 */
	public List<LandmarkMas> findBy(String[] propertyName, Object[] value);
	
	/**
	 * 查找地标列表信息
	 * @author RJY
	 * @DATE 2016年1月25日11:04:49
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page findLandMarkMasList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 通过主键删除地标信息
	 * @author RJY
	 * @date 2016年1月25日17:05:50
	 * @param ids
	 */
	public Msg delete(String id);
	
	/**
	 * 通过主键--启用
	 * @author RJY
	 * @date 2016年1月25日17:29:08
	 * @param ids
	 */
	public void editStatusFlgY(String[] ids);
	
	/**
	 * 通过主键--停用
	 * @author RJY
	 * @date 2016年1月25日17:29:08
	 * @param ids
	 */
	public void editStatusFlgN(String[] ids);
	
	/**
	 * 通过uuid查找landmarkmas实体
	 * @author RJY
	 * @date 2016年1月26日15:31:21
	 * @param id
	 * @return
	 */
	public LandmarkMas getLandMarkMasByUUID(String id);
	
	/**
	 * 通过areaId查找配送店铺
	 * @param areaId
	 * @return
	 */
	public List<Map<String, Object>> findShopByAreaId(Map<String, Object> params);

	/**  
	 * 通过经纬度获得地标主数据
	 * @author lly
	 * @date2015-8-31 
	 * @parameter 
	 * @return  
	 */
	public Page<Map<String, Object>> findLmMas(Map<String, Object> paramMap);
	
	/**  
	 * 通过经纬度获得地标内的店铺列表
	 * @author lly
	 * @date2015-8-31 
	 * @parameter 
	 * @return  
	 */
	public Page<Map<String, Object>> findLmShop(Map<String, Object> paramMap);
	
	/**
	 * 检查code编码是否可用
	 * @author RJY
	 * @date 2016年1月28日17:46:38
	 * @param code
	 * @return
	 */
	public List<LandmarkMas> findByCode(String code);
	
	/**
	 * 根据区域查询地标
	 * @author: lj
	 * @param areaIds 三级区域list
	 * @return
	 * @date : 2016-4-8下午5:22:11
	 */
	public List queryLandmarkByAreaIds(Map<String, Object> paramMap);
}
