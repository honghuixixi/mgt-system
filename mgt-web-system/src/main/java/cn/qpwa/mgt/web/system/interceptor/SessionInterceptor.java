package cn.qpwa.mgt.web.system.interceptor;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.google.gson.Gson;

import cn.qpwa.common.constant.BizConstant;
import cn.qpwa.common.utils.LogEnabled;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.web.vo.UserVO;
import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import cn.qpwa.mgt.facade.system.service.MgtResourceService;

@SuppressWarnings("unchecked")
public class SessionInterceptor extends HandlerInterceptorAdapter implements LogEnabled {

	private final String COLUMN_URL = "URL";
	/**
	 * 不需要拦截的url
	 */
	private List<String> nofilter_list = new ArrayList<String>();
	@Autowired
	private MgtResourceService resourceService;

	public void init() {
		nofilter_list.add("/login/toLogin.jhtml");
		nofilter_list.add("/login/logindo.jhtml");
		nofilter_list.add("/login/toLoginWin.jhtml");
		nofilter_list.add("/payorder/payOrderSuccess.jhtml");
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String uri = request.getRequestURI();
		log.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"+uri);
		boolean exists_flag = nofilter_list.contains(uri);
		UserVO vo = WebUtils.getSessionUser();
		MgtEmployee employee = null;
		if (vo != null && StringUtils.isNotBlank(vo.getUsername())) {
			employee = new MgtEmployee();
			employee.setId(vo.getId());
			employee.setAccountName(vo.getUsername());
			employee.setUserName(vo.getUsername());
		}
		if (!exists_flag) {
			if (null == employee) {
				if (WebUtils.isAjaxRequest(request)) {
					response.setHeader("sessionstatus", "timeout");
				} else {
					// 设置回跳url
					// 去掉上下文
					int indexof = uri.indexOf("/controller");
					if (indexof > 0) {
						uri = uri.substring(indexof);
					}
					// 如果是首页不设置回跳地址
					if (!uri.equals("/manager/index.jhtml")) {
						WebUtils.setAttribute(BizConstant.BACK_URL, uri);
					}
					response.sendRedirect(request.getContextPath() + "/login/toLogin.jhtml");
					return false;
				}
			} else {
				if (!uri.equals("/manager/index.jhtml")) {
					boolean flag = false;
					List<Map<String, Object>> list = (List<Map<String, Object>>) WebUtils
							.getAttribute(BizConstant.SESSION_USER_AUTHORITY_MENU);
					log.info ("role|authoriity" + new Gson().toJson(list));
					for (Map<String, Object> menu : list) {
						List<Map<String, Object>> menuItems = (List<Map<String, Object>>) menu.get("menuItems");
						if (flag) {
							break;
						}
						for (Map<String, Object> menuItem : menuItems) {
							if (flag) {
								break;
							}
							List<Map<String, Object>> resourceItems = (List<Map<String, Object>>) menuItem
									.get("resourceItems");
							if (menuItem.containsKey(COLUMN_URL) && null != menuItem.get(COLUMN_URL)) {
								if (StringUtils.contains(uri.trim(),menuItem.get(COLUMN_URL).toString().trim())) {
									flag = true;
									WebUtils.setAttribute("resourceItems", resourceItems);
									break;
								}
							}
							for (Map<String, Object> resourceItem : resourceItems) {
								if (resourceItem.containsKey(COLUMN_URL) && null != resourceItem.get(COLUMN_URL)) {
									if (StringUtils.contains(uri.trim(),resourceItem.get(COLUMN_URL).toString().trim())) {
										flag = true;
										break;
									}
								}
							}
						}
					}
					if (!flag) {
						int result = resourceService.findResourceByUrl(uri);
						if (result > 0) {
							response.setContentType("text/html");
							response.setCharacterEncoding("UTF-8");
							PrintWriter out = response.getWriter();
							if (!WebUtils.isAjaxRequest(request)) {
								response.setHeader("sessionstatus", "timeout");
								out.print("<script> alert(\"没有操作权限\"); </script>");
							} else {
								out.print("<script> alert(\"没有操作权限\");history.go(-1); </script>");
							}
							return false;
						}
					}
				}
			}
		}
		return true;
	}
}