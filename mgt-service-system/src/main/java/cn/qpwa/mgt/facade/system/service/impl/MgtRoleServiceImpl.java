package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.mgt.facade.system.service.MgtRoleService;
import cn.qpwa.common.page.Page;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 角色接口实现类
 * 
 */
@Service("mgtRoleService")
@Transactional
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtRoleServiceImpl implements MgtRoleService {

	@Autowired
	private MgtRoleDao mgtRoleDao;
	@Autowired
	private MgtRoleResourceDao mgtRoleResourceDao;
	@Autowired
	private MgtEmployeeRoleDao mgtEmployeeRoleDao;
	@Autowired
	private MgtResourceDao mgtResourceDao;
	@Autowired
	private MgtEmployeeDao mgtEmployeeDao;
	@Autowired
	private MgtDepartmentDao mgtDepartmentDao;

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtRole get(String id) {
		return mgtRoleDao.get(id);
	}

	@Override
	public void removeUnused(String id) {
		mgtRoleDao.removeById(id);
	}

	@Override
	public void saveOrUpdate(MgtRole entity) {
		mgtRoleDao.save(entity);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		return mgtRoleDao.querys(paramMap, orderby);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtRole findById(String id) {
		return mgtRoleDao.get(id);
	}

	@Override
	public void delete(String[] ids) {
		for (String roleId : ids) {
			mgtRoleResourceDao.deleteByRoleId(roleId);
			mgtEmployeeRoleDao.deleteByRoleId(roleId);
		}
		mgtRoleDao.delete(ids);
	}

	@Override
	public void updateRoleStatus(MgtRole role) {
		MgtRole roles = mgtRoleDao.get(role.getId());
		roles.setStatus(role.getId());
		mgtRoleDao.save(roles);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List findByList(Map<String, Object> paramMap) {
		return mgtRoleDao.findByList(paramMap);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List findRoleResourceByList(Map<String, Object> paramMap) {
		return mgtRoleResourceDao.findByList(paramMap);
	}

	@Override
	public void saveRole(Map<String, Object> paramMap) {
		String roleId = paramMap.get("roleId").toString();
		mgtRoleResourceDao.deleteByRoleId(paramMap.get("roleId").toString());
		if (null != paramMap.get("resourceIds")) {
			String[] resources = StringUtils.split(paramMap.get("resourceIds").toString(), ",");
			for (String resourceId : resources) {
				MgtRoleResource roleResource = new MgtRoleResource();
				roleResource.setRoleId(roleId);
				roleResource.setResourceId(resourceId);
				mgtRoleResourceDao.save(roleResource);
			}
		}
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Map<String, Object>> findEmployeeRoleByEmployeeId(String employeeId) {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("employeeId", employeeId);
		return mgtEmployeeRoleDao.findEmployeeRoleByEmployeeId(paramMap);
	}

	@Override
	public void saveEmployeeRole(Map<String, Object> paramMap) {
		String employeeId = paramMap.get("employeeId").toString();
		mgtEmployeeRoleDao.deleteByUser(employeeId);
		if (paramMap.containsKey("roleIds") && StringUtils.isNotBlank(paramMap.get("roleIds").toString())) {
			String[] roleIds = StringUtils.split(paramMap.get("roleIds").toString(), ",");
			for (String roleId : roleIds) {
				MgtEmployeeRole userRole = new MgtEmployeeRole();
				userRole.setRoleId(roleId);
				userRole.setEmployeeId(employeeId);
				mgtEmployeeRoleDao.save(userRole);
			}
		}

	}

	@Override
	public void saveRoleEmployee(Map<String, Object> paramMap) {
		boolean addFlag = Boolean.valueOf(paramMap.get("addFlag").toString());
		MgtEmployeeRole userRole = new MgtEmployeeRole();
		userRole.setRoleId(paramMap.get("roleId").toString());
		userRole.setEmployeeId(paramMap.get("employeeId").toString());
		userRole.setCreateDate(DateUtil.toTimestamp(new Date()));
		Map<String, Object> userRoleMap = mgtEmployeeRoleDao.findByEmployeeRole(paramMap);
		if (addFlag) {
			if (null == userRoleMap || !userRoleMap.containsKey("id")) {
				mgtEmployeeRoleDao.save(userRole);
			}
		} else {
			if (userRoleMap != null)
				mgtEmployeeRoleDao.removeById(userRoleMap.get("ID").toString());
		}

	}

	@Override
	public List<Map<String, Object>> findEmployeeRoleByRoleId(String roleId) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("roleId", roleId);
		return mgtEmployeeRoleDao.findEmployeeRoleByRoleId(paramMap);
	}

	@Override
	@Deprecated
	public MgtEmployee saveEmployeeAllResource() {
		MgtEmployee employee = mgtEmployeeDao.findByAccountName("admin");
		if (null == employee) {
			employee = new MgtEmployee();
			MgtDepartment department = new MgtDepartment();
			department.setDepartCode("111111");
			department.setName("鹏博士");
			department.setIsStore("1");
			department.setSimpName("鹏博士");
			department.setpId("-1");
			department.setStatus("1");
			department.setMemo("鹏博士");
			mgtDepartmentDao.save(department);
			employee.setAccountName("admin");
			employee.setPassword("admin");
			employee.setUserCode("111111");
			employee.setEmail("admin@admin.com");
			employee.setMobile("13800138000");
			// employee.setMerchantId(department.getId());
			employee.setSex("1");
			employee.setStatus("1");
			// employee.setIsShopKeeper("1");
			mgtEmployeeDao.save(employee);
		}

		MgtRole role = new MgtRole();
		role.setName("超级管理员(test)");
		role.setStatus("1");
		role.setMemo("超级管理员(test)");

		mgtRoleDao.save(role);
		List<MgtResource> resourceList = mgtResourceDao.getAll();
		for (MgtResource resource : resourceList) {
			MgtRoleResource roleResource = new MgtRoleResource();
			roleResource.setRoleId(role.getId());
			roleResource.setResourceId(resource.getId());
			mgtRoleResourceDao.save(roleResource);
		}

		MgtEmployeeRole userRole = new MgtEmployeeRole();
		userRole.setRoleId(role.getId());
		userRole.setEmployeeId(employee.getId());
		mgtEmployeeRoleDao.save(userRole);
		return employee;

	}

	@Override
	public List findByName(String name) {
		return mgtRoleDao.findByName(name);
	}

	@Override
	public List findByResourceId(String resourceId) {
		return mgtRoleResourceDao.findByResourceId(resourceId);
	}
	
	 /**
     * 根据用户id和商户code查询用户该商户下的角色
     * @author:lj
     * @date 2015-6-8 下午6:06:49
     * @param paramMap
     * @return
     */
	@Override
    public List<MgtRole> findRoleListByMap(Map<String, Object> paramMap){
		return mgtRoleDao.findRoleListByMap(paramMap);
	}
	
	/**
     * 修改角色的工作域属性
     * @author:lj
     * @date 2015-6-9 上午9:19:10
     * @param paramMap（RoleIds,scope）
     */
	@Override
    public void modifyRoleScope(Map<String, Object> paramMap){
		if(paramMap !=null && StringUtils.isNotBlank(paramMap.get("scope").toString()) 
				&& paramMap.get("ids")!=null){
			mgtRoleDao.modifyRoleScope(paramMap);
		}
    }
	
	/**
     * 删除用户和角色的配置关系
     * @author:lj
     * @date 2015-6-10 下午2:11:19
     * @param paramMap
     */
	@Override
    public void deleteEmployeeRoleRelation(Map<String, Object> paramMap){
		mgtEmployeeRoleDao.deleteEmployeeRoleRelation(paramMap);
    }

	@Override
	public List findByAll(Map<String, Object> paramMap) {
		return mgtRoleDao.findByAll(paramMap);
	}

	@Override
	public List<Map<String, Object>> findByPublc(Map<String, Object> params) {
		return mgtRoleDao.findByPublc(params);
	}
}
