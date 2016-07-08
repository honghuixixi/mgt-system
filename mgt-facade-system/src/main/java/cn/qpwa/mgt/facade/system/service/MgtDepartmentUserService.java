package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.mgt.facade.system.entity.MgtDepartmentUser;
import cn.qpwa.common.core.service.BaseService;

import java.util.List;

public interface MgtDepartmentUserService extends BaseService<MgtDepartmentUser> {

	/**
	 * 根据用户id查询用户所在公司id
	 * @author:lj
	 * @date 2015-6-12 上午11:45:58
	 * @param userId
	 * @return
	 */
	public String findDepartmentIdByUserId(String userId);
	/**
	 * 查询用户所在部门
	 * @param userId
	 * @return
	 */
	public List<MgtDepartmentUser> findByUserId(String userId);
}
