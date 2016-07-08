package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.entity.MgtMenu;
import cn.qpwa.mgt.facade.system.service.MgtMenuService;
import cn.qpwa.mgt.facade.system.service.MgtModuleService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 菜单视图展示类
 * 
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/menu")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MenuController extends BaseController {

	@Autowired
	private MgtMenuService mgtMenuService;

	@Autowired
	private MgtModuleService mgtModuleService;

	/**
	 * 获取菜单信息页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "menuInfo")
	public ModelAndView menuInfo() {
		return super.toView(super.getUrl("mgt.menuinfo"));
	}

	/**
	 * 获取菜单信息页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "menuInfoSub")
	public ModelAndView menuInfoSub() {
		return super.toView(super.getUrl("mgt.menuinfosubgrid"));
	}

	/**
	 * 获取菜单信息页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "menuList", method = RequestMethod.POST)
	@ResponseBody
	public Msg menuList() {
		Msg msg = new Msg();
		try {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("visible", "1");
			List<Map<String, Object>> list = mgtMenuService.findByList(paramMap);
			for (Map<String, Object> map : list) {
				if ("-1".equals(map.get("PID").toString())) {
					map.put("NOCHECK", true);
				} else {
					map.put("NOCHECK", false);
				}
			}
			msg.setSuccess(true);
			msg.setData(list);
			msg.setMsg("获取所有菜单成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("查询失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 获取菜单列表信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object info(final ModelMap modelMap) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = mgtMenuService.querys(jsonObject, null);
		System.out.println(page.getItems().toString());
		if(page.getItems().size() == 0){
			//二级菜单查找
			String acId = (String) jsonObject.get("acId");
			jsonObject.put("id", acId);
			page = mgtMenuService.querys(jsonObject, null);
		}
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject,
				"page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 菜单添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addMenuUI")
	public String addMenuUI(ModelMap modelMap) {
		List<Map<String, Object>> menuList = mgtMenuService.findByParentId("-1", null);
		List mgtModuleList = mgtModuleService.selectMgtModuleList();
		modelMap.addAttribute("menuList", menuList);
		modelMap.addAttribute("mgtModuleList",mgtModuleList);
		return getUrl("mgt.addMenuUI");
	}

	/**
	 * 保存菜单信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add() {
		Msg msg = new Msg();
		try {
			MgtMenu menu = JSONTools.JSONToBean(jsonObject, MgtMenu.class);
			System.out.println(jsonObject.get("pId"));
			menu.setPId(jsonObject.get("pId").toString());
			mgtMenuService.saveOrUpdate(menu);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 跳转更新菜单界面
	 * 
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "editMenuUI")
	public String editMenuUI(ModelMap modelMap) {
		MgtMenu menu = mgtMenuService.findById(jsonObject.getString("id"));
		List<Map<String, Object>> menuList = mgtMenuService.findByParentId("-1", null);
		boolean pIdFlag = false;
		List l = mgtMenuService.findByParentId(menu.getId(), null);
		if (null != l && l.size() > 0) {
			pIdFlag = true;
		}
		List mgtModuleList = mgtModuleService.selectMgtModuleList();
		modelMap.addAttribute("pIdFlag", pIdFlag);
		modelMap.addAttribute("menu", menu);
		modelMap.addAttribute("menuList", menuList);
		modelMap.addAttribute("mgtModuleList",mgtModuleList);
		return getUrl("mgt.editMenuUI");
	}

	/**
	 * 更新菜单信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	@ResponseBody
	public Msg edit(final MgtMenu menu) {
		Msg msg = new Msg();
		if (menu != null & StringUtils.isNotBlank(menu.getId())) {
			try {
				mgtMenuService.saveOrUpdate(menu);
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
	// @RequestMapping(value = "selectById", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg selectById() {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	// // 判断传递参数是否为null
	// Assert.isTrue(null != getJsonObject(), "打开查询界面失败！");
	//
	// MgtMenu menu = menuService.findById(getJsonObject().getString("id"));
	// msg.setData(menu);
	// }
	// });
	// }

	/**
	 * 删去菜单信息
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
				mgtMenuService.delete(idArray);
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
	 * 状态启用/停用
	 * 
	 * @return
	 */
	// @RequestMapping(value = "updateStatus", method = RequestMethod.POST)
	// @ResponseBody
	// public Msg updateStatus(final MgtMenu menu) {
	// return doExpAssert(new AssertObject() {
	// @Override
	// public void AssertMethod(Msg msg) {
	//
	// // 判断参数是否为空
	// Assert.isTrue(null != getJsonObject(), "删除失败！");
	// menuService.updateMenuStatus(menu);
	// msg.setMsg("状态修改成功！");
	// }
	// });
	// }

	/**
	 * 状态启用/停用
	 * 
	 * @return
	 */
	@RequestMapping(value = "orderBySelect", method = RequestMethod.POST)
	@ResponseBody
	public Msg orderBySelect(final Integer sortby) {
		Msg msg = new Msg();
		if (sortby != null) {
			try {
				msg.setSuccess(true);
				msg.setData(mgtMenuService.countMneuBySortby(sortby));
				msg.setMsg("查询成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("查询失败，请联系管理员！");
			}
		} else {
			msg.setMsg("查询失败，请联系管理员！");
		}
		return msg;
	}
}
