package cn.qpwa.mgt.web.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.mgt.facade.system.entity.MgtResource;
import cn.qpwa.mgt.facade.system.entity.MgtRole;
import cn.qpwa.mgt.facade.system.service.MgtMenuService;
import cn.qpwa.mgt.facade.system.service.MgtResourceService;
import cn.qpwa.mgt.facade.system.service.MgtRoleService;

/**
 * 角色视图展示类
 * 
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/role")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class RoleController extends BaseController {

	@Autowired
	private MgtRoleService mgtRoleService;
	@Autowired
	private MgtResourceService mgtResourceService;
	@Autowired
	private MgtMenuService mgtMenuService;

	/**
	 * 获取角色信息页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "roleInfo")
	public ModelAndView roleInfo() {
		return super.toView(super.getUrl("mgt.roleinfo"));
	}

	/**
	 * 获取角色列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object info(final ModelMap modelMap) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		String visible = "1";
		// 超级管理员显示全部的角色
		if (WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER) != null
				&& "1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))) {
			visible = null;
		}
		jsonObject.put("visible", visible);
		jsonObject.put("merchantCode", WebUtils.getSessionUser().getMerchantCode());
		Page page = mgtRoleService.querys(jsonObject, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject,
				"page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 获取角色列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "resourceList")
	@ResponseBody
	public String resourceList(final ModelMap modelMap) {
		Msg msg = new Msg();
		msg.setData(mgtResourceService.findByList(jsonObject));
		msg.setSuccess(true);
		return msg.toJSONObject("yyyy-MM-dd").toString();
	}

	/**
	 * 跳转角色添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addRoleUI")
	public String addRoleUI() {
		return super.getUrl("mgt.addRoleUI");
	}

	/**
	 * 跳转角色人员分配UI
	 * 
	 * @return
	 */
	@RequestMapping(value = "addRoleUserUI")
	public String addRoleUserUI(ModelMap modelMap) {
		List<Map<String, Object>> roleUserList = mgtRoleService.findEmployeeRoleByRoleId(jsonObject.getString("id"));
		modelMap.addAttribute("roleId", jsonObject.get("id"));
		modelMap.addAttribute("roleUserList", roleUserList);
		return super.getUrl("mgt.addRoleUserUI");
	}

	/**
	 * 保存角色信息(新增、修改)
	 * 
	 * @return
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(final HttpServletRequest request) {
		Msg msg = new Msg();
		try {
			MgtRole role = JSONTools.JSONToBean(jsonObject, MgtRole.class);
			// 超级管理员修改、添加角色，不设置商户信息，并确保商户数据完整
			if (WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER) != null
					&& !"1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))) {
				role.setMerchantCode(WebUtils.getSessionUser().getMerchantCode());
				role.setVisible("1");
			}
			role.setCreateBy(WebUtils.getSessionUser().getAccountName());
			mgtRoleService.saveOrUpdate(role);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 保存角色人员信息
	 * 
	 * @param role
	 * @return
	 */
	@RequestMapping(value = "addRoleUser", method = RequestMethod.POST)
	@ResponseBody
	public Msg addRoleUser() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("roleId"))) {
			try {
				mgtRoleService.saveRoleEmployee(jsonObject);
				List<Map<String, Object>> roleUserList = mgtRoleService.findEmployeeRoleByRoleId(jsonObject
						.getString("roleId"));
				msg.setData(roleUserList);
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
	 * 更新角色界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "editRoleUI")
	public String editRoleUI(String id, ModelMap modelMap) {
		modelMap.addAttribute("role", mgtRoleService.findById(id));
		return super.getUrl("mgt.editRoleUI");
	}

	/**
	 * 更新角色信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	// @RequestMapping(value = "edit", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg edit(final Role role, final HttpServletRequest request) {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg Msg) {
	// Employee localUser = this.getEmployee();
	// // role.setMerchantCode(localUser.getMerchantId());
	// roleService.saveOrUpdate(role);
	// }
	// });
	// }

	/**
	 * 打开查询界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	// @RequestMapping(value = "selectById", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg selectById() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// // 判断传递参数是否为null
	// Assert.isTrue(null != getJsonObject(), "打开查询界面失败！");
	//
	// Role role = roleService.findById(getJsonObject().getString("id"));
	// msg.setData(role);
	// }
	// });
	// }

	/**
	 * 删去角色信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Msg delete() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				String ids = jsonObject.getString("id");
				String[] idArray = StringUtils.split(ids, ",");
				mgtRoleService.delete(idArray);
				msg.setMsg("删除成功！");
				msg.setSuccess(true);
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
	 * 删去角色信息
	 * 
	 * @return
	 */
	// @RequestMapping(value = "deleteFlag", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg deleteFlag() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	//
	// // 判断参数是否为空
	// Assert.isTrue(null != getJsonObject(), "删除失败！");
	// msg.setMsg("");
	// String ids = getJsonObject().getString("id");
	// String[] idArray = StringUtils.split(ids, ",");
	// for (String id : idArray) {
	// List l = roleService.findEmployeeRoleByRoleId(id);
	// if (null != l && l.size() > 0) {
	// msg.setMsg("角色下已经分配员工！");
	// }
	// }
	// }
	// });
	// }

	/**
	 * 状态启用/停用
	 * 
	 * @return
	 */
	// @RequestMapping(value = "updateStatus", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg updateStatus(final Role role) {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	//
	// // 判断参数是否为空
	// Assert.isTrue(null != getJsonObject(), "删除失败！");
	// roleService.updateRoleStatus(role);
	// msg.setMsg("状态修改成功！");
	// }
	// });
	// }

	/**
	 * 角色资源关联设置
	 * 
	 * @return
	 */
	// @RequestMapping(value = "saveRole", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg saveRole() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	//
	// // 判断参数是否为空
	// Assert.isTrue(null != getJsonObject(), "角色资源关联设置失败！");
	// roleService.saveRole(getJsonObject());
	// msg.setMsg("角色资源关联设置成功！");
	// }
	// });
	// }

	/**
	 * 跳转设置角色资源界面
	 */
	@RequestMapping(value = "addRoleResourceUI")
	public String addRoleResourceUI(ModelMap modelMap) {
		List<Map<String, Object>> resourceList = mgtResourceService.findResourceByRoleId(jsonObject.getString("id"));
		// Map<String, Object> paramMap = new HashMap<String, Object>();
		// paramMap.put("visible", "1");

		String visible = "1";
		// 超级管理员显示全部的菜单，其他角色仅显示自身的菜单
		List<Map<String, Object>> menuList = null;
		System.out.println(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER));
		if (WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER) != null
				&& "1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))) {
			visible = null;
			// 获取所以一级菜单 该方法与数据库连接数过多
			//menuList = mgtMenuService.findByParentId("-1", visible);
			
			//查询所有菜单，资源
			Map<String,Object> paramMap = new HashMap<String,Object>();
			paramMap.put("visible", "1");
			List<Map<String, Object>> allMenus = mgtMenuService.findByList(paramMap);
			List<Map<String, Object>> allResources = mgtResourceService.findAll();
			menuList = mgtMenuService.findByParentIdNotResource("-1", visible);
			for (Map<String, Object> menu : menuList) {
				List<Map<String, Object>> menuItems = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> allMenu : allMenus) {
					if(menu.get("ID").toString().equals(allMenu.get("PID").toString())){
						List<Map<String, Object>> resourceItems = new ArrayList<Map<String, Object>>();
						for (Map<String, Object> resource : allResources) {
							if(allMenu.get("ID").toString().equals(resource.get("MENU_ID").toString())){
								resourceItems.add(resource);
							}
						}
						allMenu.put("resourceItems", resourceItems);
						menuItems.add(allMenu);
					}
					
				}
				menu.put("menuItems", menuItems);
			}
			
		} else {
			menuList = (List<Map<String, Object>>) WebUtils
					.getAttribute(BizConstant.SESSION_USER_AUTHORITY_MENU);
		}
		// System.out.println("menu list：" + new Gson().toJson(list));
		
		modelMap.addAttribute("resourceList", resourceList);
		modelMap.addAttribute("menuList", menuList);
		modelMap.addAttribute("roleId", jsonObject.getString("id"));
		return super.getUrl("mgt.addRoleResourceUI");
	}

	/**
	 * 保存用户角色信息
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "addRoleResource", method = RequestMethod.POST)
	@ResponseBody
	public Msg addRoleResource() {
		Msg msg = new Msg();
		if (jsonObject != null) {
			try {
				mgtRoleService.saveRole(jsonObject);
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
	 * 保存用户角色信息
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "findByNameFlag", method = RequestMethod.POST)
	@ResponseBody
	public Msg findByNameFlag(final String name) {
		Msg msg = new Msg();
		boolean flag = false;
		try {
			List l = mgtRoleService.findByName(name);
			if (null == l || l.size() == 0) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		msg.setData(flag);
		return msg;
	}
	/**
	 * 修改角色的作用域字段
	 * @author:lj
	 * @date 2015-6-9 上午10:30:51
	 * @param jsonObject
	 * @param scope
	 * @return
	 */
	@RequestMapping(value = "modifyRoleScope", method = RequestMethod.POST)
	@ResponseBody
	public Msg modifyRoleScope(){
		Msg msg = new Msg();
		if (jsonObject != null) {
			try {
				mgtRoleService.modifyRoleScope(jsonObject);
				msg.setMsg("修改成功！");
				msg.setSuccess(true);
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("修改失败，请联系管理员！");
			}
		} else {
			msg.setMsg("修改失败，请联系管理员！");
		}
		return msg;
	}
}
