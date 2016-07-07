package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.LandmarkMas;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface LandmarkMasDAO extends EntityDao<LandmarkMas> {


	/**
	 * @Description 查找地标列表
	 * @author L.Dragon
	 * @return
	 * @date 2015-10-25 下午6:38:00
	 */
	public List<Map<String, Object>> findLandmarkMasList();
	
	/**
	 * 根据查询条件查找地标
	 * @author: lj
	 * @param paramMap
	 * @return
	 * @date : 2015-10-22下午5:22:11
	 */
	public List<Map<String, Object>> queryLandmarkByAreaId(Map<String, Object> paramMap);
	
	/**
     * 获取地标列表信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @author RJY
     * @date 2016年1月25日10:52:44
     * @return
     */
    public Page findLandMarkMasList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
    
    /**
     * 通过UUID删除地标信息
     * @author RJY
     * @date 2016年1月25日17:12:15
     * @param ids
     */
    public void delete(String ids);
    
    /**
     * 通过areaId查找配送店铺
     * @author RJY
     * @date 2016年1月26日15:29:11
     * @param areaId
     * @return
     */
    public List<Map<String, Object>> findShopByAreaId(Map<String, Object> params);

	/**  通过经纬度获得地标主数据
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
	 * 根据区域查询地标
	 * @author: zhaowei
	 * @param areaIds
	 * @return
	 * @date : 2015-10-22下午5:22:11
	 */
	public List<Map<String, Object>> queryLandmarkByAreaIds(Map<String, Object> paramMap);
	
}
