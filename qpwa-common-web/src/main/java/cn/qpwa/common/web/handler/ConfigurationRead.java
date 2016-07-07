package cn.qpwa.common.web.handler;

import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.springframework.core.io.Resource;

import cn.qpwa.common.utils.LogEnabled;


@SuppressWarnings({ "rawtypes", "unchecked" })
public class ConfigurationRead implements LogEnabled {
	private Properties m_props = null;

	protected void read(List<Resource> pFile, String name) {
		Map<String, String> map = null;
		try {
			if ((pFile != null) && (pFile.size() > 0)) {
				map = (Map<String, String>) getStaticProperty(SysConfigMapping.class.getName(), name);
				for (int i = 0; i < pFile.size(); i++) {
					this.m_props = new Properties();
					this.m_props.load(((Resource) pFile.get(i)).getInputStream());
					Set set = this.m_props.entrySet();
					Iterator it = set.iterator();
					String key = null;
					String value = null;
					while (it.hasNext()) {
						Map.Entry entry = (Map.Entry) it.next();
						key = String.valueOf(entry.getKey());
						value = String.valueOf(entry.getValue());
						key = key == null ? key : key.trim();
						value = value == null ? value : value.trim();
						map.put(key, value);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("文件读取异常");
		}
	}

	/**
	 * 获取类中静态属性的值
	 * 
	 * @param className
	 *            类名
	 * @param fieldName
	 *            属性名
	 * @return 静态属性的值
	 * @throws Exception
	 */
	private Object getStaticProperty(String className, String fieldName) throws Exception {
		Class c = Class.forName(className);
		Field field = c.getField(fieldName);
		Object value = field.get(c);
		return value;
	}
}