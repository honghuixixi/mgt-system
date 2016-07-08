package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.mgt.web.system.handler.MultiViewResource;
import cn.qpwa.mgt.facade.system.service.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.web.vo.UserVO;
import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.constant.GlobalConstant;
import cn.qpwa.common.utils.file.FileAttach;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import net.sf.json.JSONObject;
import org.apache.commons.fileupload.util.Streams;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.*;

/**
 * 用户视图展示类
 * 
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/employee")
@SuppressWarnings("all")
public class EmployeeController extends MultiViewResource{

	@Autowired
	private MgtEmployeeService mgtEmployeeService;
	@Autowired
	private MgtRoleService mgtRoleService;
	@Autowired
	private MgtResourceService mgtResourceService;
	@Autowired
	private MgtMenuService mgtMenuService;
	@Autowired
	private MgtDepartmentService mgtDepartmentService;
	@Autowired
	private MgtDepartmentUserService departmentUserService;
	@Autowired
	private WhMasService whMasService;
	@Autowired
	private UserService userService;
	@Autowired
	private RSAService rsaService;
	@Autowired
	private UserWhService userWhService;

	LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();

	/**
	 * 获取用户信息页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "employeeInfo")
	public String employeeInfo() {
		return super.getUrl("mgt.employeeinfo");
	}

	/**
	 * 获取用户列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "employeeList")
	@ResponseBody
	public Object employeeList(ModelMap modelMap, final HttpServletRequest httpRequest, HttpServletResponse response) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
//		/* 排序 */
//		if (StringUtils.isNotBlank(jsonObject.getString("orderby"))
//				&& StringUtils.isNotBlank(jsonObject.getString("sord"))) {
//			orderby.put(
//					"STATUS".equals(jsonObject.getString("orderby")) ? "t.STATUS" : jsonObject.getString("orderby"),
//					jsonObject.getString("sord"));
//		}
		jsonObject.put("loginEmployeeId", WebUtils.getSessionUser().getId());
		jsonObject.put("merchantCode", WebUtils.getSessionUser().getMerchantCode());
		List<String> notUserIds = new ArrayList();
		MgtEmployee me = new MgtEmployee();
//		me.setAccountName(WebUtils.getSessionUser().getAccountName());
//		me = mgtEmployeeService.findEmployeeByParam(me);
//		notUserIds.add(me.getId());
		if("0".equals(WebUtils.getSession().getAttribute(BizConstant.SESSION_USER_SUPER))){
			if(!WebUtils.getSessionUser().getAccountName().equals(WebUtils.getSessionUser().getMerchantUserName())){
				me.setAccountName(WebUtils.getSessionUser().getMerchantUserName());
				me = mgtEmployeeService.findEmployeeByParam(me);
				notUserIds.add(me.getId());
				jsonObject.put("notUserIds", notUserIds);
			}
		}
		Page page = mgtEmployeeService.querys(jsonObject, orderby);
		PageView<MgtEmployee> pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(
				jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 用户列表信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "employeeListUI")
	public ModelAndView employeeListUI(ModelMap modelMap) {
		Page page = mgtEmployeeService.querys(jsonObject, null);
		// 菜单列表视图
		PageView<Map<String, Object>> pageView = new PageView<Map<String, Object>>(SystemContext.getPagesize(),
				SystemContext.getOffset());
		pageView.setQueryResult(page);
		pageView.setJsMethod("reloadEmployeeList");
		modelMap.put("pageView", pageView);
		return super.toView(super.getUrl("employee.EmployeeListUI"));
	}

	/**
	 * 转为员工页面
	 * 
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "addCustomerList")
	public String addCustomerList(ModelMap modelMap) {
		// Department
		// department=departmentService.findById(getJsonObject().getString("departmentId"));
		// modelMap.addAttribute("department", department);
		// modelMap.addAttribute("departmentId", department.getId());
		return getUrl("mgt.addCustomerList");
	}

	/**
	 * 用户表格展示
	 * 
	 * @param request
	 * @param modelMap
	 * @return
	 */
	// @RequestMapping(value = "employeeListGrid")
	// public ModelAndView employeeListGrid(ModelMap modelMap) {
	// Page page = employeeService.querys(getJsonObject(),null);
	// // 菜单列表视图
	// PageView<Map<String, Object>> pageView = new PageView<Map<String,
	// Object>>(
	// SystemContext.getPagesize(), SystemContext.getOffset());
	// pageView.setQueryResult(page);
	// pageView.setJsMethod("reloadEmployeeList");
	// modelMap.put("pageView", pageView);
	// return toView(getUrl("employee.employeeListGrid"), modelMap);
	// }

	/**
	 * 跳转用户添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addEmployeeUI")
	public String addEmployeeUI(ModelMap modelMap) {
		Map<String,Object> paramMap = new HashMap<String, Object>();
		UserVO user = WebUtils.getSessionUser();
		paramMap.put("visible", "1");
		paramMap.put("merchantCode", user.getMerchantCode());
		List list = mgtRoleService.findByAll(paramMap);
		modelMap.addAttribute("roleList", list);
		return getUrl("mgt.addEmployeeUI");
	}
	@RequestMapping(value = "employeeLists", method = RequestMethod.POST)
	@ResponseBody
	public Msg employeeLists(final ModelMap modelMap) {
		Msg msg = new Msg();
		if (null != jsonObject) {
			try {
				List list = mgtEmployeeService.getAll();
				msg.setData(list);
				msg.setSuccess(true);
				msg.setMsg("获取所有部门成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("查询失败，请联系管理员！");
			}
		} else {
			msg.setMsg("查询失败，请联系管理员！");
		}
		return msg;
	}

	//
	// /**
	// * 会员转为用户界面
	// * @return
	// */
	// @RequestMapping(value = "addEmployeeCustomUI")
	// public String addEmployeeCustomUI(ModelMap modelMap,String
	// departmentId,String customId) {
	// // Department department=departmentService.findById(departmentId);
	// Customer customer = customerService.get(customId);
	// // modelMap.addAttribute("department", department);
	// modelMap.addAttribute("customer",customer);
	// // modelMap.addAttribute("departmentId", department.getId());
	// return getUrl("mgt.addEmployeeCustomUI");
	//
	// }

	/**
	 * 保存用户信息
	 * 
	 * @param MgtEmployee
	 * @return
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(ModelMap modelMap, HttpServletRequest request) {
		Msg msg = new Msg();
		if (null != jsonObject ) {
			try {
				MgtEmployee emp = JSONTools.JSONToBean(jsonObject, MgtEmployee.class);
				String exist = mgtEmployeeService.exist(emp.getAccountName());
				User user = userService.findByUsername(emp.getAccountName());
				if ("yes".equals(exist)||null!=user) {
					msg.setCode("EmployeeNumberIsExist");
					msg.setData("登录账户已经存在！");
					return msg;
				} 
				MgtEmployee emp1 = mgtEmployeeService.findUniqueBy("mobile", emp.getMobile());
				if(null!=emp1){
					msg.setCode("EmployeeMobileIsExist");
					msg.setData("手机号码已经存在！");
					return msg;
				}
				MgtEmployee emp2 = mgtEmployeeService.findUniqueBy("userCode", emp.getUserCode());
				if(null!=emp2){
					msg.setCode("EmployeeUserCodeIsExist");
					msg.setData("用户编号已经存在！");
					return msg;
				}
				else {
					emp.setCreateBy(WebUtils.getSessionUser().getId());
					//明文密码转暗文密码
					BigDecimal pass = userService.getPassword(emp.getPassword());
					emp.setPassword(pass.toString());
					emp.setCreateDate(new Date());
					emp.setMerchantCode(WebUtils.getSessionUser().getMerchantCode());
					if(StringUtils.isBlank(emp.getMerchantCode())){
						emp.setMerchantCode(WebUtils.getSessionUser().getAccountName());
					}
					emp.setPId(jsonObject.getString("citySelCode1"));
					String[] roleIds=null;
					if(jsonObject.containsKey("roleIds")){
						
						roleIds = StringUtils.split(jsonObject.getString("roleIds"),",");
					}
					List<FileAttach> files = getfiles();
					if(null!=files&&files.size()>0){
					FileAttach fileItem = files.get(0);
					String fileName = upload(fileItem);
					emp.setPicUrl(fileName);
					}
					 String citySelCode = jsonObject.getString("citySelCode"); 
						if(StringUtils.isBlank(citySelCode)){
							citySelCode = departmentUserService.findDepartmentIdByUserId(WebUtils.getSessionUser().getId());
						}
					//获取当前用户的信息
					String username=WebUtils.getSessionUser().getAccountName();
					User user1=userService.findByUsername(username);
					if("1".equals(emp.getStatus())){
						emp.setBlockFlg("N");
					}else{
						emp.setBlockFlg("Y");
					}
//					if(StringUtils.isNotBlank(WebUtils.getSessionUser().getMerchantUserName())){
//						User user2=userService.findByUsername(WebUtils.getSessionUser().getMerchantUserName());
//						user1.setOpcFlg(user2.getOpcFlg());
//					}
					emp = mgtEmployeeService.save(emp, citySelCode, roleIds,user1);
//					mgtEmployeeService.saveOrUpdate(emp);
				}
				msg.setMsg("保存成功！");
				msg.setSuccess(true);
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("保存失败，请联系管理员！");
			}
		} else {
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 保存会员用户信息
	 * 
	 * @param addCustomEmployee
	 * @return
	 */
	// @RequestMapping(value = "addCustomEmployee",method=RequestMethod.POST)
	// @ResponseBody
	// public Msg addCustomEmployee(ModelMap modelMap,final HttpServletRequest
	// httpRequest,HttpServletResponse response) {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// Employee employee = JSONTools.JSONToBean(getJsonObject(),
	// Employee.class);
	// try {
	//
	// String exist = employeeService.exist(employee.getAccountName());
	// if("yes".equals(exist))
	// {
	// msg.setCode("EmployeeNumberIsExist");
	// msg.setData("登录账户已经存在！");
	// //Assert.isTrue(true, "部门编号已经存在！");
	// } else {
	// Employee localEmployee = EmployeeUtils.getEmployee(httpRequest);
	// // employee.setMerchantId(localEmployee.getMerchantId());
	// employee.setCreateBy(localEmployee.getId());
	// employee.setCreateDate(new Date());
	// employee = employeeService.save(employee,
	// getJsonObject().getString("citySel"),
	// getJsonObject().getString("citySelCode"));
	// Date date = new Date();
	// JSONObject json=new JSONObject();
	// json.put("EmployeeId", employee.getId());
	// json.put("name", employee.getUserName());
	// // json.put("enterpriseCode",employee.getMerchantId());
	// json.put("account", employee.getAccountName());
	// json.put("password", employee.getPassword());
	// json.put("email", employee.getEmail());
	// json.put("status", employee.getStatus());
	// json.put("sex", employee.getSex());
	// json.put("mobilePhone", employee.getMobile());
	// json.put("createBy", employee.getCreateBy());
	// json.put("createDate",DateUtil.toDatetimeString(employee.getCreateDate()));
	// // JSONObject js = EmployeeUtils.getUcAuthJson(json);
	// // try {
	// //
	// HttpUtil.postJsonRequest(PropertiesLoader.getProperty("system.ucAuth.host")+PropertiesLoader.getProperty("system.ucAuth.addEmployeeAndAccount"),
	// js.toString());
	// // } catch (Exception e) {
	// // Assert.isTrue(true,"同步数据到用户中心出错!");
	// // }
	// }
	// } catch (Exception e) {
	// Assert.isTrue(true,"同步数据到用户中心出错!");
	// }
	// msg.setMsg("保存成功！");
	// }
	// });
	// }

	/**
	 * 保存用户角色信息
	 * 
	 * @param MgtEmployee
	 * @return
	 */
	@RequestMapping(value = "addEmployeeRole", method = RequestMethod.POST)
	@ResponseBody
	public Msg addEmployeeRole() {
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("employeeId"))) {
			try {
				mgtRoleService.saveEmployeeRole(jsonObject);
				msg.setSuccess(true);
				msg.setMsg("保存成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("保存失败，请联系管理员！");
			}
		} else {
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 更新用户界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "editEmployeeUI")
	public String editEmployeeUI(ModelMap modelMap,HttpServletRequest request) {
		MgtEmployee employee = mgtEmployeeService.findById(jsonObject.getString("id"));
		User user = userService.findByUsername(employee.getAccountName());

		List<MgtDepartmentUser> departmentUserList = mgtDepartmentService.findByUserId(employee.getId());
		String departmentId = "";
		String departmentName = "";
		for (MgtDepartmentUser departmentUser : departmentUserList) {
			MgtDepartment department = new MgtDepartment();
			if(StringUtils.isNotBlank(departmentUser.getDepatementId())){
				department = mgtDepartmentService.get(departmentUser.getDepatementId());
				modelMap.addAttribute("department", department);
				departmentId += (department.getId() + ",");
				departmentName += (department.getName() + ",");
			}
		}
		if (StringUtils.isNotBlank(departmentName)) {
			departmentName = departmentName.substring(0, departmentName.length() - 1);
			departmentId = departmentId.substring(0, departmentId.length() - 1);

		}
		if(StringUtils.isNotBlank(employee.getPId())){
		MgtEmployee parentEmployee = mgtEmployeeService.findById(employee.getPId());
		modelMap.addAttribute("parentEmployee", parentEmployee);
		}
		List employeeRoleList = mgtRoleService.findEmployeeRoleByEmployeeId(employee.getId());
		Map<String,Object> paramMap = new HashMap<String, Object>();
		UserVO userVo = WebUtils.getSessionUser();
		paramMap.put("visible", "1");
		paramMap.put("merchantCode", userVo.getMerchantCode());
		List roleList = mgtRoleService.findByAll(paramMap);
		modelMap.addAttribute("employeeRoleList", employeeRoleList);
		modelMap.addAttribute("departmentId", departmentId);
		modelMap.addAttribute("departmentName", departmentName);
		modelMap.addAttribute("employee", employee);
		modelMap.addAttribute("roleList", roleList);
		if(null==user){
			user = new User();
		}
		modelMap.addAttribute("scuser", user);
		return getUrl("mgt.editEmployeeUI");
	}
	@RequestMapping(value = "editEmployeeDeptUI")
	public String editEmployeeDeptUI(ModelMap modelMap,String id) {
	 
		modelMap.addAttribute("ids", id);
		return getUrl("mgt.editEmployeeDeptUI");
	}

	/**
	 * 设置用户角色界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "addEmployeeRoleUI")
	public ModelAndView addEmployeeRoleUI(ModelMap modelMap) {
		List employeeRole = mgtRoleService.findEmployeeRoleByEmployeeId(jsonObject.getString("id"));
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("status", "1");
//		paramMap.put("employeeId", WebUtils.getSessionUser().getId());
		if (StringUtils.isNotBlank(WebUtils.getSessionUser().getMerchantCode()))
			paramMap.put("merchantCode", WebUtils.getSessionUser().getMerchantCode());
		List roleList = mgtRoleService.findByList(paramMap);

		modelMap.addAttribute("employeeRoleList", employeeRole);
		modelMap.addAttribute("roleList", roleList);
		modelMap.addAttribute("employeeId", jsonObject.getString("id"));
		/**
		 * 对于刚创建的用户，角色可能为空，这里需要判断。如果用户角色不为空，查询角色下相应的权限
		 */
		if(employeeRole!=null && employeeRole.size()>0){
		//根据角色查询用户对应的所有权限（菜单和资源）
			List<String> roleIds = new ArrayList<String>(roleList.size());
			for (int i=0;i<employeeRole.size();i++) {
				Map role = (Map)employeeRole.get(i);
				roleIds.add(role.get("ROLE_ID").toString());
			}
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("roleIds", roleIds);
			param.put("status", "1");
			 //查询用户角色下所有的资源
	        List  resourceList= mgtResourceService.queryResourceListByRoleIds(param);
	        if(resourceList !=null && resourceList.size()>0){
	        	modelMap.addAttribute("resourceList", resourceList);
	        }
	        //查询用户角色下所有的菜单
	        List menuList = mgtMenuService.queryMenuListByRoleIds(param);
	       
	        /****设置角色菜单为空的显示start****/
	        if(menuList != null && menuList.size()>0){
	        	//循环取出找到没有菜单的角色，赋予空值。
		        List<String> menuRoleIds = new ArrayList<String>();
		        String menuRoleId = "";
		        for(int i=0;i<menuList.size();i++){
		        	Map menuRole = (Map)menuList.get(i);
		        	if(i==0){
		        		menuRoleId = menuRole.get("ROLE_ID").toString();
		        	}else{
		        		if(!menuRoleId.equals(menuRole.get("ROLE_ID").toString())){
		        			menuRoleIds.add(menuRoleId);
		        			menuRoleId = menuRole.get("ROLE_ID").toString();
		        		}
		        		if(i==(menuList.size()-1)){
		        			menuRoleIds.add(menuRoleId);
		        		}
		        	}        	
		        }
		        //删除有菜单的角色id，留下的都是没有菜单的角色id
		        roleIds.removeAll(menuRoleIds);
		        //赋予空值
		        if(roleIds!=null && roleIds.size()>0){
		
		            for(String roleId:roleIds){
		                Map map = new HashMap();
		                MgtRole role = mgtRoleService.findById(roleId);
		                map.put("ROLE_NAME",role.getName());
		                map.put("ROLE_ID",roleId);
		                map.put("NAME",null);
		                map.put("ID",null);
		                menuList.add(map);
		            }
		
		        }
		        /****设置角色菜单为空的显示end****/
				modelMap.addAttribute("menuList", menuList);
	        }
	        
		}
		return super.toView(super.getUrl("mgt.addEmployeeRoleUI"));
	}

	/**
	 * 更新用户信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	@ResponseBody
	public Msg edit(HttpServletRequest request, ModelMap modelMap) {
		 
		Msg msg = new Msg();
		if (jsonObject != null) {
			try {
				MgtEmployee employeeVO = JSONTools.JSONToBean(jsonObject, MgtEmployee.class);
				// 只修改用户数据，防止数据丢失。
				MgtEmployee srcEmployee = mgtEmployeeService.findById(employeeVO.getId());
				if(!srcEmployee.getPassword().equals(employeeVO.getPassword())){
					BigDecimal pass = userService.getPassword(employeeVO.getPassword());
					srcEmployee.setPassword(pass.toString());
				}
				srcEmployee.setAccountName(employeeVO.getAccountName());
				srcEmployee.setStatus(employeeVO.getStatus());
				srcEmployee.setUserName(employeeVO.getUserName());
				srcEmployee.setSex(employeeVO.getSex());
				srcEmployee.setUserCode(employeeVO.getUserCode());
				srcEmployee.setEmail(employeeVO.getEmail());
				srcEmployee.setMobile(employeeVO.getMobile());
				srcEmployee.setTel(employeeVO.getTel());
				srcEmployee.setAddress(employeeVO.getAddress());
				srcEmployee.setMemo(employeeVO.getMemo());
				srcEmployee.setIdentityCard(employeeVO.getIdentityCard());
				srcEmployee.setBirthday(employeeVO.getBirthday());
				srcEmployee.setPId(jsonObject.getString("citySelCode1"));
				srcEmployee.setUpdateBy(WebUtils.getSessionUser().getId());
				srcEmployee.setLogisticsProviderFlg(employeeVO.getLogisticsProviderFlg());
				srcEmployee.setSalesmenFlg(employeeVO.getSalesmenFlg());
				srcEmployee.setPickFlg(employeeVO.getPickFlg());
				if("1".equals(srcEmployee.getStatus())){
					srcEmployee.setBlockFlg("N");
				}else{
					srcEmployee.setBlockFlg("Y");
				}
				String[] roleIds=null;
				if(jsonObject.containsKey("roleIds")){
					
					roleIds = StringUtils.split(jsonObject.getString("roleIds"),",");
				}
				List<FileAttach> files = getfiles();
				if(null!=files&&files.size()>0){
				FileAttach fileItem = files.get(0);
				String fileName = upload(fileItem);
				srcEmployee.setPicUrl(fileName);
				}
				 String citySelCode = jsonObject.getString("citySelCode"); 
					if(StringUtils.isBlank(citySelCode)){
						citySelCode = departmentUserService.findDepartmentIdByUserId(WebUtils.getSessionUser().getId());
					}
					//获取当前用户的信息
				String username=WebUtils.getSessionUser().getAccountName();
				User user1=userService.findByUsername(username);
				srcEmployee = mgtEmployeeService.save(srcEmployee, citySelCode, roleIds,user1);
//				mgtEmployeeService.saveOrUpdate(srcEmployee,citySelCode);
				msg.setSuccess(true);
				msg.setMsg("修改成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("修改失败，请联系管理员！");
			}
		} else {
			msg.setMsg("修改失败，请联系管理员！");
		}
		return msg;
	}
	@RequestMapping(value = "editEmployeeDept", method = RequestMethod.POST)
	@ResponseBody
	public Msg editEmployeeDept(ModelMap modelMap,String citySelCode,String[] ids) {
		Msg msg = new Msg();
		if (jsonObject != null) {
			try {
				mgtEmployeeService.editEmployeeDept(citySelCode, ids);
				msg.setSuccess(true);
				msg.setMsg("修改成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("修改失败，请联系管理员！");
			}
		} else {
			msg.setMsg("修改失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 设置用户角色界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "addUserWhMasUI")
	public String addUserWhMasUI(ModelMap modelMap) {
		String merchantCode = WebUtils.getSessionUser().getMerchantCode();
		String username = null;
		if(merchantCode == null){
			username = "";
		}else{
		User user = userService.findByUserNo(new BigDecimal(WebUtils.getSessionUser().getMerchantCode()));
		username = user.getUserName();
		modelMap.addAttribute("username", username);
		}
		List whMasList =  whMasService.findByWhTypeList(username);
		//设置user_wh表里的user_name字段
		MgtEmployee employee = mgtEmployeeService.get(jsonObject.getString("id"));
		List userWhList = userWhService.findUserWhByUsername(employee.getAccountName());
		modelMap.addAttribute("whMasList", whMasList);
		modelMap.addAttribute("userWhList", userWhList);
		modelMap.addAttribute("employeeId", jsonObject.getString("id"));
		return getUrl("mgt.addUserWhMasUI");
	}
	
	@RequestMapping(value = "addUserWhMas", method = RequestMethod.POST)
	@ResponseBody
	public Msg addUserWhMas() {
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("employeeId"))) {
			try {
				userWhService.saveUserWh(jsonObject);
				if(jsonObject.get("whMasIds")!= null){
					String[] whMasIds = StringUtils.split(jsonObject.get("whMasIds").toString(), ",");
					String whC = whMasIds[0];
//					MgtEmployee param = new MgtEmployee();
//					param.setId(jsonObject.get("employeeId").toString());
					MgtEmployee param=mgtEmployeeService.get(jsonObject.get("employeeId").toString());
					param.setWhC(whC);
					mgtEmployeeService.saveOrUpdate(param);
					if(WebUtils.getSessionUser().getAccountName().equals(param.getAccountName())){
						WebUtils.getSessionUser().setWhC(whC);
					}
				}
				msg.setSuccess(true);
				msg.setMsg("保存成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("保存失败，请联系管理员！");
			}
		} else {
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}
	
	/**
	 * 打开查询界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	// @RequestMapping(value = "selectById",method=RequestMethod.POST)
	// @ResponseBody
	// public Msg selectById() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// //判断传递参数是否为null
	// Assert.isTrue(null != getJsonObject(),"打开查询界面失败！");
	//
	// Employee employee =
	// employeeService.findById(getJsonObject().getString("id"));
	// msg.setData(employee);
	// }
	// });
	// }

	/**
	 * 删去用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Msg delete() {
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				String ids = jsonObject.getString("id");
				String[] idArray = ids.split(",");
				mgtEmployeeService.delete(idArray);
				msg.setSuccess(true);
				msg.setMsg("删除成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("删除失败，请联系管理员！");
			}
		} else {
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg;
	}
	/**
	 * 停用
	 * @return
	 */
	@RequestMapping(value = "editStatus", method = RequestMethod.POST)
	@ResponseBody
	public Msg editStatus( ) {
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				mgtEmployeeService.editStatus(getJsonObject());
				msg.setSuccess(true);
				msg.setMsg("设置成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("设置失败，请联系管理员！");
			}
		} else {
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg;
	}
	

	public String upload(FileAttach fileAttach) {
		String filePathName=null;
		String type = "icon";
		// 图片保存目录
		String rootDir = "D:"+ File.separator+"nginx"+ File.separator+"ROOT"  + File.separator +  GlobalConstant.UPLOAD_MICROSHOP;
		String pathDir = "";
		try {
			if (StringUtils.isNotBlank(type)
					&& (GlobalConstant.ICON.equals(type) || GlobalConstant.THUMBNAIL.equals(type) || GlobalConstant.DETAIL
							.equals(type))) {
				pathDir = rootDir + File.separator + type;
			} else {
				return null;
			}
				// 获取文件名
				String fileName = fileAttach.getFileName();
				if (StringUtils.isBlank(fileName)) {
					return null;
				}
				// 获取图片的扩展名
				String extensionName = fileName.substring(fileName.lastIndexOf(".") + 1);
				// 新的图片文件名
				String newFileName = UUID.randomUUID() + "." + extensionName;
				pathDir+= (File.separator+newFileName);
				File imgFile = new File(pathDir);
				imgFile.createNewFile();
				// 完整文件名
				 OutputStream out = new  FileOutputStream(imgFile);
				 Streams.copy(fileAttach.getInputStream(), out, true);
				 return newFileName;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 查询用户角色信息
	 * 
	 * @return
	 */
	// @RequestMapping(value = "selectEmployeeRole")
	// @ResponseBody
	// public Msg selectEmployeeRole(final ModelMap modelMap) {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	//
	// //判断参数是否为空
	// Assert.isTrue(null != getJsonObject(),"查询用户角色失败！");
	// List<Map<String,Object>>
	// EmployeeRole=roleService.findEmployeeRoleByEmployeeId(getJsonObject().getString("id"));
	// List employeeRoleList=new ArrayList();
	// for(Map<String,Object> EmployeeRoles :EmployeeRole ){
	//
	// employeeRoleList.add(roleService.get(EmployeeRoles.get("role_id").toString()));
	// }
	// Map<String,Object> paramMap=new HashMap<String, Object>();
	// paramMap.put("status", "1");
	// List roleList=roleService.findByList(paramMap);
	// modelMap.addAttribute("EmployeeRoleList", EmployeeRole);
	// modelMap.addAttribute("roleList", roleList);
	// modelMap.addAttribute("EmployeeId", getJsonObject().getString("id"));
	// Map<String,Object> jsonObject=new HashMap<String,Object>();
	// jsonObject.put("left", roleList);
	// jsonObject.put("right", employeeRoleList);
	//
	// msg.setData(jsonObject);
	// msg.setMsg("查询成功！");
	// }
	// });
	// }

	/**
	 * 用户角色设置
	 * 
	 * @return
	 */
	// @RequestMapping(value = "saveEmployeeRole",method=RequestMethod.POST)
	// @ResponseBody
	// public Msg saveEmployeeRole() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// System.out.println(getJsonObject());
	// //判断参数是否为空
	// Assert.isTrue(null != getJsonObject(),"用户角色设置失败！");
	// employeeService.saveEmployeeRole(getJsonObject());
	// msg.setMsg("用户角色设置成功！");
	// }
	// });
	// }

	// @RequestMapping(value = "findEmployeeAccountExist")
	// @ResponseBody
	// public Msg findEmployeeAccountExist() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// String exist =
	// employeeService.exist(getJsonObject().getString("accountName"));
	// JSONObject jsonObject = new JSONObject();
	// jsonObject.put("code", exist);
	// msg.setData(jsonObject);
	// }
	// });
	//
	// }

	/**
	 * 个人中心页面
	 * 
	 * @return
	 */
	// @RequestMapping(value = "employeeCenter")
	// public String employeeCenter(ModelMap modelMap,HttpServletRequest
	// request) {
	// Employee Employee = EmployeeUtils.getEmployee(request);
	// if(null!=Employee){
	// Employee model = employeeService.findById(Employee.getId());
	// modelMap.addAttribute("employee", model);
	// }
	// return getUrl("mgt.employeeCenter");
	// }

	/**
	 * 个人信息修改
	 * 
	 * @return
	 */
	// @RequestMapping(value = "employeeCenterUpdate")
	// public String employeeCenterUpdate(ModelMap modelMap,HttpServletRequest
	// request) {
	// Employee employee = JSONTools.JSONToBean(getJsonObject(),
	// Employee.class);
	// if(null!=employee&&StringUtils.isNotBlank(employee.getId())){
	//
	// Employee model = employeeService.findById(employee.getId());
	// if(null!=model){
	// model.setUserName(employee.getUserName());
	// model.setEmail(employee.getEmail());
	// model.setMobile(employee.getMobile());
	// model.setSex(employee.getSex());
	// employeeService.saveOrUpdate(model);
	//
	// // JSONObject json= EmployeeUtils.getSyncEmployeeJson(model);
	// // json = EmployeeUtils.getUcAuthJson(json);
	// // try {
	// //
	// HttpUtil.postJsonRequest(PropertiesLoader.getProperty("system.ucAuth.host")+PropertiesLoader.getProperty("system.ucAuth.modifyEmployeeAndAccount"),
	// json.toString());
	// // } catch (Exception e) {
	// // Assert.isTrue(true,"同步数据到用户中心出错!");
	// // }
	//
	// }
	//
	// }
	//
	// return this.employeeCenter(modelMap, request);
	//
	// }

	/**
	 * 修改密码页面
	 * 
	 * @return
	 */
	// @RequestMapping(value = "editPassword")
	// public String editPassword(ModelMap modelMap,HttpServletRequest request)
	// {
	// Employee Employee = EmployeeUtils.getEmployee(request);
	// if(null!=Employee){
	// Employee model = employeeService.findById(Employee.getId());
	// modelMap.addAttribute("employee", model);
	// }
	// return getUrl("mgt.editPassword");
	// }

	/**
	 * 修改密码操作
	 * 
	 * @return
	 */
	// @RequestMapping(value = "editPasswordDo")
	// public String editPasswordDo(ModelMap modelMap,HttpServletRequest
	// request) {
	//
	// String id = JSONTools.getString(getJsonObject(), "id");
	// String passwordSource = JSONTools.getString(getJsonObject(),
	// "passwordSource");
	// String password = JSONTools.getString(getJsonObject(), "password");
	//
	// if(StringUtils.isNotBlank(id)){
	// Employee model = employeeService.findById(id);
	// if(null!=model){
	// if(model.getPassword().equals(passwordSource)){
	// model.setPassword(password);
	// Employee backEmployee =
	// employeeService.editPassword(model,passwordSource);
	// if(null!=backEmployee){
	// modelMap.addAttribute("errorinfo", "修改成功");
	// }else{
	// modelMap.addAttribute("errorinfo", "修改失败");
	// }
	// }else{
	// modelMap.addAttribute("errorinfo", "修改失败，原密码错误");
	// }
	// }
	// }
	// return this.editPassword(modelMap, request);
	// }
	
	/**
	 * 分配角色并查询菜单
	 * @author:lj
	 * @date 2015-6-10 下午1:52:55
	 */
	@RequestMapping(value = "assignRole")
	@ResponseBody
	public Object assignRole(final ModelMap modelMap){
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("roleId"))) {
			try {
				
				List roleIds = new ArrayList();
				roleIds.add(jsonObject.getString("roleId"));
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("roleIds", roleIds);
				param.put("status", "1");
				//查询用户角色下所有的资源
				List  resourceList= mgtResourceService.queryResourceListByRoleIds(param);
				//查询用户角色下所有的菜单
				List menuList = mgtMenuService.queryMenuListByRoleIds(param);
				modelMap.addAttribute("resourceList", resourceList);
				modelMap.addAttribute("menuList", menuList);
                JSONObject json = new JSONObject();
                json.put("resourceList",resourceList);
                json.put("menuList",menuList);
                msg.setData(json);
				msg.setMsg("查询成功！");
				msg.setCode("001");
				msg.setSuccess(true);
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("保询失败，请联系管理员！");
			}
		} else {
			msg.setMsg("查询失败，请联系管理员！");
		}
	    return msg.toJSONObject("yyyy-MM-dd").toString();
	}
	/**
	 * 用户个人信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "employeeInfos")
	public String employeeInfos(ModelMap modelMap,HttpServletRequest request){
		WebUtils.getSessionUser().getId();
		System.out.println(WebUtils.getSessionUser().getId());
		MgtEmployee employee = mgtEmployeeService.findById(WebUtils.getSessionUser().getId());
		User user = userService.findByUsername(employee.getAccountName());

		List<MgtDepartmentUser> departmentUserList = mgtDepartmentService.findByUserId(employee.getId());
		String departmentId = "";
		String departmentName = "";
		for (MgtDepartmentUser departmentUser : departmentUserList) {
			MgtDepartment department = new MgtDepartment();
			if(StringUtils.isNotBlank(departmentUser.getDepatementId())){
				department = mgtDepartmentService.get(departmentUser.getDepatementId());
				modelMap.addAttribute("department", department);
				departmentId += (department.getId() + ",");
				departmentName += (department.getName() + ",");
			}

		}
		if (StringUtils.isNotBlank(departmentName)) {
			departmentName = departmentName.substring(0, departmentName.length() - 1);
			departmentId = departmentId.substring(0, departmentId.length() - 1);

		}
		if(StringUtils.isNotBlank(employee.getPId())){
		MgtEmployee parentEmployee = mgtEmployeeService.findById(employee.getPId());
		modelMap.addAttribute("parentEmployee", parentEmployee);
		}
		List employeeRoleList = mgtRoleService.findEmployeeRoleByEmployeeId(employee.getId());
		Map<String,Object> paramMap = new HashMap<String, Object>();
		UserVO userVo = WebUtils.getSessionUser();
		paramMap.put("visible", "1");
		paramMap.put("merchantCode", userVo.getMerchantCode());
//		List roleList = mgtRoleService.findByAll(paramMap);
		modelMap.addAttribute("employeeRoleList", employeeRoleList);
		modelMap.addAttribute("departmentName", departmentName);
		modelMap.addAttribute("employee", employee);
//		modelMap.addAttribute("roleList", roleList);
		if(null==user){
			user = new User();
		}
		

        MgtEmployee paramEmployee = new MgtEmployee();
//        UserVO user = WebUtils.getSessionUser();
        paramEmployee.setAccountName(WebUtils.getSessionUser().getAccountName());
        paramEmployee.setMerchantCode(WebUtils.getSessionUser().getMerchantCode());
        MgtEmployee mgtEmployee =  mgtEmployeeService.findEmployeeByParam(paramEmployee) ;
        if(mgtEmployee != null){
        	//定义返回值的json数据
        	JSONObject json = new JSONObject();
            String employeeId = mgtEmployee.getId();
            String merchantCode = mgtEmployee.getMerchantCode();
            modelMap.addAttribute("employeeId", employeeId);
            modelMap.addAttribute("accountName", mgtEmployee.getAccountName());
            //查询该用户对应的所有角色。
            List employeeRole = mgtRoleService.findEmployeeRoleByEmployeeId(employeeId);
            Map<String, Object> paramMapa = new HashMap<String, Object>();
            paramMapa.put("status", "1");
            paramMapa.put("employeeId", employeeId);
            if (StringUtils.isNotBlank(merchantCode)){
                paramMapa.put("merchantCode", merchantCode);
            }
            //查询该商户下的角色
            List<MgtRole> roleList = mgtRoleService.findRoleListByMap(paramMapa);
            /**
             * 判断角色列表是否为空，不为空的情况下才能查询权限
             */
            if(employeeRole!=null && employeeRole.size()>0 && roleList !=null && roleList.size()>0){
            	List<MgtRole> newRoleList =  new ArrayList<MgtRole>();
                for(int i=0;i<roleList.size();i++){
                    MgtRole role = roleList.get(i);
                    //单选框是否选中，默认不选
                    String checkState = "n";
                    for(int j=0;j<employeeRole.size();j++){
                        Map eRole = (Map)employeeRole.get(j);
                        //如果id相同，设置状态为y
                        if(eRole.get("ROLE_ID").toString().equals(role.getId())){
                            checkState = "y";
                        }
                    }
                    role.setVisible(checkState);
                    newRoleList.add(role);
                    //重新初始化
                    checkState = "n";
                }
            
                modelMap.addAttribute("roleList", newRoleList);
                modelMap.addAttribute("employeeRoleList", employeeRole);
                //根据角色查询用户对应的所有权限（菜单和资源）
                List<String> roleIds = new ArrayList<String>(roleList.size());
                for (int i=0;i<employeeRole.size();i++) {
                    Map role = (Map)employeeRole.get(i);
                    roleIds.add(role.get("ROLE_ID").toString());
                }
                Map<String, Object> param = new HashMap<String, Object>();
                param.put("roleIds", roleIds);
                param.put("status", "1");
                //查询用户角色下所有的菜单
                List menuList = mgtMenuService.queryMenuListByRoleIds(param);
                
                //查询用户角色下所有的资源
                List  resourceList= mgtResourceService.queryResourceListByRoleIds(param);
                if(resourceList!=null && resourceList.size()>0){
                	 modelMap.addAttribute("resourceList", resourceList);
                }
                /****设置角色菜单为空的显示start****/
                if(menuList!=null && menuList.size()>0){
                	//循环取出找到没有菜单的角色，赋予空值。
                    List<String> menuRoleIds = new ArrayList<String>();
                    String menuRoleId = "";
                    for(int i=0;i<menuList.size();i++){
                        Map menuRole = (Map)menuList.get(i);
                        if(i==0){
                            menuRoleId = menuRole.get("ROLE_ID").toString();
                        }else{
                            if(!menuRoleId.equals(menuRole.get("ROLE_ID").toString())){
                                menuRoleIds.add(menuRoleId);
                                menuRoleId = menuRole.get("ROLE_ID").toString();
                            }
                            if(i==(menuList.size()-1)){
                                menuRoleIds.add(menuRoleId);
                            }
                        }
                    }
                    //删除有菜单的角色id，留下的都是没有菜单的角色id
                    roleIds.removeAll(menuRoleIds);
                    //赋予空值
                    if(roleIds!=null && roleIds.size()>0){

                        for(String roleId:roleIds){
                            Map map = new HashMap();
                            MgtRole role = mgtRoleService.findById(roleId);
                            map.put("ROLE_NAME",role.getName());
                            map.put("ROLE_ID",roleId);
                            map.put("NAME",null);
                            map.put("ID",null);
                            menuList.add(map);
                        }

                    }
                    /****设置角色菜单为空的显示end****/
                    modelMap.addAttribute("menuList", menuList);
                }

                json.put("roleList",newRoleList);
                json.put("resourceList",resourceList);
                json.put("menuList",menuList);
            }
        }
		
		modelMap.addAttribute("scuser", user);
		return getUrl("mgt.employeeInfo");
	}
	
	@RequestMapping(value = "editPassword", method = RequestMethod.POST)
	@ResponseBody
	public Msg editPassword(ModelMap modelMap, HttpServletRequest request) {
		Msg msg = new Msg();
		if (null != jsonObject ) {
			try {
				MgtEmployee mep = new MgtEmployee();
				BigDecimal pass = userService.getPassword(jsonObject.get("oldPassword").toString());
				mep.setAccountName(WebUtils.getSessionUser().getAccountName());
				mep.setPassword(pass.toString());
				MgtEmployee employee = new MgtEmployee();
				employee= mgtEmployeeService.getLoginEmployee(mep);
				if(employee.getId()!=null){
					BigDecimal newpass = userService.getPassword(jsonObject.get("newPassword").toString());
					employee.setPassword(newpass.toString());
					mgtEmployeeService.saveOrUpdate(employee);
					User user = userService.findByUsername(employee.getAccountName());
					user.setUserPassword(new BigDecimal(employee.getPassword()));
					userService.save(user);
					msg.setMsg("修改成功！");
					msg.setCode("101");
					msg.setSuccess(true);
				}else{
					msg.setCode("100");
				}
				System.out.println(jsonObject.get("id"));
				System.out.println(jsonObject.get("oldPassword"));
				System.out.println(jsonObject.get("newPassword"));
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("保存失败，请联系管理员！");
			}
		} else {
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}
	
public static void main(String[] args) {
	String filePathName=null;
	String type = "icon";
	// 图片保存目录
	String rootDir = "D:"+ File.separator+"nginx"+ File.separator+"ROOT"  + File.separator +  GlobalConstant.UPLOAD_MICROSHOP;
	String pathDir = "";
			pathDir = rootDir + File.separator + type;
	 
			// 新的图片文件名
			String newFileName = UUID.randomUUID() + ".jpg" ;
			pathDir+= (File.separator+newFileName);
			File imgFile = new File(pathDir);
			try {
				imgFile.createNewFile();
				// 完整文件名
				filePathName = pathDir + File.separator + newFileName;
				OutputStream out = new  FileOutputStream(imgFile);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
 
}
}
