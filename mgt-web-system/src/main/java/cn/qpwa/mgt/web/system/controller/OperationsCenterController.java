package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.*;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.web.vo.UserVO;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.mgt.facade.system.service.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 运营中心展示
 *
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/operationsCenter")
@SuppressWarnings("all")
public class OperationsCenterController extends BaseController{
	@Autowired
	private UserService userService;
	@Autowired
	private AreaMasWebService areaMasWebService;
	@Autowired
	private ScuserAreaService scuserAreaService;
	@Autowired
	private MgtEmployeeService mgtEmployeeService;
	@Autowired
	OperatorCenterService operatorCenterService;
	/**
	 * 跳转获取运营中心用户页面
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @return
	 */
	@RequestMapping(value = "operationsCenterinfo")
	public ModelAndView operationsCenterinfo(final ModelMap modelMap) {
		return super.toView(super.getUrl("mgt.operationsCenterinfo"));
	}
	/**
	 * 获取运营中心用户信息
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object getOperationsCenter(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		SystemContext.setPagesize(JSONTools.getInt(jobj, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jobj, "page"));
		String username = WebUtils.getSessionUser().getAccountName();
		//判断是否为超级管理员
		if("1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))){
			jobj.put("super", "");
		}
		jobj.put("userNo", WebUtils.getSessionUser().getMerchantCode());
		Page page = userService.getOperationsCenter(jobj);
		PageView pageView = new PageView(JSONTools.getInt(jobj, "rows"), JSONTools.getInt(jobj, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 运营中心管理--跳转修改页面
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 */
	@RequestMapping(value = "edit")
	public ModelAndView edit(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		if(jobj==null){
			jobj=new JSONObject();
		}
		BigDecimal userNo = new BigDecimal(jsonObject.getString("id"));
		User user = userService.findByUserNo(userNo);
		MgtEmployee employee = mgtEmployeeService.findUniqueBy("accountName", user.getUserName());
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("userNo", userNo);
		modelMap.addAttribute("employee", employee);
		return super.toView(super.getUrl("mgt.operationsCenterEdit"));
	}

	/**
	 * 运营中心保存信息
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody
	public Msg save(){
		Msg msg=new Msg();
		try {
			userService.editUserAndEmployee(jsonObject);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 运营中心--详情页面
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 */
	@RequestMapping(value="operationsCenterDetail")
	public ModelAndView operationsCenterDetail(final ModelMap modelMap){
		JSONObject jobj = jsonObject;
		if(jobj==null){
			jobj=new JSONObject();
		}
		BigDecimal userNo = new BigDecimal(jsonObject.getString("id"));
		User user = userService.findByUserNo(userNo);
		User parentUser = userService.findByUserNo(user.getParentAcc());
		if(parentUser==null){
			parentUser = new User();
			parentUser.setUserName("superadmin");
		}
		Map<String, Object> area = areaMasWebService.findFullName(user.getAreaId());
		MgtEmployee employee = mgtEmployeeService.findUniqueBy("accountName", user.getUserName());
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("userNo", userNo);
		modelMap.addAttribute("area", area);
		modelMap.addAttribute("parentUser", parentUser);
		modelMap.addAttribute("employee", employee);
		return super.toView(super.getUrl("mgt.operationsCenterDetail"));
	}

	/**
	 * 运营中心信息停用或启用
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @return
	 */
	@RequestMapping(value = "updateFlg", method = RequestMethod.POST)
	@ResponseBody
	public Msg updateFlg(){
		Msg msg = new Msg();
		JSONObject jobj = jsonObject;
		try {
			BigDecimal userNo = new BigDecimal(jsonObject.getString("id"));
			mgtEmployeeService.editFlg(jobj, userNo);
			msg.setSuccess(true);
		} catch (Exception e) {
			e.printStackTrace();
			msg.setSuccess(false);
			msg.setMsg("操作失败，请联系管理员！");
		}

		return msg;
	}

	/**
	 * 运营中心--分配区域界面
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 */
	@RequestMapping(value="operationsCenterArea")
	public ModelAndView operationsCenterArea(final ModelMap modelMap){
		JSONObject jobj = jsonObject;
		if(jobj==null){
			jobj=new JSONObject();
		}
		BigDecimal userNo = new BigDecimal(jsonObject.getString("id"));
		User user = userService.findByUserNo(userNo);
		List<Map<String, Object>> scuserAreas = null;
		try {
			scuserAreas = scuserAreaService.findScuserAreaByUserName(user.getUserName());
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("scuserAreas", scuserAreas);
		return super.toView(super.getUrl("mgt.operationsCenterArea"));
	}

	/**
	 * 保存分配区域
	 * @author RJY
	 * @data 2016年1月6日17:49:48
	 * @return
	 */
	@RequestMapping(value = "addArea", method = RequestMethod.POST)
	@ResponseBody
	public Msg addArea() {
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("userName"))) {
			try {
				userService.addArea(jsonObject);
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
	 * 跳转新增运营中心用户页面
	 * @author RJY
	 * @data 2016年1月14日10:03:57
	 * @return
	 */
	@RequestMapping(value = "addUI")
	public ModelAndView addUI(final ModelMap modelMap) {
		return super.toView(super.getUrl("mgt.addUI"));
	}

	/**
	 * 添加下级运营中心信息
	 * @author RJY
	 * @data 2016年1月14日10:32:50
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(){
		Msg msg=new Msg();
		try {
			String merchantCode = WebUtils.getSessionUser().getMerchantCode();
			userService.addUserAndEmployee(jsonObject, merchantCode);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 通过userName检查账号是否可用
	 * @author RJY
	 * @data 2016年1月14日11:15:20
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "findByNameFlag", method = RequestMethod.POST)
	@ResponseBody
	public Msg findByNameFlag(final String userName) {
		Msg msg = new Msg();
		boolean flag = false;
		try {
			List l = userService.findByUserName(userName);
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
	 * 运营中心店铺 供应商 物流商 o2o店铺 消费者 统计信息页面
	 *
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "operatorMapData", method = RequestMethod.GET)
	public ModelAndView mapDataOfOperationCenter(ModelMap modelMap) {
		modelMap.addAttribute("startDate", DateUtil.afterNDay(-7));
		modelMap.addAttribute("endDate", DateUtil.getCurrDate());
		return super.toView(super.getUrl("mgt.operator.map.data"));
	}

	/**
	 * 运营中心店铺 供应商 物流商 o2o店铺 地图页面
	 *
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "operatorMap", method = RequestMethod.GET)
	public ModelAndView mapOfOperationCenter(ModelMap modelMap) {
		modelMap.addAttribute("startDate", DateUtil.afterNDay(-7));
		modelMap.addAttribute("endDate", DateUtil.getCurrDate());
		UserVO u = WebUtils.getSessionUser();
		if (null != u) {
			SystemContext.setPagesize(3000);
			SystemContext.setOffset(1);
			//运营中心及其下属用户均可以查看统计数据
			/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
			String userName = WebUtils.getSessionUser().getAccountName();
			if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
				userName = user.getRefUserName();
			}*/
			Page page = operatorCenterService.getUserCountDataForOperations(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
//			List<Map<String, Object>> list = this.scuserAreaService.findScuserAreaInforByUserName(u.getAccountName());
			if (null != page && page.getItems().size() > 0) {
				JSONArray jsonArray = JSONArray.fromObject(page.getItems());
				modelMap.addAttribute("area", jsonArray.toString());
			}
		}
		return super.toView(super.getUrl("mgt.operator.map"));
	}

	private void setDateParaForOper() {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		if (jsonObject.containsKey("range")) {
			if (StringUtils.equals("2", jsonObject.getString("range"))) {
				jsonObject.remove("startDate");
			}
		}
	}

	/**
	 * 运营中心店铺 供应商 物流商 o2o店铺 信息导出excel
	 *
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "exportExcelSumCount", method = RequestMethod.GET)
	public void exportExcelSumCountForOperator(HttpServletResponse response) throws IOException {
		UserVO u = WebUtils.getSessionUser();
		if (null == u) {
			return;
		}
		JSONObject jobj = jsonObject;
		String filename = System.currentTimeMillis() + ".xls";
		String headStr = "attachment; filename=\"" + filename + "\"";
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition", headStr);
		OutputStream out = response.getOutputStream();
		setDateParaForOper();
		SystemContext.setOffset(1);
		SystemContext.setPagesize(10000);
		//运营中心及其下属用户均可以查看统计数据
		/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
		String userName = WebUtils.getSessionUser().getAccountName();
		if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
			userName = user.getRefUserName();
		}*/
		operatorCenterService.exportExcelMapDataForOperator(jobj, filename, out, WebUtils.getSessionUser().getMerchantUserName());
	}

	/**
	 * 运营中心数据统计信息
	 *
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "countDatabyOperator", method = RequestMethod.GET)
	@ResponseBody
	public Object countDataOperationCenterByAera(final ModelMap modelMap) {
		UserVO u = WebUtils.getSessionUser();
		if (null != u) {
			setDateParaForOper();
			//运营中心及其下属用户均可以查看统计数据
			/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
			String userName = WebUtils.getSessionUser().getAccountName();
			if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
				userName = user.getRefUserName();
			}*/
			Page page = operatorCenterService.getUserCountDataForOperations(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
			PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject, "page"));
			pageView.setTotalrecord(page.getTotal());
			pageView.setRecords(page.getItems());
			return pageView;
		} else {
			return null;
		}
	}

	/**
	 * 运营中心数据统计信息
	 *
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "countSumDatabyOperator", method = RequestMethod.GET)
	@ResponseBody
	public Object countSumDataOperationCenterByAera(final ModelMap modelMap) {
		UserVO u = WebUtils.getSessionUser();
		if (null != u) {
			setDateParaForOper();
			//运营中心及其下属用户均可以查看统计数据
			/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
			String userName = WebUtils.getSessionUser().getAccountName();
			if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
				userName = user.getRefUserName();
			}*/
			return operatorCenterService.getSumCountDataForOperations(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
		} else {
			return null;
		}
	}

	/**
	 * 运营中心数据地区经纬度
	 *
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "mapTudebyArea", method = RequestMethod.GET)
	@ResponseBody
	public Object mapDataOperationCenterByAera(final ModelMap modelMap, BigDecimal aid) {
		if (null != aid) {
			UserVO u = WebUtils.getSessionUser();
			if (null != u) {
				SystemContext.setOffset(1);
				SystemContext.setPagesize(5000);
				//运营中心及其下属用户均可以查看统计数据
				/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
				String userName = WebUtils.getSessionUser().getAccountName();
				if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
					userName = user.getRefUserName();
				}*/
				return operatorCenterService.getUserCountMapTudeDataForOperations(jsonObject,WebUtils.getSessionUser().getMerchantUserName(), aid);
			}
		}
		return null;
	}

	/**
	 * 运营中心数据分析页面
	 *
	 * @return
	 */
	@RequestMapping(value = "operator", method = RequestMethod.GET)
	public ModelAndView vendorCustomerProduct(ModelMap modelMap) {
		modelMap.addAttribute("startDate", DateUtil.afterNDay(-7));
		modelMap.addAttribute("endDate", DateUtil.getCurrDate());
		return super.toView(super.getUrl("mgt.operator.analysis"));
	}

	/**
	 * 运营中心数据分析数据导出
	 *
	 * @return
	 */
	@RequestMapping(value = "exportExcelOper", method = RequestMethod.GET)
	public void exportExcelForOperator(HttpServletResponse response) throws IOException {
		UserVO u = WebUtils.getSessionUser();
		if (null == u) {
			return;
		}
		JSONObject jobj = jsonObject;
		String filename = System.currentTimeMillis() + ".xls";
		String headStr = "attachment; filename=\"" + filename + "\"";
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition", headStr);
		OutputStream out = response.getOutputStream();
		setDateParaForOper();
		SystemContext.setOffset(1);
		SystemContext.setPagesize(10000);
		int val = jobj.getInt("val");
		//运营中心及其下属用户均可以查看统计数据
		/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
		String userName = WebUtils.getSessionUser().getAccountName();
		if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
			userName = user.getRefUserName();
		}*/
		if (1 == val) {
			operatorCenterService.exportExcelForOperator(jobj, filename, out, WebUtils.getSessionUser().getMerchantUserName());
		} else if (2 == val) {
			operatorCenterService.exportExcelVendorForOperator(jobj, filename, out, WebUtils.getSessionUser().getMerchantUserName());
		} else if (3 == val) {
			operatorCenterService.exportExcelCustomerForOperator(jobj, filename, out, WebUtils.getSessionUser().getMerchantUserName());
		} else if (4 == val) {
			operatorCenterService.exportExcelStkForOperator(jobj, filename, out, WebUtils.getSessionUser().getMerchantUserName());
		}
	}

	/**
	 * 运营中心数据分析页面的数据
	 *
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "byOperator", method = RequestMethod.GET)
	@ResponseBody
	public Object operationCenterByAera(final ModelMap modelMap) {
		UserVO u = WebUtils.getSessionUser();
		if (null == u) {
			return null;
		}
		setDateParaForOper();
		Page page = null;
		int val = jsonObject.getInt("val");
		//运营中心及其下属用户均可以查看统计数据
		/*User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
		String userName = WebUtils.getSessionUser().getAccountName();
		if(null != user && StringUtils.isNotBlank(user.getRefUserName())){
			userName = user.getRefUserName();
		}*/
		if (1 == val) {
			page = operatorCenterService.getOrderForOperator(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
		} else if (2 == val) {
			page = this.operatorCenterService.getVendorForOperator(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
		} else if (3 == val) {
			page = this.operatorCenterService.getCustomerForOperator(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
		} else if (4 == val) {
			page = this.operatorCenterService.getStkForOperator(jsonObject, WebUtils.getSessionUser().getMerchantUserName());
		}
		if (null != page) {
			PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject, "page"));
			pageView.setTotalrecord(page.getTotal());
			pageView.setRecords(page.getItems());
			return pageView;
		} else {
			return null;
		}
	}
}
