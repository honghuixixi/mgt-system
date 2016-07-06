package cn.qpwa.mgt.web.system.controller;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Scope("prototype")
@RequestMapping("/test")
public class TestController {

	@RequestMapping(value="index")
	public void test(){
		System.out.println("====Test successful===");
		System.out.println("======================");
	}
}
