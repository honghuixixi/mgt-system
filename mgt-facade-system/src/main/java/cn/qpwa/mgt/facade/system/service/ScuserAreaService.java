package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.mgt.facade.system.entity.ScuserArea;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface ScuserAreaService extends BaseService<ScuserArea>{
	
	/**
	 * 通过userName查找分配区域
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @param userName
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findScuserAreaByUserName(String userName);
	
	/**
	 * 获取当前登录用户的区域
	 * @return
	 */
	public List<Map<String,Object>> getAreaMasWebListByUserName(String userName);
	
	/**
	 * 获取当前登录用户的区域(一二三级)
	 * @return
	 */
	public Set<BigDecimal> getAreaByUserName(String userName);
}
