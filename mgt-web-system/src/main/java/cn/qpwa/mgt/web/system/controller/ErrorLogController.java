package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.ErrorLogService;
import cn.qpwa.mgt.facade.system.entity.ErrorLog;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.Clob;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Map;


/**
 * 错误日志视图展示类
 * @author TheDragonLord
 *
 */
@Controller
@Scope("prototype")
@RequestMapping(value="/errorLog")
@SuppressWarnings("all")
public class ErrorLogController extends BaseController {
	
	@Autowired
	private ErrorLogService errorLogService;
	
	/**
	 * 跳转错误日志页面
	 * @return
	 */
	@RequestMapping(value="/errorLogInfo")
	private ModelAndView errorLogInfo(){
		return super.toView(super.getUrl("mgt.errorLogUI"));
	}
	
	/**
	 * 获取错误信息列表
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value="/errorLogList")
	@ResponseBody
	public Object errorLogList(){
		SystemContext.setPagesize(JSONTools.getInt(jsonObject,"rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = errorLogService.getErrorLogList(jsonObject,null);
		System.out.println(page.toString());
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}
	
	/**
	 * 跳转到错误日志详情页面
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value="/errorLogDetail")
	public String errorLogDetail(final ModelMap modelMap){
		String errorCode = jsonObject.getString("id");
		Map<String,Object> errorLogDetail = errorLogService.getErrorLogDetail(errorCode);
		Clob c = (Clob)errorLogDetail.get("RETURN_CODE");
		String returnCode = this.ClobToString(c);
		errorLogDetail.put("RETURN_CODE", this.ClobToString(c));
		errorLogDetail.put("userId", WebUtils.getSessionUser().getAccountName());
		modelMap.addAttribute("errorLogDetail",errorLogDetail);
		return getUrl("mgt.errorLogDetialUI");
	}
	
	/**
	 * 更新错误日志
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/errorLogSolve")
	@ResponseBody
	public Msg errorLogSolve(final HttpServletRequest request){
		Msg msg = new Msg();
		ErrorLog errorLog = errorLogService.findById(JSONTools.getString(jsonObject, "errorCode"));
		if(errorLog != null){
			errorLog.setStatusFlg("2");
			errorLog.setUserName(JSONTools.getString(jsonObject, "userNo"));
			errorLog.setWorkDate(new Timestamp(System.currentTimeMillis()));
			errorLog.setWorkResult(JSONTools.getString(jsonObject, "workResult"));
			try{
				errorLogService.saveOrUpdate(errorLog);
				msg.setSuccess(true);
				msg.setMsg("修改成功");
			} catch (Exception e){
				e.printStackTrace();
				msg.setMsg("修改失败，请联系管理员");
			}
		}
		return msg;
	}
	
    public String ClobToString(Clob clob) {
        String reString = "";
        Reader is = null;
        if(clob == null){
        	return "";
        }
        try {
            is = clob.getCharacterStream();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        BufferedReader br = new BufferedReader(is);
        String s = null;
        try {
            s = br.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        StringBuffer sb = new StringBuffer();
        while (s != null) {
            sb.append(s);
            try {
                s = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        reString = sb.toString();
        return reString;
    }
	
	
	
}
