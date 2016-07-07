package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.ScuserArea;

import java.util.List;
import java.util.Map;

public interface ScuserAreaDAO extends EntityDao<ScuserArea>{
	
	/**
	 * 通过userName查找分配区域
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @param userName
	 * @return
	 */
	public List<Map<String, Object>> findByUserName(String userName);
	
	/**
	 * 通过userName删除分配区域
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @param userName
	 */
	public void deleteByUserName(String userName);
	
	/**
	 * 根据任意级别areaId查找下辖所有三级区域
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> findAreaBy(Map<String, Object> map);

}
