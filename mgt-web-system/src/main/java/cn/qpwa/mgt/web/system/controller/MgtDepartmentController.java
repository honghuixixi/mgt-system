package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtDepartmentService;
import cn.qpwa.mgt.facade.system.service.MgtDepartmentUserService;
import cn.qpwa.mgt.facade.system.service.MgtEmployeeService;
import cn.qpwa.mgt.facade.system.entity.MgtDepartment;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.web.vo.UserVO;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
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

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;

@Controller
@Scope("prototype")
@RequestMapping(value = "/mgtDepartment")
@SuppressWarnings("all")
public class MgtDepartmentController extends BaseController {

	@Autowired
	private MgtDepartmentService mgtDepartmentService;
	
	@Autowired
	private MgtEmployeeService mgtEmployeeService;
	
	@Autowired
	private MgtDepartmentUserService mgtDepartmentUserService;
	
	@RequestMapping(value="departmentInfo")
	public ModelAndView departmentInfo(){
		return super.toView(super.getUrl("mgt.departmentInfo"));
	}
	
	/**
	 * 查询部门列表
	 * @author:liujing
	 * @date 2015-6-4 下午6:32:55
	 * @param modelMap
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object departmentList(final ModelMap modelMap, HttpServletRequest request) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		//TODO 查询当前登录用户的组织机构id，目前session中是空值，无法过滤，只能查询全部。稍后修改。 
		UserVO user = WebUtils.getSessionUser();
		String merchantCode = user.getMerchantCode();
//		System.out.println("merchantCOde====="+merchantCode);
		jsonObject.put("merchantCode",merchantCode);
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("depart_Code", "asc");
		PageView<MgtDepartment> pageView = mgtDepartmentService.queryDepartmentListByPage(jsonObject, orderby);
		return pageView;
	}
	
	/**
	 * 跳转部门添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addMgtDepartmentUI")
	public String addDepartment(ModelMap modelMap) {
		String merchantCode = WebUtils.getSessionUser().getMerchantCode();
		String parentId = "";
		if(StringUtils.isNotBlank(merchantCode)){
			parentId = mgtDepartmentService.findParentIdByMerchantCode(merchantCode);
		}else{
			//TODO 只是针对公司下面挂部门。因为没有标示部门的级别和sep为空。
			String userId = WebUtils.getSessionUser().getId();
			parentId = mgtDepartmentUserService.findDepartmentIdByUserId(userId);
		}
		modelMap.addAttribute("pId", parentId);
		return super.getUrl("mgt.addMgtDepartmentUI");
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
					String seq = null;
					if(dept != null){
						seq = dept.getSeq() + "." + department.getDepartCode();
					}else{
						seq = "";
					}
					department.setStatus("1");
					department.setSeq(seq);
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
	@RequestMapping(value = "editMgtDepartmentUI")
	public String editDepartmentUI(ModelMap modelMap) {
		MgtDepartment department = mgtDepartmentService.findById(jsonObject.getString("id"));
		modelMap.addAttribute("department", department);
		return getUrl("mgt.editMgtDepartmentUI");
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
				department.setStatus("1");
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
	 * 删除部门及自己的子部门信息
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
				String id = jsonObject.getString("id");
				// 获取该部门信息
				MgtDepartment dept = mgtDepartmentService.findById(id);
				if (StringUtils.isNotBlank(dept.getpId()) && !"-1".equals(dept.getpId())) {
					// 查询所删除部门下的人员是否存在
					String exist = mgtDepartmentService.findExistBySeq(id);
					if ("yes".equals(exist)) { // 存在
						msg.setCode("orgExistEmploy");
						msg.setMsg("该部门下还有人员，不能删除！");
					} else {
						mgtDepartmentService.deleteDepartmentById(id);
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

}
