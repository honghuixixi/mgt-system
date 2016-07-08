package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.UserService;
import cn.qpwa.mgt.facade.system.service.VendorServiceProviderService;
import cn.qpwa.mgt.facade.system.entity.User;
import cn.qpwa.mgt.facade.system.entity.VendorServiceProvider;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.utils.Msg;
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
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 供应商客服控制类
 * @author honghui
 * @date   2016-05-25
 */
@Controller
@RequestMapping(value="/vendorServiceProvider")
@Scope("prototype")
@SuppressWarnings("all")
public class VendorServiceProviderController extends BaseController {

	@Autowired
	private VendorServiceProviderService vendorServiceProviderService;
	@Autowired
	private UserService userService;
	
	/**
	 * 供应商客服管理主页
	 * @return
	 */
	@RequestMapping(value="indexUI")
	public ModelAndView indexUI(final ModelMap model){
		String accountName = WebUtils.getSessionUser().getAccountName();
		String merchantCode = WebUtils.getSessionUser().getMerchantCode();
		List<User> users = userService.findUserByRefUserNameAndMerchantCode(accountName,merchantCode);
		model.addAttribute("users", users);
		return super.toView(super.getUrl("mgt.vendorServiceProviderIndexUI"));
	}
	
	/**
	 * 供应商客服列表数据
	 * @return
	 */
	@RequestMapping(value="list")
	@ResponseBody
	public Object list(){
		JSONObject jobj = jsonObject;
		SystemContext.setPagesize(JSONTools.getInt(jobj, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jobj, "page"));
		jobj.put("vendorCode", WebUtils.getSessionUser().getAccountName());
		Page page = vendorServiceProviderService.findPage(jobj, null);
		PageView pageView = new PageView(JSONTools.getInt(jobj, "rows"), JSONTools.getInt(jobj, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}
	
	/**
	 * 添加客服
	 * @param model
	 * @return
	 */
	@RequestMapping(value="addUI")
	public ModelAndView add(final ModelMap model){
		String accountName = WebUtils.getSessionUser().getAccountName();
		String merchantCode = WebUtils.getSessionUser().getMerchantCode();
		List<User> users = userService.findUserByRefUserNameAndMerchantCode(accountName,merchantCode);
		model.addAttribute("users", users);
		VendorServiceProvider vendorServiceProvider = new VendorServiceProvider();
		if(jsonObject.containsKey("id") && StringUtils.isNotBlank(jsonObject.get("id").toString())){
			vendorServiceProvider  = vendorServiceProviderService.findByPkNo(new BigDecimal(jsonObject.get("id").toString()));
		}
		model.put("vendorServiceProvider", vendorServiceProvider);
		return super.toView(super.getUrl("mgt.vendorServiceProviderAddUI"));
	}
	
	/**
	 * 验证客服名称重复
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
			List<VendorServiceProvider> l = vendorServiceProviderService.findByName(name,WebUtils.getSessionUser().getAccountName());
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
	 * 保存客服信息(新增、修改)
	 * 
	 * @return
	 */
	@RequestMapping(value = "add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(final HttpServletRequest request) {
		Msg msg = new Msg();
		try {
			VendorServiceProvider serviceProvider = JSONTools.JSONToBean(jsonObject, VendorServiceProvider.class);
			serviceProvider.setVendorCode(WebUtils.getSessionUser().getAccountName());
			if(null != serviceProvider.getUserNo()){
				User user  = userService.findByUserNo(serviceProvider.getUserNo());
				if(null != user){
					serviceProvider.setUserName(user.getUserName());
					serviceProvider.setName(user.getName());
					serviceProvider.setUserPassword(user.getUserPassword());
				}
			}
			vendorServiceProviderService.saveOrUpdate(serviceProvider);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}
	
	/**
	 * 删除客服
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
				vendorServiceProviderService.delete(idArray);
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
	 * 停用/启用客服
	 * @return
	 */
	@RequestMapping(value = "editStatus", method = RequestMethod.POST)
	@ResponseBody
	public Msg editStatus( ) {
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				Map<String,String> map =vendorServiceProviderService.editStatus(getJsonObject());
				msg.setSuccess(true);
				msg.setCode(map.get("code"));
				msg.setMsg(map.get("msg"));
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("设置失败，请联系管理员！");
			}
		} else {
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg;
	}
	
	/**
	 * 根据pkNo获取客服
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "findByPkNo", method = RequestMethod.POST)
	@ResponseBody
	public VendorServiceProvider findByPkNo(final BigDecimal pkNo) {
		try {
			VendorServiceProvider vendorServiceProvider = vendorServiceProviderService.findByPkNo(pkNo);
			return vendorServiceProvider;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@RequestMapping(value="preview")
	public ModelAndView preview(final ModelMap model){
		String merchantCode = WebUtils.getSessionUser().getMerchantCode();
		User user  = userService.findByUserNo(new BigDecimal(merchantCode) );
		List<VendorServiceProvider> list = vendorServiceProviderService.preview(user.getUserName());
		model.put("serviceList", list);
		model.put("vendor", user);
		return super.toView(super.getUrl("mgt.vendorServiceProviderPreviewUI"));
	}
	
}
