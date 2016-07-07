package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.AreaMasWeb;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 地区数据访问层接口
 * @author zhaowei
 *
 */
public interface AreaMasWebDAO extends EntityDao<AreaMasWeb> {

	/**
	 * 查找顶级地区
	 * 
	 * @return 顶级地区
	 */
	List<AreaMasWeb> findRoots();
	
	/**
	 * 查找子节点
	 * 
	 * @param parent
	 *           父ID
	 * @return 顶级地区
	 */
	List<AreaMasWeb> findChilds(BigDecimal parent);
	
	/**
	 * 查找完整区域
	 * @param areaId
	 * 	地区ID
	 * @return 完整区域
	 */
	Map<String, Object> findAll(BigDecimal areaId);
	
	/**
	 * 根据三级区域ID查找全部区域名称
	 * @param areaId
	 *  地区ID 
	 * @return 完整区域
	 */
	Map<String, Object> findFullName(BigDecimal areaId);
	/**
	 * 查询三级区域的所有上级区域Id
	 * @param areaId
	 * @return
	 */
	public Map<String, Object> findAllParntIdByAreaId(BigDecimal areaId);

	/**
	 * 根据区域id查询顶级区域id
	 * @author zld
	 * @param areaId 地区id
	 * @return Map<String, Object> 顶级区域id AREA_ID 
	 */
	Map<String, Object> findRootsByAreaId(BigDecimal areaId);
	
	/**
	 * 根据一级区域id查询三级区域
	 * @author: lj
	 * @param rootAreaId
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public Map<String, Object> findChildByRootAreaId(BigDecimal rootAreaId);

	/**
	 * @Description 查找所有父级区域
	 * @return
	 * @date 2016-1-11 上午10:51:30
	 */
	List<AreaMasWeb> findAllParentArea();
	
	/**
	 * 根据区域id查询全部区域列表
	 * @author: zy
	 * @param areaId
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public List<Map<String, Object>> findAllAreaId(Map<String, Object> paramMap);
	
	/**
	 * 根据区域id查询全部区域列表
	 * @author: zy
	 * @param areaId
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public List<Map<String, Object>> findAllAreaId(String[] areaIdS);
	
	/**
	 * 查询二级区域列表
	 * @author: zld
	 * @param areaId,userName
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public List<Map<String, Object>> findCityAreaId(Map<String, Object> param);
	
	/**
	 * 查询物流三级区域列表
	 * @author: zld
	 * @param areaId,userNo
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public List<Map<String, Object>> findDistAreaId(Map<String, Object> param);
	
	/**
	 * 查询物流二级区域列表
	 * @author: zld
	 * @param areaId,userNo
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public List<Map<String, Object>> findWLCityAreaId(Map<String, Object> param);
	
	/**
	 * 查询物流三级区域列表
	 * @author: zld
	 * @param areaId,userNo
	 * @return
	 * @date : 2015-11-27上午11:21:05
	 */
	public List<Map<String, Object>> findWLDistAreaId(Map<String, Object> param);
	
	/**
	 * 根据1级区域id获取 全部区域
	 * @author: zy
	 * @param areaId
	 * @return
	 */
	public List<AreaMasWeb> findAllAreaId(BigDecimal areaId);
	
	/**
	 * 获取区域的级别
	 * @param areaId
	 *  地区ID 
	 * @return grade
	 */
	public String findGradeByAreaId(BigDecimal areaId);
	
	/**
	 * 根据1、2级区域名称获取3级区域id
	 * @param areaName
	 * @return grade
	 */
	public Map<String, Object> findChildByRootAreaId(String areaName, BigDecimal grade);
	
	/**
	 * 根据areaId获取其区域，和 它下面所有区域
	 * @param areaId
	 * @return List
	 */
	public List<Map<String, Object>> findBelongAreaId(BigDecimal areaId);
}
