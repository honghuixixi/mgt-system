package cn.qpwa.common.web.base;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Enumeration;
import java.util.Set;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.ConstraintViolation;
import javax.validation.Validator;

import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import cn.qpwa.common.utils.HtmlCleanEditor;
import cn.qpwa.common.utils.date.DateEditor;
import cn.qpwa.common.utils.setting.Setting;
import cn.qpwa.common.utils.setting.SettingUtils;
import cn.qpwa.common.web.handler.SysConfigMapping;
import cn.qpwa.common.web.template.directive.FlashMessageDirective;
import cn.qpwa.common.web.utils.Message;
import cn.qpwa.common.web.utils.SpringUtils;
import cn.qpwa.common.web.utils.WebUtils;
import net.sf.json.JSONObject;

/**
 * Controller - 基类
 */
@SuppressWarnings("rawtypes")
public class BaseController {

	/** 错误视图 */
	protected static final String ERROR_VIEW = "/shop/common/error";

	/** 错误消息 */
	protected static final Message ERROR_MESSAGE = Message.error("shop.message.error");

	/** 成功消息 */
	protected static final Message SUCCESS_MESSAGE = Message.success("shop.message.success");// 操作成功

	/** "验证结果"参数名称 */
	private static final String CONSTRAINT_VIOLATIONS_ATTRIBUTE_NAME = "constraintViolations";

	@Resource(name = "validator")
	private Validator validator;

	protected JSONObject jsonObject;

	/**
	 * 数据绑定
	 * 
	 * @param binder
	 *            WebDataBinder
	 */
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(String.class, new HtmlCleanEditor(true, true));
		binder.registerCustomEditor(Date.class, new DateEditor(true));
	}

	/**
	 * 数据验证
	 * 
	 * @param target
	 *            验证对象
	 * @param groups
	 *            验证组
	 * @return 验证结果
	 */
	protected boolean isValid(Object target, Class<?>... groups) {
		Set<ConstraintViolation<Object>> constraintViolations = validator.validate(target, groups);
		if (constraintViolations.isEmpty()) {
			return true;
		} else {
			RequestAttributes requestAttributes = RequestContextHolder.currentRequestAttributes();
			requestAttributes.setAttribute(CONSTRAINT_VIOLATIONS_ATTRIBUTE_NAME, constraintViolations,
					RequestAttributes.SCOPE_REQUEST);
			return false;
		}
	}

	/**
	 * 数据验证
	 * 
	 * @param type
	 *            类型
	 * @param property
	 *            属性
	 * @param value
	 *            值
	 * @param groups
	 *            验证组
	 * @return 验证结果
	 */
	protected boolean isValid(Class<?> type, String property, Object value, Class<?>... groups) {
		Set<?> constraintViolations = validator.validateValue(type, property, value, groups);
		if (constraintViolations.isEmpty()) {
			return true;
		} else {
			RequestAttributes requestAttributes = RequestContextHolder.currentRequestAttributes();
			requestAttributes.setAttribute(CONSTRAINT_VIOLATIONS_ATTRIBUTE_NAME, constraintViolations,
					RequestAttributes.SCOPE_REQUEST);
			return false;
		}
	}

	/**
	 * 货币格式化
	 * 
	 * @param amount
	 *            金额
	 * @param showSign
	 *            显示标志
	 * @param showUnit
	 *            显示单位
	 * @return 货币格式化
	 */
	protected String currency(BigDecimal amount, boolean showSign, boolean showUnit) {
		Setting setting = SettingUtils.get();
		String price = setting.setScale(amount).toString();
		if (showSign) {
			price = setting.getCurrencySign() + price;
		}
		if (showUnit) {
			price += setting.getCurrencyUnit();
		}
		return price;
	}

	/**
	 * 获取国际化消息
	 * 
	 * @param code
	 *            代码
	 * @param args
	 *            参数
	 * @return 国际化消息
	 */
	protected String message(String code, Object... args) {
		return SpringUtils.getMessage(code, args);
	}

	/**
	 * 添加瞬时消息
	 * 
	 * @param redirectAttributes
	 *            RedirectAttributes
	 * @param message
	 *            消息
	 */
	protected void addFlashMessage(RedirectAttributes redirectAttributes, Message message) {
		if (redirectAttributes != null && message != null) {
			redirectAttributes.addFlashAttribute(FlashMessageDirective.FLASH_MESSAGE_ATTRIBUTE_NAME, message);
		}
	}

	protected String getUrl(String key) {
		if ((SysConfigMapping.loadUrlMap != null) && (SysConfigMapping.loadUrlMap.containsKey(key))) {
			return (String) SysConfigMapping.loadUrlMap.get(key);
		}
		return "";
	}

	/**
	 * 通过页面路径，获取ModelAndView
	 * 
	 * @param pagePath
	 *            页面路径
	 * @return ModelAndView对象
	 */
	protected ModelAndView toView(String pagePath) {
		ModelAndView result = new ModelAndView(pagePath);
		return result;
	}

	public JSONObject getJsonObject() {
		return jsonObject;
	}

	@PostConstruct
	public JSONObject setJsonObject() {
		if (jsonObject == null) {
			HttpServletRequest request = WebUtils.getRequest();
			Enumeration enu = request.getParameterNames();
			if (enu != null) {
				jsonObject = new JSONObject();
				while (enu.hasMoreElements()) {
					String paraName = (String) enu.nextElement();
					jsonObject.put(paraName, request.getParameter(paraName));
				}
			}
		}
		return jsonObject;
	}

}