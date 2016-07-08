package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtMenuService;
import cn.qpwa.mgt.facade.system.entity.MgtMenu;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.json.JSONTools;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/mgt")
@Scope("prototype")
@SuppressWarnings("all")
public class MgtMenuController extends BaseController {
	
	@Autowired
	private MgtMenuService mgtMenuService;
	
	@RequestMapping(value="/mgtMenuInfo")
	public	ModelAndView mgtMenuInfo(){
		return super.toView(super.getUrl("mgt.mgtMenuUI"));
	}
	
	@RequestMapping(value="/mgtType")
	@ResponseBody
	public Map<String,String> mgtType(String parentId){
		List<MgtMenu> mgtMenus = new ArrayList<MgtMenu>();
		Map<String,String> options = new HashMap<String,String>();
		if (parentId == null) {
			parentId = "-1";
			mgtMenus= mgtMenuService.fingMgtMenuByPid(parentId);
		} else {
			mgtMenus= mgtMenuService.fingMgtMenuByPid(parentId);
		}
		for(MgtMenu mgtMenu : mgtMenus){
			options.put(mgtMenu.getId(),mgtMenu.getName());
		}
		return options;
	}
	
	/**
	 * 跳转菜单编辑页面
	 */
	@RequestMapping(value="mgtMenuDetail")
	public String mgtMenuDetail(String id,ModelMap modelMap){
		MgtMenu mgtMenu = mgtMenuService.findById(id);
		modelMap.addAttribute("mgtMenu",mgtMenu);
		return super.getUrl("mgt.mgtMenuDetail");
	}
	
	
	/**
	 * 更改菜单
	 */
	@RequestMapping(value="mgtMenuUpdate")
	@ResponseBody
	public Msg mgtMenuUpdate(final HttpServletRequest request){
		Msg msg = new Msg();
		MgtMenu mgtMenu = mgtMenuService.findById(JSONTools.getString(jsonObject,"id"));
		if(mgtMenu != null){
			mgtMenu.setDescription(JSONTools.getString(jsonObject, "description"));
			mgtMenu.setContent(JSONTools.getString(jsonObject, "kindcontent"));
			try {
				mgtMenuService.saveOrUpdate(mgtMenu);
				msg.setSuccess(true);
				msg.setMsg("修改成功");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("修改失败，请联系管理员");
			}
		}
		return msg;
	}
	
	/**
	 *跳转到help页面
	 */
	@RequestMapping(value="mgtMenuHelp/{id}")
	@ResponseBody
	public Map mgtMenuHelp(@PathVariable String id){
		MgtMenu mgtMenu = mgtMenuService.findById(id);
		System.out.println("content="+mgtMenu.getContent());
		Map map = new HashMap();
		map.put("mgtMenu", mgtMenu);
		return map;
	}
	
}










