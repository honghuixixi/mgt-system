package cn.qpwa.mgt.web.system.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.qpwa.mgt.facade.system.entity.MgtResource;
import cn.qpwa.mgt.facade.system.service.MgtResourceService;

@Controller
@Scope("prototype")
@RequestMapping("/test")
public class TestController{

	@Autowired
	private MgtResourceService mgtResourceService;
	
	@RequestMapping(value="index")
	@ResponseBody
	public MgtResource test(){
		MgtResource mgtResource = mgtResourceService.findById("4028ef194f6eeba4014f71cd24dd0001");
		System.out.println(mgtResource.toString());
		System.out.println("====Test successful===");
		System.out.println("======================");
		return mgtResource;
	}
}
