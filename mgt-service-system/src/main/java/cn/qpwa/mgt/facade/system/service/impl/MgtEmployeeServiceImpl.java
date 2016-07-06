package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.LogEnabled;
import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.mgt.facade.system.service.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

/**
 * 用户接口实现类
 * 
 */
@Service("mgtEmployeeService")
@Transactional
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtEmployeeServiceImpl implements MgtEmployeeService, LogEnabled {

	@Autowired
	private MgtDepartmentService mgtDepartmentService;
	@Autowired
	private MgtEmployeeDao mgtEmployeeDao;
	@Autowired
	private MgtDepartmentUserDao mgtDepartmentEmployeeDao;
	@Autowired
	private MgtEmployeeRoleDao mgtEmployeeRoleDao;
	@Autowired
	private MgtRoleDao mgtRoleDao;
	@Autowired
	private MgtEmployeeRoleDao employeeRoleDao;
	@Autowired
	private MgtRoleResourceDao mgtRoleResourceDao;
	@Autowired
	private MgtMenuDao mgtMenuDao;
	@Autowired
	private MgtResourceDao mgtResourceDao;
	@Autowired
	private MgtDepartmentDao mgtDepartmentDao;
	@Autowired
	private UserService userService;
	@Autowired
	private UserWhDAO userWhDAO;

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtEmployee get(String id) {
		return mgtEmployeeDao.get(id);
	}

	@Override
	public void removeUnused(String id) {
		mgtEmployeeDao.removeById(id);
	}

	@Override
	public void saveOrUpdate(MgtEmployee entity, String citySelCode) {
		mgtEmployeeDao.save(entity);
		mgtDepartmentEmployeeDao.deleteByUserId(entity.getId());
		MgtDepartmentUser departmentUser = new MgtDepartmentUser();
		departmentUser.setUserId(entity.getId());
		departmentUser.setDepatementId(citySelCode);
		mgtDepartmentEmployeeDao.save(departmentUser);
	}

	/**
	 * 递归查找
	 * 
	 * @param dept
	 * @param list
	 * @return
	 */
	// private List<Department> getDeptName(String dept, List<Department> list)
	// {
	// List<Department> subList = departmentService.findByParentId(dept);
	// for (int i = 0; i < subList.size(); i++) {
	// Department department = subList.get(i);
	// list.add(department);
	// this.getDeptName(department.getId(), list);
	// }
	// return list;
	// }

	/**
	 * 递归查找
	 * 
	 * @param list
	 * @param countList
	 * @return
	 */
	private List getDeptName(List list, List countList) {
		JSONArray subList = mgtDepartmentService.findByParentMap(list);
		int length = subList.size();
		List searchList = new ArrayList();
		for (int i = 0; i < length; i++) {
			Map map = new HashMap();
			JSONObject jsonObject = (JSONObject) subList.get(i);
			String subPid = jsonObject.getString("ID");
			searchList.add(i, subPid);
			map.put("departId", subPid);
			countList.add(map);
		}
		if (length > 0) {
			this.getDeptName(searchList, countList);
		}
		return countList;
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		List<Map> list = new ArrayList<Map>();
		// 选择部门树时过滤条件
		if (paramMap.containsKey("departId") && StringUtils.isNotBlank(paramMap.get("departId").toString())) {
			Map map = new HashMap();
			map.put("departId", paramMap.get("departId").toString());
			list.add(map);
			// 遍历查询部门
			// list = this.getDeptName(paramMap.get("departId").toString(),
			// list);
			List searchList = new ArrayList();
			searchList.add(0, paramMap.get("departId").toString());
			list = this.getDeptName(searchList, list);
			// 登录用户时过滤
		} else {
			String loginUserId = (String) paramMap.get("loginUserId");
			if (StringUtils.isNotBlank(loginUserId)) {
				MgtDepartmentUser departmentUser = new MgtDepartmentUser();
				List<MgtDepartmentUser> departmentUserList = mgtDepartmentEmployeeDao.findByUserId(loginUserId);
				if (null != departmentUserList && departmentUserList.size() > 0) {
					departmentUser = departmentUserList.get(0);
				}
				Map map = new HashMap();
				map.put("departId", departmentUser.getDepatementId());
				list.add(map);
				// 遍历查询部门
				// list = this.getDeptName(departmentUser.getDepatementId(),
				// list);
				List searchList = new ArrayList();
				searchList.add(0, departmentUser.getDepatementId());
				list = this.getDeptName(searchList, list);
			}
		}
		log.info("查询用户成功");
		if (orderby.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			// orderby.put("", ""STATUS"")
		}
		return mgtEmployeeDao.querys(paramMap, orderby, list);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtEmployee findById(String id) {
		return mgtEmployeeDao.get(id);
	}

	@Override
	public void delete(String[] ids) {
		for (String id : ids) {
			MgtEmployee employee = new MgtEmployee();
			//清空功能权限
			mgtEmployeeRoleDao.deleteByUser(id);
			employee = mgtEmployeeDao.get(id);
			//清空仓库权限
			userWhDAO.deleteUserWhByUsername(employee.getAccountName());
			employee.setStatus(BizConstant.ORG_STATUS_DELETE);
			
			mgtEmployeeDao.save(employee);
			User user1 = userService.findByUsername(employee.getAccountName());
			user1.setBlockFlg("Y");
			user1.setShowFlg("N");
			user1.setBundingMobile("");
			log.info("删除用户及中间表");
		}
	}

	@Override
	public void saveEmployeeRole(Map<String, Object> paramMap) {
		String userId = paramMap.get("userId").toString();
		mgtEmployeeRoleDao.deleteByUser(userId);
		if (null != paramMap.get("roleIds") && paramMap.containsKey("roleIds")) {
			String[] roleIds = StringUtils.split(paramMap.get("roleIds").toString(), ",");
			for (String roleId : roleIds) {
				MgtEmployeeRole userRole = new MgtEmployeeRole();
				userRole.setRoleId(roleId);
				userRole.setEmployeeId(userId);
				mgtEmployeeRoleDao.save(userRole);
			}
		}
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtEmployee getLoginEmployee(MgtEmployee param) {
		return mgtEmployeeDao.getLoginEmployee(param);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtEmployee findLoginEmployee(MgtEmployee param){
		return mgtEmployeeDao.findLoginEmployee(param);		
	}
	
	@Override
	public MgtEmployee save(MgtEmployee employee, String citySelCode,String[] roleIds,User user1){
//		private BigDecimal orgNo;
//		private BigDecimal comNo;
//		private BigDecimal locNo;
//		/** 用户名 */
//		private String userName;
//		/** 密码 */
//		private BigDecimal userPassword;
//		/**电话**/
//		private String crmTel;
//		/**详细地址*/
//		private String crmAddress1;
//		/**联系人*/
//		private String crmPic;
//		/**联系人电话*/
//		private String crmMobile;
//			/**备注*/
//		private String reMark;
//		
		User user = new User();
		//得到当前用户的信息
		if(StringUtils.isBlank(employee.getId())){

			user = userService.findOrgInfo(user);
		}else{
			//查处其userid
			user=userService.findByUsername(employee.getAccountName());
			
		}
		user.setUserName(employee.getAccountName());
		user.setUserPassword(new BigDecimal(employee.getPassword()));
		user.setCrmTel(employee.getTel());
		user.setCrmMobile(employee.getMobile());
		user.setCrmAddress1(employee.getAddress());
		user.setCrmPic(employee.getUserName());
		user.setRemark(employee.getMemo());
		user.setCreateDate(new Date());
		if(StringUtils.isNotBlank(user1.getRefUserName())){
        user.setRefUserName(user1.getRefUserName());
		}else{
			user.setRefUserName(user1.getUserName());	
		}
		
        user.setName(employee.getUserName());
        user.setUrlAddr(user1.getUrlAddr());
        user.setAreaId(user1.getAreaId());
        user.setCrmCity(user1.getCrmCity());
        user.setCrmState(user.getCrmState());
        user.setShareFlg(user.getShareFlg());
       // user.setCrmAddress1(user1.getCrmAddress1());
       // user.setCrmPic(user1.getCrmPic());
        user.setRemark1(user1.getRemark1());
        user.setRemark4(user1.getRemark4());
//        user.setAltName(user1.getAltName());
        user.setUploadFlg(user1.getUploadFlg());
        user.setRemark2(user1.getRemark2());
        user.setRemark3(user1.getRemark3());
        user.setOrderAmt(user1.getOrderAmt());
        user.setFreight(user1.getFreight());
        user.setRefStatus(user1.getRefStatus());
        user.setRefDate(user1.getRefDate());
        user.setOpenID(user1.getOpenID());
        user.setLatitude(user1.getLatitude());
        user.setLongitude(user1.getLongitude());
        user.setCrmZip(user1.getCrmZip());
        user.setShowFlg(user1.getShowFlg());
        user.setCurrCode(user1.getCurrCode());
        user.setCurrRate(user1.getCurrRate());
        user.setCrmCountry(user1.getCrmCountry());
        user.setCrmFax(user1.getCrmFax());
        
        user.setComFlg("N");
        user.setPublicFlg("N");
        user.setShareFlg("N");
        user.setSalesMenFlg(employee.getSalesmenFlg());
		user.setPurchaserFlg(user1.getPurchaserFlg());
        user.setCharSet("zhs");
        user.setBlockFlg(employee.getBlockFlg());
        user.setGuestFlg("Y");
		user.setLogisticsProviderFlg(employee.getLogisticsProviderFlg());
		user.setPickFlg(employee.getPickFlg());
//		user.setOpcFlg(user1.getOpcFlg());
		userService.save(user);
		
		// 保存用户
		mgtEmployeeDao.save(employee);
		// 保存用户部门中间表
		mgtDepartmentEmployeeDao.deleteByUserId(employee.getId());
			MgtDepartmentUser entity = new MgtDepartmentUser();
			entity.setUserId(employee.getId());
			entity.setDepatementId(citySelCode);
			mgtDepartmentEmployeeDao.save(entity);
			employeeRoleDao.deleteByUser(employee.getId());
			if(null!=roleIds&&roleIds.length>0){
				for(String roleId : roleIds){
				MgtEmployeeRole employeeRole = new  MgtEmployeeRole();
				employeeRole.setRoleId(roleId);
				employeeRole.setEmployeeId(employee.getId());
				employeeRoleDao.save(employeeRole);
				}
				
			}
	 
		return employee;
	}

	@Override
	public MgtEmployee update(MgtEmployee user, String citySel, String citySelCode) {
		// 更新用户信息
		mgtEmployeeDao.save(user);
		String[] citySelCodes = StringUtils.split(citySelCode, ",");
		mgtDepartmentEmployeeDao.deleteByUserId(user.getId());
		for (String code : citySelCodes) {
			MgtDepartmentUser entity = new MgtDepartmentUser();
			entity.setUserId(user.getId());
			entity.setDepatementId(code);
			mgtDepartmentEmployeeDao.save(entity);
		}
		return user;
	}

	@Override
	public Map<String, Object> findRoleResourceByEmployee(MgtEmployee user) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		// 通过用户ID，获取此用户所有角色
		paramMap.put("employeeId", user.getId());
		List<Map<String, Object>> userRoleList = mgtEmployeeRoleDao.findEmployeeRoleByEmployeeId(paramMap);
		if (userRoleList == null || userRoleList.size() <= 0) {
			return null;
		}
		// 将角色ID保存到list中
		List<String> roleIds = new ArrayList<String>();
		String visible = "1";
		resultMap.put(BizConstant.SESSION_USER_SUPER, "0");
		for (int i = (userRoleList.size() - 1); i >= 0; i--) {
			Map<String, Object> userRole = userRoleList.get(i);
			// 超级管理员显示全部的菜单
			if (BizConstant.USER_ACCOUNT.equals(userRole.get("NAME"))
					&& BizConstant.CREATE_BY.equals(userRole.get("CREATE_BY"))) {
				visible = null;
				resultMap.put(BizConstant.SESSION_USER_SUPER, "1");
			}
			MgtRole role = mgtRoleDao.get(userRole.get("ROLE_ID").toString());
			if ("0".equals(role.getStatus())) {
				userRoleList.remove(i);
				continue;
			}
			// userRole.put("role_name", role.getname());
			roleIds.add(userRole.get("ROLE_ID").toString());
		}
		resultMap.put("roles", userRoleList);
		if (null == roleIds || roleIds.size() < 1) {
			return null;
		}
		// 通过角色ID列表获取资源
		List<Map<String, Object>> roleResourceList = mgtRoleResourceDao.findRoleResourceByRoleId(roleIds);
		if (null == roleResourceList || roleResourceList.size() == 0) {
			return null;
		}
		// 通过资源ID列表获取资源对象列表
		String[] resourceIds = new String[roleResourceList.size()];
		for (int i = 0; i < roleResourceList.size(); i++) {
			Map<String, Object> roleResource = roleResourceList.get(i);
			resourceIds[i] = roleResource.get("RESOURCE_ID").toString();
		}

		List<Map<String, Object>> resourceList = mgtResourceDao.findResourceByIds(resourceIds, "1");
		// 获取所有可用的一级菜单
		paramMap.put("visible", "1");
		List<Map<String, Object>> menuList = mgtMenuDao.findByParentId("-1", visible);
		if (null == menuList || menuList.size() <= 0) {
			return null;
		}

		for (int j = (menuList.size() - 1); j >= 0; j--) {
			Map<String, Object> menu = menuList.get(j);
			List<Map<String, Object>> menuItems = new ArrayList<Map<String, Object>>();
			menuItems = mgtMenuDao.findByParentId(menu.get("ID").toString(), visible);
			for (int i = (menuItems.size() - 1); i >= 0; i--) {
				Map<String, Object> menuItem = menuItems.get(i);
				List<Map<String, Object>> resourceItems = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> resource : resourceList) {
					if (menuItem.get("ID").toString().equals(resource.get("MENU_ID"))) {
						resourceItems.add(resource);
					}
				}
				if (null != resourceItems && resourceItems.size() > 0) {
					menuItem.put("resourceItems", resourceItems);
				} else {
					menuItems.remove(i);
				}
			}
			if (null != menuItems && menuItems.size() > 0) {
				menu.put("menuItems", menuItems);
			} else {
				menuList.remove(j);
			}
		}
		if (null == menuList || menuList.size() == 0) {
			return null;
		}
		resultMap.put("menus", menuList);
		return resultMap;
	}
	
	@Override
	public String exist(String accountName) {
		return mgtEmployeeDao.exist(accountName);
	}

	@Override
	public MgtEmployee editPassword(MgtEmployee model, String srcPwd) {
		mgtEmployeeDao.save(model);
		return model;
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Map<String, Object>> findByList(Map<String, Object> paramMap) {
		return mgtEmployeeDao.findByList(paramMap);
	}

	/**
	 * 同步账号信息
	 * @param user
	 */
	public void synchAccount(User user) {
		// 判断用户是否已经存在
		if ("no".equals(mgtEmployeeDao.exist(user.getUserName()))) {
			MgtEmployee emp = new MgtEmployee();
			emp.setAccountName(user.getUserName());
			emp.setEmail(user.getEmail());
			emp.setMerchantCode(user.getUserNo().toString());
			emp.setMobile(user.getCrmMobile());
			emp.setPassword(user.getUserPassword().toString());
			emp.setStatus("1");
			emp.setUserCode(user.getUserName());
			emp.setUserName(user.getName());
			mgtEmployeeDao.save(emp);
			// 设置部门信息
			MgtDepartment department = new MgtDepartment();
			department.setName(emp.getUserName());
			department.setIsStore("0");
			department.setSimpName(emp.getUserName());
			department.setpId("-1");
			department.setStatus("1");
			department.setMemo(emp.getUserName());
			department.setVersion(0);
			department.setMerchantCode(emp.getMerchantCode());
			mgtDepartmentDao.save(department);
			// 用户部门绑定
			MgtDepartmentUser departmentUser = new MgtDepartmentUser();
			departmentUser.setDepatementId(department.getId());
			departmentUser.setUserId(emp.getId());
			departmentUser.setVersion(0);
			mgtDepartmentDao.save(departmentUser);
			// 获取二级角色
			String[] propertyName = { "name", "version" };
			Object[] propertyValue = { "admin", 0 };
			MgtRole role = mgtRoleDao.findUniqueBy(MgtRole.class, propertyName, propertyValue);
			// 赋予权限
			if (role != null && StringUtils.isNotBlank(role.getId())) {
				MgtEmployeeRole employeeRole = new MgtEmployeeRole();
				employeeRole.setRoleId(role.getId());
				employeeRole.setEmployeeId(emp.getId());
				employeeRole.setVersion(0);
				mgtEmployeeRoleDao.save(employeeRole);
			}
		}
	}

	@Override
	public void saveOrUpdate(MgtEmployee paramT) {
		mgtEmployeeDao.save(paramT);
		
	}

	@Override
	public void editStatus(String[] ids) {
		for(String id  : ids){
			MgtEmployee employee = mgtEmployeeDao.get(id);
			employee.setStatus("0");
			mgtEmployeeDao.save(employee);
		}
	}

	@Override
	public List getAll() {
		return mgtEmployeeDao.getAll();
	}

	@Override
	public void editEmployeeDept(String deptId, String[] ids) {
		
		for(String id : ids){
			mgtDepartmentEmployeeDao.deleteByUserId(id);
			MgtDepartmentUser departmentUser = new  MgtDepartmentUser();
			departmentUser.setUserId(id);
			departmentUser.setDepatementId(deptId);
			mgtDepartmentEmployeeDao.save(departmentUser);
			
		}
		
	}

	@Override
	public MgtEmployee findUniqueBy(String propertyName, Object value) {
		return mgtEmployeeDao.findUniqueBy(MgtEmployee.class, propertyName, value);
	}
	/**
     * 根据用户参数查询数据库中的数据
     * @author:lj
     * @date 2015-7-1 下午5:05:48
     * @param param
     * @return
     */
	@Override
    public MgtEmployee findEmployeeByParam(MgtEmployee param){
    	return mgtEmployeeDao.findEmployeeByParam(param);
    }

	@Override
	public void editStatus(JSONObject params) {
			
			MgtEmployee mgtEmployee = mgtEmployeeDao.get(params.getString("id"));
			mgtEmployee.setStatus(params.getString("status"));
			if("0".endsWith(params.getString("status"))){
				mgtEmployee.setBlockFlg("Y");
			}else{
				mgtEmployee.setBlockFlg("N");
			}
			User user = userService.findByUsername(mgtEmployee.getAccountName());
			user.setBlockFlg(mgtEmployee.getBlockFlg());
			mgtEmployeeDao.save(mgtEmployee);
			userService.save(user);
		
	}
	
	@Override
	public void editFlg(JSONObject jobj ,BigDecimal userNo){
		User user = userService.findByUserNo(userNo);
//		MgtEmployee employee = mgtEmployeeService.findUniqueBy("accountName", user.getUserName());
		MgtEmployee employee = mgtEmployeeDao.findUniqueBy(MgtEmployee.class, "accountName", user.getUserName());
		if("Y".equals(jobj.getString("showFlg"))){
			//启用
			user.setShowFlg("Y");
			user.setBlockFlg("N");
			employee.setBlockFlg("N");
			employee.setStatus("1");
		}else{
			//停用
			user.setShowFlg("N");
			user.setBlockFlg("Y");
			employee.setBlockFlg("Y");
			employee.setStatus("0");
		}
//		mgtEmployeeService.saveOrUpdate(employee, null);
		mgtEmployeeDao.save(employee);
		userService.save(user);
	}

	@Override
	public List<MgtEmployee> findEmployeeByMerchantCode(
			List<BigDecimal> merchantCodes) {
		return mgtEmployeeDao.findEmployeeByMerchantCode(merchantCodes);
	}
	
	
}
