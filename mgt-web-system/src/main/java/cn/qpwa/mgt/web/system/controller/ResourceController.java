package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtMenuService;
import cn.qpwa.mgt.facade.system.service.MgtResourceService;
import cn.qpwa.mgt.facade.system.service.MgtRoleService;
import cn.qpwa.mgt.facade.system.entity.MgtResource;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.utils.json.JsonUtils;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

/**
 * 资源视图展示类
 * 
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/resource")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class ResourceController extends BaseController {

	@Autowired
	private MgtResourceService mgtResourceService;
	@Autowired
	private MgtRoleService mgtRoleService;
	@Autowired
	private MgtMenuService mgtMenuService;

	/**
	 * 跳转资源信息页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "resourceInfo")
	public ModelAndView resourceInfo() {
		return super.toView(super.getUrl("mgt.resourceinfo"));
	}

	/**
	 * 获取资源列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object info(String orderby, String sord) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = mgtResourceService.querys(jsonObject, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject,
				"page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 获取菜单下资源列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "resources")
	@ResponseBody
	public Object resources(final ModelMap modelMap) {
		List<Map<String, Object>> resources = mgtResourceService.findResourceByMenuId(JSONTools.getString(jsonObject, "memuID"));
		System.out.println(JsonUtils.toJson(resources));
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject,
				"page"));
		pageView.setRecords(resources);
		return pageView;
	}

	/**
	 * 资源添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addResourceUI")
	public String addResourceUI(String id, ModelMap modelMap) {
		return getUrl("mgt.addResourceUI");
	}

	/**
	 * 保存资源信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(final String citySelCode) {
		Msg msg = new Msg();
		if (StringUtils.isNotBlank(citySelCode)) {
			try {
				MgtResource resource = JSONTools.JSONToBean(jsonObject, MgtResource.class);
				resource.setMenuid(citySelCode);
				mgtResourceService.saveOrUpdate(resource);
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
	 * 更新资源界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "editResourceUI")
	public String editResourceUI(String id, ModelMap modelMap) {
		MgtResource resource = mgtResourceService.findById(id);
		modelMap.addAttribute("resource", resource);
		if (resource != null && StringUtils.isNotBlank(resource.getMenuid())) {
			modelMap.addAttribute("menu", mgtMenuService.findById(resource.getMenuid()));
		}
		return getUrl("mgt.editResourceUI");
	}

	/**
	 * 更新资源信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	@ResponseBody
	public Msg edit(final MgtResource resource, final String citySelCode) {
		Msg msg = new Msg();
		if (resource != null && StringUtils.isNotBlank(resource.getName()) && StringUtils.isNotBlank(citySelCode)) {
			try {
				resource.setMenuid(citySelCode);
				mgtResourceService.saveOrUpdate(resource);
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
	 * 删去资源信息
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
				mgtResourceService.delete(idArray);
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
	// MgtResource Resource =
	// resourceService.findById(getJsonObject().getString("id"));
	// msg.setData(Resource);
	// }
	// });
	// }

	/**
	 * 
	 * @return
	 */
	// @RequestMapping(value = "deleteFlag", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg deleteFlag() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// // 判断参数是否为空
	// Assert.isTrue(null != getJsonObject(), "删除失败！");
	// msg.setMsg("");
	// String ids = getJsonObject().getString("id");
	// String[] idArray = StringUtils.split(ids, ",");
	// for (String id : idArray) {
	// List l = roleService.findByResourceId(id);
	// if (null != l && l.size() > 0) {
	// msg.setMsg("资源已分配角色！");
	// }
	// }
	// }
	// });
	// }

}
