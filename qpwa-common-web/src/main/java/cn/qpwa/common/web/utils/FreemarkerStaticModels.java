package cn.qpwa.common.web.utils;

import java.util.HashMap;
import java.util.Properties;
import java.util.Set;

import freemarker.ext.beans.BeansWrapper;
import freemarker.template.TemplateHashModel;

/**
 * 通过读取freemarkerstatic.properties文件，将静态类初始化到freemarker上下文，使得前台页面可以使用这个静态类
 * 
 */
public class FreemarkerStaticModels extends HashMap<Object, Object> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2083284368921064844L;
	private static FreemarkerStaticModels FREEMARKER_STATIC_MODELS;
	private Properties staticModels;

	private FreemarkerStaticModels() {

	}

	/**
	 * 实例化FreemarkerStaticModels类方法
	 */
	public static FreemarkerStaticModels getInstance() {
		if (FREEMARKER_STATIC_MODELS == null) {
			FREEMARKER_STATIC_MODELS = new FreemarkerStaticModels();
		}
		return FREEMARKER_STATIC_MODELS;
	}

	public Properties getStaticModels() {
		return staticModels;
	}

	/**
	 * 通过Properties类型集合初始化FreemarkerStaticModels</br>
	 * 
	 * @param staticModels
	 *            Properties类型集合
	 */
	public void setStaticModels(Properties staticModels) {
		if (this.staticModels == null && staticModels != null) {
			this.staticModels = staticModels;
			Set<String> keys = this.staticModels.stringPropertyNames();
			for (String key : keys) {
				FREEMARKER_STATIC_MODELS.put(key, useStaticPackage(this.staticModels.getProperty(key)));
			}
		}
	}

	/**
	 * 通过类的全名，获取TemplateHashModel实例
	 * 
	 * @param className
	 *            类的全名
	 * @return TemplateHashModel实例
	 */
	public static TemplateHashModel useStaticPackage(String className) {
		try {
			// 获取静态Class的Model
			BeansWrapper wrapper = BeansWrapper.getDefaultInstance();
			TemplateHashModel staticModels = wrapper.getStaticModels();
			TemplateHashModel fileStatics = (TemplateHashModel) staticModels.get(className);
			return fileStatics;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}