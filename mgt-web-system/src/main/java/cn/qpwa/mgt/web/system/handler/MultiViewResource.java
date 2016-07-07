package cn.qpwa.mgt.web.system.handler;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.exception.ExceptionUtils;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.file.FileAttach;
import cn.qpwa.common.web.handler.SysConfigMapping;
import net.sf.json.JSONObject;

/**
 * 
 * @author andy
 *
 */
public  abstract class MultiViewResource  {
	
	
	
	@ExceptionHandler(Exception.class)
	public void exceptionHandler(Exception e,HttpServletResponse response){
		System.out.println(ExceptionUtils.getFullStackTrace(e));
		
		try {
			Msg msg = new Msg();
			msg.setMsg("系统出现错误了！");
			response.getWriter().write(msg.toJSONObject().toString());
		} catch (Exception ex) {
			e.printStackTrace();
		}
	}
	


	/*获取参数*/
	public JSONObject  jsonObject;

	/**
	 * 附件实体类
	 */
	private List<FileAttach> fileAttachs = null;


	public List<FileAttach> getfiles()
	{
		return this.fileAttachs;
	}
	
	public List<FileAttach> setfiles(List<FileAttach> fileAttachs)
	{
		return this.fileAttachs=fileAttachs;
	}

	
	
	public JSONObject getJsonObject() {
		return jsonObject;
	}

	public void setJsonObject(JSONObject jsonObject) {
		this.jsonObject = jsonObject;
	}
	
	
	
	/**
	 * 跳转页面
	 */
	protected ModelAndView toView(String path, Map<String, Object> model) {
		ModelAndView result = new ModelAndView(path, model);
		result.addAllObjects(model);
		return result;
	}

	/**
	 * 跳转页面
	 */
//	protected String toView(String path) {
//		return path;
//	}
	/**
	 * 重定位
	 * @param path
	 * @return
	 */
	protected String redirect(String path) {
		return "redirect:" + path;
	}
	
	/**
	 *  跳转
	 * @param path
	 * @return
	 */
	protected String forward(String path) {
		return "forward:" + path;
	}
	protected String getUrl(String key) {
		if ((SysConfigMapping.loadUrlMap != null) && (SysConfigMapping.loadUrlMap.containsKey(key))) {
			return (String) SysConfigMapping.loadUrlMap.get(key);
		}
		return "";
	}	 

	protected ModelAndView toView(String pagePath) {
		ModelAndView result = new ModelAndView(pagePath);
		return result;
	}

}
