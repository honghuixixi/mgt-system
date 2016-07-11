package cn.qpwa.mgt.web.system.controller;

/**
 * MGT-地标管理
 * @author RJY
 * @data 2016年1月25日10:47:03
 *
 */
import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.mgt.facade.system.entity.LandmarkMas;
import cn.qpwa.mgt.facade.system.service.*;
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

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Scope("prototype")
@RequestMapping("/landMark")
@SuppressWarnings({ "unchecked" })
public class LandmarkMasController extends BaseController {
	@Autowired
	private LandmarkMasService landmarkMasService;
	@Autowired
	private UserService userService;


	/**
	 * 跳转地标管理页面
	 *
	 * @return
	 */
	@RequestMapping(value = "landMarkMasUI")
	public ModelAndView landMarkMasUI() {
		return super.toView(super.getUrl("mgt.landMarkMasUI"));
	}

	/**
	 * 获取地标管理列表信息
	 *
	 * @return
	 */
	@RequestMapping(value = "list")
	@ResponseBody
	public Object list() {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
//		List<Map<String, Object>> list = scuserAreaService.getAreaMasWebListByUserName(WebUtils.getSessionUser().getMerchantUserName());
//		String areaIds = "";
//		if(list != null && list.size()>0){
//			for(Map<String, Object> map : list){
//				areaIds = areaIds +","+map.get("AREA_ID");
//			}
//			areaIds = areaIds.substring(1);
//		}
//		jsonObject.put("areaIds", areaIds);
		//判断是否为超级管理员
		if("1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))){
			jsonObject.put("super", "");
		}
		jsonObject.put("userName", WebUtils.getSessionUser().getMerchantUserName());
		Page page = landmarkMasService.findLandMarkMasList(jsonObject, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"), JSONTools.getInt(jsonObject,
				"page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * 跳转新增地标页面
	 * @author RJY
	 * @data 2016年1月25日11:33:06
	 * @return
	 */
	@RequestMapping(value = "landMarkMasAddUI")
	public ModelAndView landMarkMasAddUI(final ModelMap modelMap) {
		JSONObject jobj = new JSONObject();
		jobj.put("merchantCode", WebUtils.getSessionUser().getMerchantCode());
		//判断是否为超级管理员
		if("1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))){
			jobj.put("super", "");
		}
		List<Map<String, Object>> mgtEmployeeList = userService.getSalesmenUser(jobj);
		modelMap.addAttribute("mgtEmployeeList", mgtEmployeeList);
		return super.toView(super.getUrl("mgt.landMarkMasAddUI"));
	}

	/**
	 * 添加地标信息
	 * @author RJY
	 * @data 2016年1月25日11:39:11
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	@ResponseBody
	public Msg add(){
		Msg msg=new Msg();
		try {
			LandmarkMas landMarkMas = new LandmarkMas();
			landMarkMas.setCode(jsonObject.getString("code"));
			landMarkMas.setName(jsonObject.getString("name"));
			landMarkMas.setStatusFlg(jsonObject.getString("statusFlg"));
			landMarkMas.setUserName(jsonObject.getString("userName"));
			String areaId_select = jsonObject.getString("areaId_select");
			String[] areaIds = StringUtils.split(areaId_select, ",");
			landMarkMas.setAreaIdL2(new BigDecimal(areaIds[1]));
			landMarkMas.setAreaIdL1(new BigDecimal(areaIds[0]));
			landMarkMas.setAreaId(new BigDecimal(jsonObject.getString("areaId")));
			if(jsonObject.getString("picNo")!=""){
				landMarkMas.setPicNo(new BigDecimal(jsonObject.getString("picNo")));
			}
			landMarkMas.setDescription(jsonObject.getString("description"));
			landMarkMas.setCreateDate(DateUtil.toTimestamp(new Date()));
			if(jsonObject.get("lat")!= "" && jsonObject.get("lng")!= "" && jsonObject.get("address")!= ""){
				landMarkMas.setLatitude(new BigDecimal(jsonObject.getString("lat")));
				landMarkMas.setLongitude(new BigDecimal(jsonObject.getString("lng")));
				landMarkMas.setAddress(jsonObject.getString("address"));
			}
			landmarkMasService.saveOrUpdate(landMarkMas);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 删去地标信息
	 *
	 * @return
	 */
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Msg delete() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				String id = jsonObject.getString("id");
			    msg = landmarkMasService.delete(id);
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
	 * 通过主键--启用
	 * @author RJY
	 * @date 2016年1月25日17:29:54
	 * @return
	 */
	@RequestMapping(value = "editStatusFlgY", method = RequestMethod.POST)
	@ResponseBody
	public Msg editStatusFlgY() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				String ids = jsonObject.getString("id");
				String[] idArray = StringUtils.split(ids, ",");
				landmarkMasService.editStatusFlgY(idArray);
				msg.setSuccess(true);
				msg.setMsg("操作成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("操作失败，请联系管理员！");
			}
		} else {
			msg.setMsg("操作失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 通过主键--停用
	 * @author RJY
	 * @date 2016年1月25日17:29:54
	 * @return
	 */
	@RequestMapping(value = "editStatusFlgN", method = RequestMethod.POST)
	@ResponseBody
	public Msg editStatusFlgN() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				String ids = jsonObject.getString("id");
				String[] idArray = StringUtils.split(ids, ",");
				landmarkMasService.editStatusFlgN(idArray);
				msg.setSuccess(true);
				msg.setMsg("操作成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("操作失败，请联系管理员！");
			}
		} else {
			msg.setMsg("操作失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 地标管理--跳转修改页面
	 * @author RJY
	 * @date 2016年1月26日11:05:26
	 */
	@RequestMapping(value = "edit")
	public ModelAndView edit(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		if(jobj==null){
			jobj=new JSONObject();
		}
		String uuid = jobj.getString("id");
		LandmarkMas landmarkMas = landmarkMasService.getLandMarkMasByUUID(uuid);
		jobj.put("areaIds", landmarkMas.getAreaId());
		//判断是否为超级管理员
		if("1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))){
			jobj.put("super", "");
		}
		List<Map<String, Object>> landMarkMasList = landmarkMasService.findShopByAreaId(jobj);
		if(StringUtils.isNotBlank(WebUtils.getSessionUser().getMerchantCode())){
			jobj.put("merchantCode", WebUtils.getSessionUser().getMerchantCode());
		}else{

		}
		List<Map<String, Object>> mgtEmployeeList = userService.getSalesmenUser(jobj);
		modelMap.addAttribute("landMarkMasList", landMarkMasList);
		modelMap.addAttribute("landmarkMas", landmarkMas);
		modelMap.addAttribute("mgtEmployeeList", mgtEmployeeList);
		return super.toView(super.getUrl("mgt.landMarkMasEdit"));
	}

	/**
	 * 地标管理--修改保存
	 * @author RJY
	 * @date 2016年1月26日14:27:50
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody
	public Msg save(){
		Msg msg=new Msg();
		try {
			String uuid = (String) jsonObject.get("uuid");
			LandmarkMas landMarkMas = landmarkMasService.getLandMarkMasByUUID(uuid);
			landMarkMas.setName(jsonObject.getString("name"));
			landMarkMas.setStatusFlg(jsonObject.getString("statusFlg"));
			landMarkMas.setUserName(jsonObject.getString("userName"));
			String areaId_select = jsonObject.getString("areaId_select");
			String[] areaIds = StringUtils.split(areaId_select, ",");
			landMarkMas.setAreaIdL2(new BigDecimal(areaIds[1]));
			landMarkMas.setAreaIdL1(new BigDecimal(areaIds[0]));
			landMarkMas.setAreaId(new BigDecimal(jsonObject.getString("areaId")));
			if(jsonObject.getString("picNo")!=""){
				landMarkMas.setPicNo(new BigDecimal(jsonObject.getString("picNo")));
			}
			landMarkMas.setDescription(jsonObject.getString("description"));
			landMarkMas.setCreateDate(DateUtil.toTimestamp(new Date()));
			if(jsonObject.get("lat")!= "" && jsonObject.get("lng")!= "" && jsonObject.get("address")!= ""){
				landMarkMas.setLatitude(new BigDecimal(jsonObject.getString("lat")));
				landMarkMas.setLongitude(new BigDecimal(jsonObject.getString("lng")));
				landMarkMas.setAddress(jsonObject.getString("address"));
			}
			landmarkMasService.saveOrUpdate(landMarkMas);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 检查code编码是否可用
	 * @author RJY
	 * @data 2016年1月14日11:15:20
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "findByCodeFlag", method = RequestMethod.POST)
	@ResponseBody
	public Msg findByNameFlag(final String code) {
		Msg msg = new Msg();
		boolean flag = false;
		try {
			List l = landmarkMasService.findByCode(code);
			if (null == l || l.size() == 0) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		msg.setData(flag);
		return msg;
	}

	@RequestMapping(value = "/selectOptions")
	public @ResponseBody
	Map<String, Object> selectOptions(String value) {
		JSONObject jobj = jsonObject;
		if(jobj==null){
			jobj=new JSONObject();
		}
		Map<String, Object> couples = new HashMap<String, Object>();
		Map<String, String> otheroptions = new HashMap<String, String>();
		jobj.put("areaIds", value);
		//判断是否为超级管理员
		if("1".equals(WebUtils.getAttribute(BizConstant.SESSION_USER_SUPER))){
			jobj.put("super", "");
		}
		List<Map<String, Object>> othoers = landmarkMasService.findShopByAreaId(jobj);
		if (othoers != null && othoers.size()>0) {
			//商铺列表
			for (int i=0; i<othoers.size();i++) {
				if(null!=othoers.get(i).get("USER_NAME")&&null!=othoers.get(i).get("NAME")){
					otheroptions.put(othoers.get(i).get("USER_NAME").toString(), othoers.get(i).get("NAME").toString());
				}
			}
		}
		couples.put("otheroptions", otheroptions);
		return couples;
	}
}
