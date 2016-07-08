package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtSettingDtlService;
import cn.qpwa.mgt.facade.system.service.MgtSettingService;
import cn.qpwa.mgt.facade.system.entity.MgtSettingDtl;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.web.vo.UserVO;
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
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

@Controller
@Scope("prototype")
@RequestMapping(value = "/mgtSettingDtl")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtSettingDtlController extends BaseController {

	@Autowired
	private MgtSettingDtlService mgtSettingDtlService;
	@Autowired
	private MgtSettingService mgtSettingService;
	
	/**
	 * 跳转到参数列表页面
	 * @author:lj
	 * @date 2015-7-27 上午10:35:49
	 * @return
	 */
	@RequestMapping(value = "userSettingInfo")
	public ModelAndView userSettingInfo(final ModelMap modelMap) {
		//查询参数
		JSONObject param = new JSONObject();
		UserVO user =  WebUtils.getSessionUser();
		String merchantCode = null;
		if(user!=null && StringUtils.isNotBlank(user.getMerchantCode())){
			merchantCode = user.getMerchantCode();
		}
		param.put("merchantCode", merchantCode);
		List<Map<String, Object>> userSettingList = mgtSettingDtlService.queryMgtSettingDtlList(param);
		modelMap.addAttribute("merchantCode", merchantCode);
		modelMap.addAttribute("userSettingList", userSettingList);
		return super.toView(super.getUrl("mgt.userSettingInfo"));
	}
	/**
	 * 查询列表
	 * @author:lj
	 * @date 2015-7-27 上午11:04:26
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object list(final ModelMap modelMap) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		jsonObject.put("userFlg", "Y");
		Page page = mgtSettingService.mgtSettingList(jsonObject,null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject,
				"page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());

		return pageView;
	}
	/**
	 * 跳转到新增商户系统参数配置
	 * @author:lj
	 * @date 2015-7-27 上午10:25:02
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "addUserSettingUI")
	public String addUserSettingUI(ModelMap modelMap) {
		modelMap.addAttribute("itemNo",jsonObject.getString("id"));
		return super.getUrl("mgt.addUserSettingUI");
	}
	/**
	 * 保存商户系统参数配置
	 * @author:lj
	 * @date 2015-7-27 上午10:26:28
	 * @return
	 */
	@RequestMapping(value = "addUserSetting", method = RequestMethod.POST)
	@ResponseBody
	public Msg addUserSetting() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("itemNo"))) {
			try {
				MgtSettingDtl mgtDtl = JSONTools.JSONToBean(jsonObject, MgtSettingDtl.class);
				UserVO user =  WebUtils.getSessionUser();
				String merchantCode = null;
				if(user!=null && StringUtils.isNotBlank(user.getMerchantCode())){
					merchantCode = user.getMerchantCode();
				}
				mgtDtl.setEmployeeId(merchantCode);
				mgtSettingDtlService.addMgtSettingDtl(mgtDtl);
				//查询参数
				JSONObject param = new JSONObject();
				param.put("merchantCode", merchantCode);
				List<Map<String, Object>> userSettingList = mgtSettingDtlService.queryMgtSettingDtlList(param);
				msg.setData(userSettingList);
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
	 * 保存商户系统参数配置
	 * @author:lj
	 * @date 2015-7-27 上午10:26:28
	 * @return
	 */
	@RequestMapping(value = "removeUserSetting", method = RequestMethod.POST)
	@ResponseBody
	public Msg removeUserSetting() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				UserVO user =  WebUtils.getSessionUser();
				String merchantCode = null;
				if(user!=null && StringUtils.isNotBlank(user.getMerchantCode())){
					merchantCode = user.getMerchantCode();
				}
				mgtSettingDtlService.deleteMgtSettingDtl(jsonObject.getString("id"), merchantCode);
				msg.setCode("success");
				msg.setMsg("删除成功！");
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
}
