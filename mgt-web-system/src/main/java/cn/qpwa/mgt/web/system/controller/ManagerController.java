package cn.qpwa.mgt.web.system.controller;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.qpwa.common.web.base.BaseController;

@Controller
@Scope("prototype")
@RequestMapping("/manager")
public class ManagerController extends BaseController {

	/**
	 * index
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "index")
	public ModelAndView index() {
		return super.toView(super.getUrl("mgt.manageIndex"));
	}

}
