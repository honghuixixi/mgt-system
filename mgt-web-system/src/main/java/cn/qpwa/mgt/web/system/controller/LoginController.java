package cn.qpwa.mgt.web.system.controller;

import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.constant.LogConstant;
import cn.qpwa.common.log.service.LogService;
import cn.qpwa.common.utils.MapUtil;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.web.vo.UserVO;
import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import cn.qpwa.mgt.facade.system.entity.User;
import cn.qpwa.mgt.facade.system.service.MgtEmployeeService;
import cn.qpwa.mgt.facade.system.service.UserService;

/**
 * 登录、注销Controller
 * 
 */
@Controller
@Scope("prototype")
@RequestMapping("/login")
public class LoginController extends BaseController {

	@Autowired
	private MgtEmployeeService mgtEmployeeService;
	@Autowired
	private UserService userService;
	@Autowired
	private LogService logService;
	
	/**
	 * 跳转登录页面
	 * @return
	 */
	@RequestMapping(value = "toLogin")
	public String toLogin() {
		return super.getUrl("login.toLogin");
	}

	/**
	 * 跳转登录页面(用于弹出框登录)
	 * @return
	 */
	@RequestMapping(value = "toLoginWin")
	public ModelAndView toLoginWin() {
		return super.toView(super.getUrl("login.toLoginWin"));
	}

	/**
	 * 登录
	 * @return
	 */
	@RequestMapping(value = "logindo")
	public String logindo(final ModelMap modelMap,MgtEmployee employee, HttpServletRequest httpRequest, HttpServletResponse response) {
		MgtEmployee localUser=null;
		Msg msg = null; 
		User user = null;
		//Employee查找、登录
	    localUser = mgtEmployeeService.findLoginEmployee(employee);
		if(null==localUser){
			modelMap.addAttribute("errorinfo", new Msg(false,"未知用户"));
		}else if(null!=localUser && "1".equals(localUser.getStatus())){
			BigDecimal pass = userService.getPassword(employee.getPassword());
			String passWord = pass.toString();
		  //登录
		  if(StringUtils.isNotBlank(employee.getPassword()) && passWord.equals(localUser.getPassword())){
			Map<String, Object> authorityMap = mgtEmployeeService.findRoleResourceByEmployee(localUser);
			String vendorBlockFlg = "N";//
			String merchantUserName = null;
			BigDecimal userNo = null;
			String username = null;
			if(!"superadmin".equals(localUser.getAccountName())){
				if(StringUtils.isNotBlank(localUser.getMerchantCode())){
				//供应商
				user  =  userService.findByUsername(localUser.getAccountName());
				userNo = user.getUserNo();
				username = user.getUserName();
				//企业登录名不为空，直接取企业账号，企业登录名为空，则为企业账号
				if(user.getRefUserName()!=null){
					merchantUserName = user.getRefUserName();
					User vendor =  userService.findByUsername(user.getRefUserName());
					//供应商被锁定状态
					vendorBlockFlg = vendor.getBlockFlg();
				}else{
					merchantUserName = user.getUserName();
					vendorBlockFlg = user.getBlockFlg();
				}
				}
			}else{
				username = localUser.getAccountName();
			}
			
			if (null == authorityMap || authorityMap.size() <= 0||"Y".equals(localUser.getBlockFlg())||"Y".equals(vendorBlockFlg)) {
				// 该用户没有设置权限
				modelMap.addAttribute("errorinfo", new Msg(false,"此用户未分配权限"));
				return this.toLogin();
			}
			// 将用户信息设置到session中
			WebUtils.setAttribute(BizConstant.SESSION_USER_SUPER, authorityMap.get(BizConstant.SESSION_USER_SUPER).toString());
			WebUtils.setAttribute(BizConstant.SESSION_KEY, localUser);
			WebUtils.setAttribute(BizConstant.SESSION_USER_AUTHORITY_MENU, authorityMap.get("menus"));
			modelMap.addAttribute(BizConstant.SESSION_USER_AUTHORITY_MENU, authorityMap.get("menus"));
			WebUtils.setAttribute(BizConstant.SESSION_USER_AUTHORITY_ROLE, authorityMap.get("roles"));
			modelMap.addAttribute(BizConstant.SESSION_USER_AUTHORITY_ROLE, authorityMap.get("roles"));
			//当前登录用户
			UserVO vo = new UserVO();
			vo.setId(localUser.getId());
			vo.setAccountName(localUser.getAccountName());
			vo.setMerchantCode(localUser.getMerchantCode());
			vo.setUserName(localUser.getUserName());
			vo.setCustomId(localUser.getCustomId());
			vo.setStatus(localUser.getStatus());
			vo.setUserCode(localUser.getUserCode());
			vo.setMobile(localUser.getMobile());
			vo.setWhC(localUser.getWhC());
			vo.setMerchantUserName(merchantUserName);
			//登录用户的用户名和编号
			vo.setUserNo(userNo);
			vo.setUsername(username);
			WebUtils.setSessionUser(vo);
			
			logService.log(MapUtil.orgLoginLogMap(MapUtil.LOGIN), null, LogConstant.SYS_LOGIN_LOG);
			
			// 判断是否是ajax请求
			if (WebUtils.isAjaxRequest(httpRequest)) {
				PrintWriter out = null;
				try {
					msg = new Msg();
					msg.setSuccess(true);
					msg.setMsg("成功");
					out = response.getWriter();
					out.print(msg.toJSONObject().toString());
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					IOUtils.closeQuietly(out);
				}
				return null;

			} else {
				return "redirect:/manager/index.jhtml";
			}
		  }
			//密码错误
			modelMap.addAttribute("errorinfo", new Msg(false,"密码错误"));
		} else {
			// 未找到用户信息
			modelMap.addAttribute("errorinfo", new Msg(false,"无效用户"));
		}
		return this.toLogin();
	}

	/**
	 * 注销
	 * 
	 * @return
	 */
	@RequestMapping(value = "loginout")
	public String loginout(HttpServletRequest httpRequest) {
		logService.log(MapUtil.orgLoginLogMap(MapUtil.LOGOUT), null, LogConstant.SYS_LOGIN_LOG);
		return this.toLogin();
	}

	/**
	 * 获取seesionuser
	 * @return
	 */
	@RequestMapping(value = "getSessionEmployee", method = RequestMethod.POST)
	@ResponseBody
	public Msg getSessionEmployee(final HttpServletRequest request) {
		Msg msg = new Msg();
		UserVO vo = WebUtils.getSessionUser();
		MgtEmployee employee = new MgtEmployee();
		employee.setAccountName(vo.getUsername());
		employee.setUserName(vo.getUsername());
		employee.setId(vo.getId());
		msg.setData(employee);
		return msg;
	}
}
