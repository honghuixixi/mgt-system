package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtDepartmentService;
import cn.qpwa.mgt.facade.system.entity.MgtDepartment;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门视图展示类
 * 
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/department")
@SuppressWarnings("all")
public class DepartmentController extends BaseController {

	@Autowired
	private MgtDepartmentService mgtDepartmentService;

	/**
	 * 跳转部门信息页面
	 */
	@RequestMapping(value = "departmentInfo")
	public String departmentInfoUI() {
		return super.getUrl("mgt.departmentinfo");
	}

	/**
	 * 获取部门表格信息
	 */
	@RequestMapping(value = "departmentListGrid")
	@ResponseBody
	public Object departmentInfoForJqgrid(final ModelMap modelMap, HttpServletRequest request) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("departCode", "asc");
		Page page = mgtDepartmentService.querys(jsonObject, orderby);
		PageView<MgtDepartment> pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(
				jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 跳转部门添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addDepartmentUI")
	public String addDepartment(ModelMap modelMap) {
		modelMap.addAttribute("pId", jsonObject.getString("id"));
		return super.getUrl("mgt.addDepartmentUI");
	}

	/**
	 * 保存部门信息
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(final HttpServletRequest request) {
		Msg msg = new Msg();
		if (null != jsonObject) {
			try {
				MgtDepartment department = JSONTools.JSONToBean(jsonObject, MgtDepartment.class);
				// 查询departCode是否存在
				String exist = mgtDepartmentService.exist(department.getDepartCode());
				if ("yes".equals(exist)) {
					msg.setCode("orgNumberIsExist");
					msg.setData("部门编号已经存在！");
				} else {
					String pId = jsonObject.getString("pId");
					if (pId != null && "".equals(pId)) {
						department.setpId("-1");
					}
					MgtDepartment dept = mgtDepartmentService.findById(pId);// 获取父级信息
					String seq = dept.getSeq() + "." + department.getDepartCode();
					department.setSeq(seq);
					department.setStatus("1");
					department.setMerchantCode(WebUtils.getSessionUser().getMerchantCode());
					mgtDepartmentService.saveDep(department);
					msg.setSuccess(true);
					msg.setMsg("保存成功！");
				}
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
	 * 修改部门界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "editDepartmentUI")
	public String editDepartmentUI(ModelMap modelMap) {
		MgtDepartment department = mgtDepartmentService.findById(jsonObject.getString("id"));
		modelMap.addAttribute("department", department);
		return getUrl("mgt.editDepartmentUI");
	}

	/**
	 * 修改部门信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	@ResponseBody
	public Msg edit(final MgtDepartment department) {
		Msg msg = new Msg();
		if (null != department && StringUtils.isNotBlank(department.getName())) {
			try {
				mgtDepartmentService.updateDep(department);
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
	// MgtDepartment department =
	// departmentService.findById(getJsonObject().getString("id"));
	// msg.setData(MgtDepartment);
	// }
	// });
	// }

	/**
	 * 删去部门及自己的子部门信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "delete")
	@ResponseBody
	public Msg delete(ModelMap modelMap) {
		Msg msg = new Msg();
		msg.setCode("error");
		if (null != jsonObject && StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				// 获取该部门信息
				MgtDepartment dept = mgtDepartmentService.findById(jsonObject.getString("id"));
				if (StringUtils.isNotBlank(dept.getpId()) && !"-1".equals(dept.getpId())) {
					// 查询所删除部门下的人员是否存在
					String exist = mgtDepartmentService.findExistBySeq(jsonObject.getString("id"));
					if ("yes".equals(exist)) { // 存在
						msg.setCode("orgExistEmploy");
						msg.setMsg("该部门下还有人员，不能删除！");
					} else {
						mgtDepartmentService.deleteDept(dept.getSeq());
						msg.setCode("success");
						msg.setMsg("删除成功！");
						msg.setSuccess(true);
					}
				} else {// 根节点部门不能删除
					msg.setMsg("该部门不能删除！");
				}
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
	 * 查询所有部门
	 * 
	 * @return
	 */
	@RequestMapping(value = "deptList", method = RequestMethod.POST)
	@ResponseBody
	public Msg deptList(final ModelMap modelMap) {
		Msg msg = new Msg();
		if (null != jsonObject) {
			try {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("status", "1");
				paramMap.put("employeeId", WebUtils.getSessionUser().getId());
				// DepartmentObject departmentObject =
				// mgtDepartmentService.queryForList(paramMap, null);
				// msg.setData(departmentObject.getDepartJsonArray());
				List list = mgtDepartmentService.queryForLists(paramMap, null);
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

	/**
	 * 通过部门编号查询部门编号是否已经存在
	 * 
	 * @return
	 */
	@RequestMapping(value = "findDepartCodeExist")
	@ResponseBody
	public Msg findDepartCodeExist() {
		Msg msg = new Msg();
		if (null != jsonObject && StringUtils.isNotBlank(jsonObject.getString("departCode"))) {
			try {
				// 查询departCode是否存在
				String exist = mgtDepartmentService.exist(jsonObject.getString("departCode"));
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("code", exist);
				msg.setData(jsonObject);
				msg.setSuccess(true);
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