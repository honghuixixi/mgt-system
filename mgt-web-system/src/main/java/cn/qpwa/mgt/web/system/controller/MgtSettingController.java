package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtSettingService;
import cn.qpwa.mgt.facade.system.entity.MgtSetting;
import cn.qpwa.common.utils.LogEnabled;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import org.codehaus.plexus.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;

/**
 * 系统参数设置类
 * @author TheDragonLord
 *
 */
@Controller
@Scope("prototype")
@RequestMapping(value="/mgtSetting")
@SuppressWarnings({"rawtypes","unchecked","unused"})
public class MgtSettingController extends BaseController implements LogEnabled{
	
	@Autowired
	MgtSettingService mgtSettingService;
	
	/**
	 * 跳转系统参数页面
	 */
	@RequestMapping("/mgtSettingInfo")
	public ModelAndView  mgtSettingInfo(){
		return super.toView(super.getUrl("mgt.mgtSettingInfo"));
	}
	
	/**
	 * 查找系统参数列表
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/mgtSettingList")
	@ResponseBody
	public Object mgtSettingList(final ModelMap modelMap){
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = mgtSettingService.mgtSettingList(jsonObject,null);
		log.debug("page"+page);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}
	
	/**
	 * 删除系统参数信息
	 */
	@RequestMapping(value="/mgtSettingDelete",method=RequestMethod.POST)
	@ResponseBody
	public Msg mgtSettingDelete(){
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("id"))) {
			try {
				String ids = jsonObject.getString("id");
				String[] idArray = StringUtils.split(ids,",");
				mgtSettingService.mgtSettingDelete(idArray);
				msg.setSuccess(true);
				msg.setMsg("删除成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("删除失败，请联系管理员");
			}
		} else {
			msg.setMsg("删除失败，请联系管理员");
		}
		return msg;
	}
	
	/**
	 * 跳转到添加系统参数页面
	 */
	@RequestMapping(value="mgtSettingAddUI")
	public String mgtSettingAddUI(){
		return getUrl("mgt.mgtSettingAddUI");
	}
	
	/**
	 * 添加系统参数
	 */
	@RequestMapping(value="/mgtSettingAdd")
	@ResponseBody
	public Msg add(){
		Msg msg = new Msg();
		try {
			MgtSetting mgtSetting = JSONTools.JSONToBean(jsonObject, MgtSetting.class);
			BigDecimal itemNo = mgtSettingService.findMaxId();
			BigDecimal num = new BigDecimal(1);
			itemNo = itemNo.add(num);
			
			BigDecimal sortNo = mgtSettingService.findMaxSort();
			mgtSetting.setSortNo(sortNo.add(new BigDecimal(1)));
			mgtSetting.setItemNo(itemNo);
			mgtSettingService.saveOrUpdate(mgtSetting);
			msg.setSuccess(true);
			msg.setMsg("保存成功");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}
	
	/**
	 * 跳转到编辑系统参数页面
	 */
	@RequestMapping(value="/mgtSettingEditUI")
	public String mgtSettingEditUI(ModelMap modelMap){
		BigDecimal id = JSONTools.getBigDecimal(jsonObject, "id");
		MgtSetting mgtSetting = mgtSettingService.findById(JSONTools.getBigDecimal(jsonObject, "id"));
		modelMap.addAttribute("mgtSetting",mgtSetting);
		return getUrl("mgt.mgtSettingEditUI");
	}
	
	@RequestMapping(value="/mgtSettingEdit")
	@ResponseBody
	public Msg mgtSettingEdit(){
		Msg msg = new Msg();
		try {
			MgtSetting mgtSetting = JSONTools.JSONToBean(jsonObject, MgtSetting.class);
			mgtSettingService.saveOrUpdate(mgtSetting);
			msg.setSuccess(true);
			msg.setMsg("修改成功");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("修改失败，请联系管理员");
		}
		return msg;
	}
}




















