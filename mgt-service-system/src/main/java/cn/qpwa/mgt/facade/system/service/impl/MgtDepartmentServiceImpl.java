package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.entity.DepartmentObject;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.LogEnabled;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.mgt.facade.system.service.MgtDepartmentService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门接口实现类
 * 
 */
@Service("mgtDepartmentService")
@Transactional
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtDepartmentServiceImpl implements MgtDepartmentService, LogEnabled {

	@Autowired
	private MgtDepartmentDao mgtDepartmentDao;
	@Autowired
	private MgtDepartmentUserDao mgtDepartmentUserDao;

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtDepartment get(String id) {
		return mgtDepartmentDao.get(id);
	}

	@Override
	public void removeUnused(String id) {
		mgtDepartmentDao.removeById(id);
	}

	@Override
	public void saveOrUpdate(MgtDepartment entity) {
		mgtDepartmentDao.save(entity);

	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		return mgtDepartmentDao.querys(paramMap, orderby);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtDepartment findById(String id) {
		return mgtDepartmentDao.get(id);
	}

	@Override
	public void delete(String[] ids) {
		mgtDepartmentDao.delete(ids);
	}

	@Override
	public List<MgtDepartment> findByParentId(String parentId) {
		return mgtDepartmentDao.findByParentId(parentId);
	}

	public JSONArray findByParentMap(List list) {
		return mgtDepartmentDao.findByParentMap(list);
	}

	@Override
	public DepartmentObject queryForList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		DepartmentObject departmentObject = new DepartmentObject();
		// 根据登录用户查询所属机构
		String employeeId = null;
		if (paramMap.containsKey("employeeId") && StringUtils.isNotBlank(paramMap.get("employeeId").toString())) {
			employeeId = paramMap.get("employeeId").toString();
		}
		List<MgtDepartmentUser> departmentEmployeeList = mgtDepartmentUserDao.findByUserId(employeeId);
		if (departmentEmployeeList != null && departmentEmployeeList.size() > 0) {
			MgtDepartmentUser departmentEmployee = departmentEmployeeList.get(0);
			paramMap.put("pId", departmentEmployee.getDepatementId());
			MgtDepartment department = this.get(departmentEmployee.getDepatementId());
			JSONObject json = new JSONObject();
			json.put("id", department.getId());
			json.put("pId", department.getpId());
			json.put("name", department.getName());
			JSONArray jsonArray = new JSONArray();
			jsonArray.add(json);
			List list = new ArrayList();
			list.add(0, departmentEmployee.getDepatementId());
			if (null != departmentEmployee) {
				jsonArray = this.getDeptName(list, jsonArray);
			}
			departmentObject.setDepartJsonArray(jsonArray);
			System.out.println(departmentObject.getDepartJsonArray().toString());
		}
		return departmentObject;
	}

	public List queryForLists(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		// DepartmentObject departmentObject = new DepartmentObject();
		// 根据登录用户查询所属机构
		String employeeId = null;
		if (paramMap.containsKey("employeeId") && StringUtils.isNotBlank(paramMap.get("employeeId").toString())) {
			employeeId = paramMap.get("employeeId").toString();
		}
		List<MgtDepartmentUser> departmentEmployeeList = mgtDepartmentUserDao.findByUserId(employeeId);
		List array = null;
		if (departmentEmployeeList != null && departmentEmployeeList.size() > 0) {
			MgtDepartmentUser departmentEmployee = departmentEmployeeList.get(0);
			paramMap.put("pId", departmentEmployee.getDepatementId());
			MgtDepartment department = this.get(departmentEmployee.getDepatementId());
			array = new ArrayList();
			array.add(department);
			List pids = new ArrayList();
			pids.add(0, departmentEmployee.getDepatementId());
			if (null != departmentEmployee) {
				array = this.getDeptNames(pids, array);
			}
		}
		return array;
	}

	// 做递归查询
	private List getDeptNames(List pids, List list) {
		List subList = mgtDepartmentDao.findDeptByPids(pids);
		;
		int length = subList.size();
		List searchList = new ArrayList();
		for (int i = 0; i < length; i++) {
			Map obj = (Map) subList.get(i);
			String subPid = obj.get("ID").toString();
			searchList.add(i, subPid);
			list.add(obj);
		}
		if (length > 0) {
			this.getDeptNames(searchList, list);
		}
		return list;
	}

	// 做递归查询
	private JSONArray getDeptName(List list, JSONArray jsonArray) {
		JSONArray subList = this.findByParentMap(list);
		int length = subList.size();
		List searchList = new ArrayList();
		for (int i = 0; i < length; i++) {
			JSONObject jsonObject = (JSONObject) subList.get(i);
			String subPid = jsonObject.getString("ID");
			searchList.add(i, subPid);
			jsonArray.add(jsonObject);
		}
		if (length > 0) {
			this.getDeptName(searchList, jsonArray);
		}
		log.info(jsonArray);
		return jsonArray;
	}

	@Override
	public List<MgtDepartmentUser> findByUserId(String employeeId) {
		return mgtDepartmentUserDao.findByUserId(employeeId);
	}

	/**
	 * 删去部门及其子部门
	 * 
	 * @param
	 * @throws Exception
	 */
	@Override
	public void deleteDept(String code) throws Exception {
		List<MgtDepartment> departmentList = mgtDepartmentDao.findByCode(code);
		if (null != departmentList && departmentList.size() > 0) {
			log.info("删除部门及中间表");
			for (int i = 0; i < departmentList.size(); i++) {
				MgtDepartment department = departmentList.get(i);
				if (null != department) {
					department.setStatus(BizConstant.ORG_STATUS_DELETE);
					mgtDepartmentDao.save(department);

				}
			}
		}
	}

	@Override
	public String exist(String code) {
		return mgtDepartmentDao.findExist(code);
	}

	@Override
	public List<MgtDepartment> getParentDepts(String pid, List<MgtDepartment> depts) {
		MgtDepartment parent = this.findById(pid);
		if (null != parent) {
			if (null == depts) {
				depts = new ArrayList<MgtDepartment>();
			}
			depts.add(parent);
			if (StringUtils.isNotBlank(parent.getpId()) && !"-1".equals(parent.getpId())) {
				this.getParentDepts(parent.getpId(), depts);
			}
		}

		return depts;
	}

	@Override
	public String findExistBySeq(String depId) {
		List list = new ArrayList();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("ID", depId);
		jsonArray.add(jsonObject);
		list.add(0, depId);
		jsonArray = this.getDeptName(list, jsonArray);
		return mgtDepartmentDao.findExistBySeq(jsonArray);
	}

	@Override
	public void saveDep(MgtDepartment department) throws Exception {
		// 保存部门实体
		department.setChannel(BizConstant.DEPTCHANNEL);
		mgtDepartmentDao.save(department);
		log.info("保存部门成功");

	}

	@Override
	public void updateDep(MgtDepartment entity) {
		entity.setChannel(BizConstant.DEPTCHANNEL);
		mgtDepartmentDao.save(entity);
	}
	
	/**
     * 根据分页和查询条件查询部门列表
     * @author:lj
     * @date 2015-6-5 下午1:44:30
     * @param paramMap
     * @param orderby
     * @return
     */
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public PageView queryDepartmentListByPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderBy){
    	if (null != paramMap && paramMap.containsKey("orderby")
				&& ("depart_Code".equals(paramMap.get("orderby").toString())
				|| "".equals(paramMap.get("orderby").toString()))) {
			paramMap.put("orderby", "depart_Code");
		}
			Page page = mgtDepartmentDao.queryDepartmentListByPage(paramMap, orderBy);
			// 拼装分页信息
			PageView result = new PageView(SystemContext.getPagesize(),
					SystemContext.getOffset());
			result.setQueryResult(page);
			return result;
    }

	 /**
     * 根据商家编号上级部门
     * @author:lj
     * @date 2015-6-8 上午10:31:33
     * @param merchantCode
     * @return
     */
	@Override
    public String findParentIdByMerchantCode(String merchantCode){
    	return mgtDepartmentDao.findParentIdByMerchantCode(merchantCode);
    }
	/**
     * 根据主键id删除部门
     * @author:lj
     * @date 2015-6-8 下午2:06:34
     * @param id
     */
    public void deleteDepartmentById(String id){
    	mgtDepartmentDao.deleteDepartmentById(id);
    }

    /**
     * 根据用户查询部门
     */
	@Override
	public List<MgtDepartment> findDepartmentByEmployeeId(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		String employeeId = null;
		if (paramMap.containsKey("employeeId") && StringUtils.isNotBlank(paramMap.get("employeeId").toString())) {
			employeeId = paramMap.get("employeeId").toString();
		}
		List<MgtDepartmentUser> departmentEmployeeList = mgtDepartmentUserDao.findByUserId(employeeId);
		List<MgtDepartment> departments = new ArrayList<MgtDepartment>();
		for (MgtDepartmentUser mgtDepartmentUser : departmentEmployeeList) {
			if(StringUtils.isNotBlank(mgtDepartmentUser.getDepatementId())){
				MgtDepartment department = this.get(mgtDepartmentUser.getDepatementId());
				departments.add(department);
			}
		}
		return departments;
	}
    
    
}