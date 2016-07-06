package cn.qpwa.mgt.core.system.dao;


import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.UserWh;

import java.util.List;
import java.util.Map;

public interface UserWhDAO extends EntityDao<UserWh>{

	/**
	 * 查询仓库列表
	 * @author zld
	 * @param param 
	 * @date 2015-12-21
	 */
	public List<Map<String, Object>> getUserWhList(Map<String, Object> param);

	/**
	 * 查询“企业”仓库列表
	 * @author sy
	 * @date 2015-12-23
	 */
	public List<Map<String, Object>> getMerchentUserWhList(Map<String, Object> param);
	
	/**
	 * 查询操作人员可操作仓库
	 * @param username
	 * @author RJY
	 * @date 2015年12月21日17:22:57
	 * @return
	 */
	public List<Map<String, Object>> findUserWhByUsername(String username);
	
	/**
	 * 根据操作人员清空所绑定仓库
	 * @author RJY
	 * @date 2015年12月21日17:51:31
	 * @param username
	 */
	public void deleteUserWhByUsername(String username);

}
