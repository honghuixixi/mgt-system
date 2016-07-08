package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.MgtEmployeeService;
import cn.qpwa.mgt.facade.system.service.MgtMenuService;
import cn.qpwa.mgt.facade.system.service.MgtResourceService;
import cn.qpwa.mgt.facade.system.service.MgtRoleService;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.utils.Msg;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 角色资源分配视图 
 * @author liujing
 *
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/mgtRole")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtRoleController extends BaseController {

	@Autowired
	private MgtRoleService mgtRoleService;
	@Autowired
	private MgtResourceService mgtResourceService;
	@Autowired
	private MgtMenuService mgtMenuService;
    @Autowired
    private MgtEmployeeService mgtEmployeeService;
	
/*	@RequestMapping(value="roleResourceList")
	public ModelAndView roleResourceList(){
		return super.toView(super.getUrl("mgt.roleResourceList"));
	}*/
	/**
	 * 查询登陆用户的权限分配情况
	 * @author:lj
	 * @date 2015-6-8 下午3:13:39
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "roleResourceList")
	public ModelAndView roleResourceList(final ModelMap modelMap){
		/*//查询该用户对应的所有角色。
		List employeeRole = mgtRoleService.findEmployeeRoleByEmployeeId(WebUtils.getSessionUser().getId());
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("status", "1");
		paramMap.put("employeeId", WebUtils.getSessionUser().getId());
		if (StringUtils.isNotBlank(WebUtils.getSessionUser().getMerchantCode()))
			paramMap.put("merchantCode", WebUtils.getSessionUser().getMerchantCode());
		//查询该商户下的角色
		List<MgtRole> roleList = mgtRoleService.findRoleListByMap(paramMap);
		List<MgtRole> newRoleList =  new ArrayList<MgtRole>();
		for(int i=0;i<roleList.size();i++){
			MgtRole role = roleList.get(i);
			//单选框是否选中，默认不选
			String checkState = "n";
			for(int j=0;j<employeeRole.size();j++){
				Map eRole = (Map)employeeRole.get(j);
				//如果id相同，设置状态为y
				if(eRole.get("ROLE_ID").toString().equals(role.getId())){
					checkState = "y";
				}
			}
			role.setVisible(checkState);
			newRoleList.add(role);
			//重新初始化
			checkState = "n";
		}
//		UserVO user = WebUtils.getSessionUser();
		modelMap.addAttribute("employeeRoleList", employeeRole);
		modelMap.addAttribute("roleList", newRoleList);
		modelMap.addAttribute("employeeId", WebUtils.getSessionUser().getId());
		modelMap.addAttribute("accountName", WebUtils.getSessionUser().getAccountName());
		//根据角色查询用户对应的所有权限（菜单和资源）
		List<String> roleIds = new ArrayList<String>(roleList.size());
		for (int i=0;i<employeeRole.size();i++) {
			Map role = (Map)employeeRole.get(i);
			roleIds.add(role.get("ROLE_ID").toString());
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("roleIds", roleIds);
		param.put("status", "1");
        //查询用户角色下所有的菜单
        List menuList = mgtMenuService.queryMenuListByRoleIds(param);
        //查询用户角色下所有的资源
        List  resourceList= mgtResourceService.queryResourceListByRoleIds(param);
        *//****设置角色菜单为空的显示start****//*
        //循环取出找到没有菜单的角色，赋予空值。
        List<String> menuRoleIds = new ArrayList<String>();
        String menuRoleId = "";
        for(int i=0;i<menuList.size();i++){
        	Map menuRole = (Map)menuList.get(i);
        	if(i==0){
        		menuRoleId = menuRole.get("ROLE_ID").toString();
        	}else{
        		if(!menuRoleId.equals(menuRole.get("ROLE_ID").toString())){
        			menuRoleIds.add(menuRoleId);
        			menuRoleId = menuRole.get("ROLE_ID").toString();
        		}
        		if(i==(menuList.size()-1)){
        			menuRoleIds.add(menuRoleId);
        		}
        	}        	
        }
        //删除有菜单的角色id，留下的都是没有菜单的角色id
        roleIds.removeAll(menuRoleIds);
        //赋予空值
        if(roleIds!=null && roleIds.size()>0){

            for(String roleId:roleIds){
                Map map = new HashMap();
                MgtRole role = mgtRoleService.findById(roleId);
                map.put("ROLE_NAME",role.getName());
                map.put("ROLE_ID",roleId);
                map.put("NAME",null);
                map.put("ID",null);
                menuList.add(map);
            }

        }
        *//****设置角色菜单为空的显示end****//*
       
		modelMap.addAttribute("resourceList", resourceList);
		modelMap.addAttribute("menuList", menuList);*/
		return super.toView(super.getUrl("mgt.roleResourceList"));

	}
	/**
	 * 分配角色并查询菜单
	 * @author:lj
	 * @date 2015-6-10 下午1:52:55
	 */
	@RequestMapping(value = "assignRole")
	@ResponseBody
	public Object assignRole(final ModelMap modelMap){
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("roleId"))) {
			try {
				jsonObject.put("addFlag", true);
				String employeeId = jsonObject.getString("employeeId");
				if(StringUtils.isNotBlank(employeeId)){
					employeeId = WebUtils.getSessionUser().getId();
				}
				jsonObject.put("employeeId", employeeId);
				mgtRoleService.saveRoleEmployee(jsonObject);
				List<String> roleIds = new ArrayList<String>();
				roleIds.add(jsonObject.getString("roleId"));
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("roleIds", roleIds);
				param.put("status", "1");
				//查询用户角色下所有的资源
				List  resourceList= mgtResourceService.queryResourceListByRoleIds(param);
				//查询用户角色下所有的菜单
				List menuList = mgtMenuService.queryMenuListByRoleIds(param);
				modelMap.addAttribute("resourceList", resourceList);
				modelMap.addAttribute("menuList", menuList);
                JSONObject json = new JSONObject();
                json.put("resourceList",resourceList);
                json.put("menuList",menuList);
                msg.setData(json);
				msg.setMsg("保存成功！");
				msg.setCode("001");
				msg.setSuccess(true);
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("保存失败，请联系管理员！");
			}
		} else {
			msg.setMsg("保存失败，请联系管理员！");
		}
	    return msg.toJSONObject("yyyy-MM-dd").toString();
	}
	/**
	 * 取消分配角色，相应的菜单删除掉
	 * @author:lj
	 * @date 2015-6-10 下午1:52:55
	 */
	@RequestMapping(value = "cancleAssignRole")
	@ResponseBody
	public Object cancleAssignRole(final ModelMap modelMap){
		Msg msg = new Msg();
		if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("roleId"))) {
			try {
				String employeeId = jsonObject.getString("employeeId");
				if(StringUtils.isNotBlank(employeeId)){
					employeeId = WebUtils.getSessionUser().getId();
				}
				jsonObject.put("employeeId", employeeId);
				mgtRoleService.deleteEmployeeRoleRelation(jsonObject);
				msg.setMsg("删除成功！");
                msg.setCode("001");
				msg.setSuccess(true);
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("删除失败，请联系管理员！");
			}
		} else {
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg.toJSONObject("yyyy-MM-dd").toString();
	}
    @RequestMapping(value="search")
    @ResponseBody
    public Object  search(final ModelMap modelMap){
        Msg msg = new Msg();
        if (jsonObject != null && StringUtils.isNotBlank(jsonObject.getString("accountName"))) {
            try {
                MgtEmployee paramEmployee = new MgtEmployee();
//                UserVO user = WebUtils.getSessionUser();
                paramEmployee.setAccountName(jsonObject.getString("accountName"));
                paramEmployee.setMerchantCode(WebUtils.getSessionUser().getMerchantCode());
                MgtEmployee mgtEmployee =  mgtEmployeeService.findEmployeeByParam(paramEmployee) ;
                if(mgtEmployee != null){
                	//定义返回值的json数据
                	JSONObject json = new JSONObject();
                    String employeeId = mgtEmployee.getId();
                    String merchantCode = mgtEmployee.getMerchantCode();
                    modelMap.addAttribute("employeeId", employeeId);
                    modelMap.addAttribute("accountName", mgtEmployee.getAccountName());
                    //查询该用户对应的所有角色。
                    List employeeRole = mgtRoleService.findEmployeeRoleByEmployeeId(employeeId);
                    Map<String, Object> paramMap = new HashMap<String, Object>();
                    paramMap.put("status", "1");
                    paramMap.put("employeeId", employeeId);
                    if (StringUtils.isNotBlank(merchantCode)){
                        paramMap.put("merchantCode", merchantCode);
                    }
                    //查询该商户下的角色
                    List<MgtRole> roleList = mgtRoleService.findRoleListByMap(paramMap);
                    /**
                     * 判断角色列表是否为空，不为空的情况下才能查询权限
                     */
                    if(employeeRole!=null && employeeRole.size()>0 && roleList !=null && roleList.size()>0){
                    	List<MgtRole> newRoleList =  new ArrayList<MgtRole>();
	                    for(int i=0;i<roleList.size();i++){
	                        MgtRole role = roleList.get(i);
	                        //单选框是否选中，默认不选
	                        String checkState = "n";
	                        for(int j=0;j<employeeRole.size();j++){
	                            Map eRole = (Map)employeeRole.get(j);
	                            //如果id相同，设置状态为y
	                            if(eRole.get("ROLE_ID").toString().equals(role.getId())){
	                                checkState = "y";
	                            }
	                        }
	                        role.setVisible(checkState);
	                        newRoleList.add(role);
	                        //重新初始化
	                        checkState = "n";
	                    }
                    
	                    modelMap.addAttribute("roleList", newRoleList);
	                    modelMap.addAttribute("employeeRoleList", employeeRole);
	                    //根据角色查询用户对应的所有权限（菜单和资源）
	                    List<String> roleIds = new ArrayList<String>(roleList.size());
	                    for (int i=0;i<employeeRole.size();i++) {
	                        Map role = (Map)employeeRole.get(i);
	                        roleIds.add(role.get("ROLE_ID").toString());
	                    }
	                    Map<String, Object> param = new HashMap<String, Object>();
	                    param.put("roleIds", roleIds);
	                    param.put("status", "1");
	                    //查询用户角色下所有的菜单
	                    List menuList = mgtMenuService.queryMenuListByRoleIds(param);
	                    
	                    //查询用户角色下所有的资源
	                    List  resourceList= mgtResourceService.queryResourceListByRoleIds(param);
	                    if(resourceList!=null && resourceList.size()>0){
	                    	 modelMap.addAttribute("resourceList", resourceList);
	                    }
	                    /****设置角色菜单为空的显示start****/
	                    if(menuList!=null && menuList.size()>0){
	                    	//循环取出找到没有菜单的角色，赋予空值。
		                    List<String> menuRoleIds = new ArrayList<String>();
		                    String menuRoleId = "";
		                    for(int i=0;i<menuList.size();i++){
		                        Map menuRole = (Map)menuList.get(i);
		                        if(i==0){
		                            menuRoleId = menuRole.get("ROLE_ID").toString();
		                        }else{
		                            if(!menuRoleId.equals(menuRole.get("ROLE_ID").toString())){
		                                menuRoleIds.add(menuRoleId);
		                                menuRoleId = menuRole.get("ROLE_ID").toString();
		                            }
		                            if(i==(menuList.size()-1)){
		                                menuRoleIds.add(menuRoleId);
		                            }
		                        }
		                    }
		                    //删除有菜单的角色id，留下的都是没有菜单的角色id
		                    roleIds.removeAll(menuRoleIds);
		                    //赋予空值
		                    if(roleIds!=null && roleIds.size()>0){
	
		                        for(String roleId:roleIds){
		                            Map map = new HashMap();
		                            MgtRole role = mgtRoleService.findById(roleId);
		                            map.put("ROLE_NAME",role.getName());
		                            map.put("ROLE_ID",roleId);
		                            map.put("NAME",null);
		                            map.put("ID",null);
		                            menuList.add(map);
		                        }
	
		                    }
		                    /****设置角色菜单为空的显示end****/
		                    modelMap.addAttribute("menuList", menuList);
	                    }

	                    json.put("roleList",newRoleList);
	                    json.put("resourceList",resourceList);
	                    json.put("menuList",menuList);
	                    
                    }
                   
                    msg.setData(json);
                    msg.setMsg("查询成功！");
                    msg.setCode("001");
                    msg.setSuccess(true);
                }else{
                    msg.setMsg("该用户查询不到！");
                    msg.setCode("002");
                    msg.setSuccess(false);
                }

            } catch (Exception e) {
                e.printStackTrace();
                msg.setMsg("查询失败，请联系管理员！");
            }
        } else {
            msg.setMsg("参数为空，请联系管理员！");
        }
        return msg.toJSONObject("yyyy-MM-dd").toString();
    }
}
