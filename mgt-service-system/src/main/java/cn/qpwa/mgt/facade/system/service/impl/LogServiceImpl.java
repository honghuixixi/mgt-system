package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.constant.LogConstant;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.IPUtil;
import cn.qpwa.common.utils.http.HttpUtil;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.utils.json.JsonUtils;
import cn.qpwa.mgt.core.system.dao.SysBizLogDAO;
import cn.qpwa.mgt.core.system.dao.SysLoginLogDAO;
import cn.qpwa.mgt.facade.system.entity.SysBizActionLog;
import cn.qpwa.mgt.facade.system.entity.SysLoginLog;
import cn.qpwa.mgt.facade.system.service.LogService;
import cn.qpwa.mgt.facade.system.vo.User;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@Service("logService")
@SuppressWarnings({"rawtypes"})
@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
public class LogServiceImpl implements LogService {

	private static final Log LOG = LogFactory.getLog(LogServiceImpl.class);
	
	private static final String SESSION_USER_PARAM = "user";
	
	private User user = null;
	
	@Autowired
	private SysLoginLogDAO sysLoginLogDao;

	@Autowired
	private SysBizLogDAO sysBizLogDAO;

	/**
	 * 记录日志
	 * @param map 必要入参
	 * @param t 数据变化的entity实体
	 * @param busiType 1-登录日志 2-业务日志
	 * @throws Exception 
	 */
	@Override
	public <T> void log(Map<String, String> map,T t,int busiType){

		try{
			if(LOG.isDebugEnabled()){
				LOG.debug("=====LogServiceImpl#log()start=====");
				LOG.debug("map:"+JsonUtils.toJson(map));
				LOG.debug("T:"+JsonUtils.toJson(t));
				LOG.debug("busiType:"+busiType);
			}
			//入参检查
			checkParam(map,busiType);
			
			ServletRequestAttributes sra = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
			//获取session信息
			HttpServletRequest request = (sra!=null?sra.getRequest():null);
			HttpSession session = (request!=null?request.getSession():null);
			if(session==null){
				throw new Exception("failed to obtain session information");
			}
			
			if(user == null){
				user = new User();
				BeanUtils.copyProperties(session.getAttribute(SESSION_USER_PARAM), user);
				LOG.debug("userVO:"+user);
			}
	
			//获取系统时间
			Timestamp actionDate = new Timestamp(System.currentTimeMillis()); 
			//获取客户端真实ip地址
			String ipAddress = HttpUtil.getHostAddress();
			String area = IPUtil.getForSeparator(ipAddress,",");
			ipAddress += "(" + area + ")";
			//获取客户端机器名称
			String machineName = HttpUtil.getHostName();
			
			//获取浏览器信息
			String browserInfo = request.getHeader("User-Agent");
			if (LogConstant.SYS_LOGIN_LOG == busiType) {
				SysLoginLog sysLoginLog = new SysLoginLog();
				sysLoginLog.setUserNo(user.getUserNo());
				sysLoginLog.setUserName(user.getUsername());
				sysLoginLog.setName(user.getAccountName());
				sysLoginLog.setActionDate(actionDate);
				sysLoginLog.setIpAddress(ipAddress);
				sysLoginLog.setMachineName(machineName);
				sysLoginLog.setBrowserInfo(browserInfo);
				sysLoginLog.setActionCode(map.get(LogConstant.ACTION_CODE));
				sysLoginLog.setActionName(map.get(LogConstant.ACTION_NAME));
				LOG.debug("sysLoginLog:"+JsonUtils.toJson(sysLoginLog));
				sysLoginLogDao.save(sysLoginLog);
			} else if (LogConstant.SYS_BIZ_ACTION_LOG == busiType) {
				SysBizActionLog sysBizActionLog = new SysBizActionLog();
				sysBizActionLog.setUserNo(user.getUserNo());
				sysBizActionLog.setUserName(user.getUsername());
				sysBizActionLog.setName(user.getAccountName());
				sysBizActionLog.setActionDate(actionDate);
				sysBizActionLog.setIpAddress(ipAddress);
				sysBizActionLog.setMachineName(machineName);
				sysBizActionLog.setBrowserInfo(browserInfo);
				sysBizActionLog.setActionId(map.get(LogConstant.ACTION_ID));
				sysBizActionLog.setActionCode(map.get(LogConstant.ACTION_CODE));
				sysBizActionLog.setActionName(map.get(LogConstant.ACTION_NAME));
				sysBizActionLog.setBizModule(map.get(LogConstant.BIZ_MODULE));
				sysBizActionLog.setBizName(map.get(LogConstant.BIZ_NAME));
				sysBizActionLog.setBizContent(null!=t?JSONTools.toJson(t):null);
				sysBizActionLog.setActionType(map.get(LogConstant.ACTION_TYPE));;
				LOG.debug("sysBizLog:"+JsonUtils.toJson(sysBizActionLog));
				sysBizLogDAO.save(sysBizActionLog);
			} 
			
			LOG.debug("=====LogServiceImpl#log() end=====");
		}catch(Exception e){
			//通过利用线程运行栈StackTraceElement获得调用类的类名与方法名
			StackTraceElement stacks[] = (new Throwable()).getStackTrace();
			StackTraceElement stack = null;
			for(StackTraceElement sta:stacks){
				String regex = "c(n|om).qpwa.(controller|service)";
				Pattern p = Pattern.compile(regex);
				Matcher matcher = p.matcher(sta.getClassName());
				if(matcher.find()){
					stack = sta;
					break;
				}
			}
			if(null!=stack){
				String className = stack.getClassName();
				String methodName = stack.getMethodName();
				StringBuffer sbf = new StringBuffer();
				sbf.append('"');
				sbf.append(className);
				sbf.append("#");
				sbf.append(methodName);
				sbf.append("[");
				if (null != map) {
					sbf.append((null != map.get(LogConstant.ACTION_TYPE) ? map.get(LogConstant.ACTION_TYPE) : null)
							+ "_" + null != t ? t.getClass().getName() : null);
				}
				sbf.append("]:");
				sbf.append(e.getMessage());
				LOG.info(sbf.toString());
			}
		}

	}
	
	@Override
	public <T> void logByApp(Map<String, String> map, T t, int busiType,
			User user) {
		
		if(LOG.isDebugEnabled()){
			LOG.debug("=====LogServiceImpl#logByApp()start=====");
			LOG.debug("map:"+JsonUtils.toJson(map));
			LOG.debug("T:"+JsonUtils.toJson(t));
			LOG.debug("busiType:"+busiType);
		}
		
		if(user==null){
			LOG.info("user is null from app!");
		}
		this.user = user;
		this.log(map, t, busiType);
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Page findSysLogPage(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		return sysBizLogDAO.findSysLogPage(paramMap,orderby);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public SysBizActionLog get(BigDecimal id) {
		return sysBizLogDAO.get(id);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Map<String, Object>> findNearestSysLog(Map<String, Object> paramMap) {
		return sysBizLogDAO.findNearestSysLog(paramMap);
	}
	
	/**
	 * 校验入参
	 * @param map
	 * @param busiType
	 * @throws Exception
	 */
	private void checkParam(Map<String,String>map,int busiType) throws Exception{
		if(null == map || 0 == map.size()){
			throw new Exception("input map cannot be null or the size of the map cannot equals 0");
		}
		if(busiType!=LogConstant.SYS_LOGIN_LOG && busiType!=LogConstant.SYS_BIZ_ACTION_LOG){
			throw new Exception("the value of busiType is correct");
		}
		if(!map.containsKey(LogConstant.ACTION_CODE)){
			throw new Exception("input map lack of action code");
		}
		if(!map.containsKey(LogConstant.ACTION_NAME)){
			throw new Exception(" map lack of action name");
		}
		if(busiType == LogConstant.SYS_BIZ_ACTION_LOG){
			if(!map.containsKey(LogConstant.ACTION_ID)){
				throw new Exception("map lack of action id");
			}
			if(null == map.get(LogConstant.ACTION_ID)){
				throw new Exception("the value of action id in map can not be null");
			}
			if(!map.containsKey(LogConstant.ACTION_TYPE)){
				throw new Exception("map lack of action type");
			}
			if(!map.containsKey(LogConstant.BIZ_MODULE)){
				throw new Exception("map lack of biz module");
			}
			if(!map.containsKey(LogConstant.BIZ_NAME)){
				throw new Exception("map lack of biz name");
			}
		}
	}
    
	@Override
	public Page getLoginInfoList(Map<String, Object> param) {
		return sysLoginLogDao.getLoginInfoList(param);
	}
}
