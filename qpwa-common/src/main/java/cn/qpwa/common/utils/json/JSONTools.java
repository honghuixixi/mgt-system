package cn.qpwa.common.utils.json;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import net.sf.ezmorph.object.DateMorpher;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import net.sf.json.util.JSONUtils;
import net.sf.json.util.PropertyFilter;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.util.Assert;

import java.io.IOException;
import java.io.Writer;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;

/**
 * 
 * json工具类
 * 
 */
@SuppressWarnings("unchecked")
public class JSONTools {

	
	static {
		String[] dateFormats = new String[] { "yyyy-MM-dd HH:mm:ss","yyyy-MM-dd"};
		JSONUtils.getMorpherRegistry().registerMorpher(new DateMorpher(dateFormats));// 注册格式化日期的模式
		JSONUtils.getMorpherRegistry().registerMorpher(new TimestampMorpher(new String[]{"yyyy-MM-dd"}));
	}

	/**
	 * 从json中取String
	 * 
	 * @param json
	 * @param key
	 * @return
	 */
	public static final String getString(JSONObject json, String key) {
		String result = "";
		Object obj = getObject(json, key);
		if (obj != null) {
			result = obj.toString();
		}

		return result;
	}

	public static final int getInt(JSONObject json, String key) {
		int result = 0;
		Object obj = getObject(json, key);
		if (obj != null) {
			result = NumberUtils.toInt(obj.toString(), result);
		}

		return result;
	}

	public static final boolean getBoolean(JSONObject json, String key) {
		boolean result = false;
		Object obj = getObject(json, key);
		if (obj != null) {
			result = BooleanUtils.toBoolean(obj.toString());
		}

		return result;
	}

	public static final Double getDouble(JSONObject json, String key) {
		double result = 0;
		Object obj = getObject(json, key);
		if (obj != null) {
			result = NumberUtils.toDouble(obj.toString(), result);
		}

		return result;
	}

	public static final BigDecimal getBigDecimal(JSONObject json, String key) {
		BigDecimal result = null; 
		Object obj = getObject(json, key);
		if (obj != null) {
			result = new BigDecimal(obj.toString());
		}
		return result;
	}

	public static final JSONObject getJSONObject(JSONObject json, String key) {
		JSONObject result = null;
		Object obj = getObject(json, key);
		if (obj != null && obj instanceof JSONObject) {
			result = (JSONObject) obj;
		}

		return result;
	}

	public static final JSONArray getJSONArray(JSONObject json, String key) {
		JSONArray result = null;
		Object obj = getObject(json, key);
		if (obj != null && obj instanceof JSONArray) {
			result = (JSONArray) obj;
		}

		return result;
	}

	public static final Object getObject(JSONObject json, String key) {
		Object result = null;
		if (json != null && StringUtils.isNotEmpty(key) && json.containsKey(key)) {
			result = json.get(key);
		}
		return result;
	}

	public static final <T> T JSONToBean(JSONObject jsonData, Class<T> clazz) {
		return JSONToBean(jsonData, clazz, null);
	}

	/**
	 * json对象转bean
	 * 
	 * @param jsonData
	 *            {@link JSONObject}
	 * @param clazz
	 *            {@link Class}
	 * @param jsonConfig
	 *            {@link JsonConfig}
	 * @return
	 */

	public static final <T> T JSONToBean(JSONObject jsonData, Class<T> clazz, JsonConfig jsonConfig) {
		T result = null;
		if (jsonData == null || jsonData.size() == 0 || clazz == null) {
			return result;
		}
		if (jsonConfig == null) {
			jsonConfig = getJSConfig(null, null, false);
		}
		try {
			result = clazz.newInstance();
			result = (T) JSONObject.toBean(jsonData, result, jsonConfig);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 
	 * @param jsonData
	 *            {@link JSONObject}json对象
	 * @param clazz
	 *            要转换的成的对象
	 * @param excludes
	 *            不包含的字段名称
	 * @param datePattern
	 *            日期的正则
	 * @param includeNull
	 *            是否包括null，空串字段
	 * @return
	 */
	public static final <T> T JSONToBean(JSONObject jsonData, Class<T> clazz, String[] excludes, String datePattern,
			Boolean includeNull) {
		JsonConfig jsonConfig = getJSConfig(excludes, datePattern, includeNull);
		return JSONToBean(jsonData, clazz, jsonConfig);
	}

	/**
	 * 取jsonConfig
	 * 
	 * @param excludes
	 *            不包含的字段，哪些字段需要过滤掉
	 * @param datePattern
	 *            日期转换格式
	 * @param includeNull
	 *            是否包含值为null的字段，默认包含 true 包含，false不包含
	 * @return
	 */
	public static JsonConfig getJSConfig(String[] excludes, String datePattern, Boolean includeNull) {
		JsonConfig result = new JsonConfig();
		if (null != excludes)
			result.setExcludes(excludes);

		result.setIgnoreDefaultExcludes(false);
		result.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		result.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor(datePattern));
		if (includeNull != null && includeNull == false) {
			// 忽略属性值为null的字段
			result.setJsonPropertyFilter(new PropertyFilter() {
				public boolean apply(Object source, String name, Object value) {
					// 忽略birthday属性
					if (value == null) {
						return true;
					}
					return false;
				}
			});

			result.setJavaPropertyFilter(new PropertyFilter() {

				@Override
				public boolean apply(Object source, String name, Object value) {
					if (value == null || StringUtils.isBlank(value.toString())) {
						return true;
					}
					return false;
				}
			});
		}
		return result;
	}

	public static JSONObject parseToJSONObject(String str) {
		JSONObject result = null;
		if (StringUtils.isNotBlank(str) && str.startsWith("{") && str.endsWith("}")) {
			result = JSONObject.fromObject(str);
		}
		if (result == null) {
			result = new JSONObject();
		}
		return result;
	}
	

	/** ObjectMapper */
	private static ObjectMapper mapper = new ObjectMapper();

	/**
	 * 将对象转换为JSON字符串
	 * 
	 * @param value
	 *            对象
	 * @return JSOn字符串
	 */
	public static String toJson(Object value) {
		try {
			return mapper.writeValueAsString(value);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将JSON字符串转换为对象
	 * 
	 * @param json
	 *            JSON字符串
	 * @param valueType
	 *            对象类型
	 * @return 对象
	 */
	public static <T> T toObject(String json, Class<T> valueType) {
		Assert.hasText(json);
		Assert.notNull(valueType);
		try {
			return mapper.readValue(json, valueType);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将JSON字符串转换为对象
	 * 
	 * @param json
	 *            JSON字符串
	 * @param typeReference
	 *            对象类型
	 * @return 对象
	 */
	public static <T> T toObject(String json, TypeReference<?> typeReference) {
		Assert.hasText(json);
		Assert.notNull(typeReference);
		try {
			return mapper.readValue(json, typeReference);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将JSON字符串转换为对象
	 * 
	 * @param json
	 *            JSON字符串
	 * @param javaType
	 *            对象类型
	 * @return 对象
	 */
	public static <T> T toObject(String json, JavaType javaType) {
		Assert.hasText(json);
		Assert.notNull(javaType);
		try {
			return mapper.readValue(json, javaType);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将对象转换为JSON流
	 * 
	 * @param writer
	 *            writer
	 * @param value
	 *            对象
	 */
	public static void writeValue(Writer writer, Object value) {
		try {
			mapper.writeValue(writer, value);
		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 校验字符串是否为JSON格式，true为是JSON格式
	 * 
	 * @param str 字符串
	 * 
	 * @return 校验结果true为是JSON格式;
	 */
	public static boolean isJson(String str) {
		if (StringUtils.isBlank(str)) {
			return false;
		}
		try {
			JsonParser jsonParser = new JsonParser();
			JsonElement jsonElement = jsonParser.parse(str);
			return jsonElement.isJsonObject();
		} catch (JsonSyntaxException e) {
		}
		return false;
	}
	

	public static JSONObject transObject(JSONObject o1) {
		JSONObject o2 = new JSONObject();
		Iterator<?> it = o1.keys();
		while (it.hasNext()) {
			String key = (String) it.next();
			Object object = o1.get(key);
			if (object.getClass().toString().endsWith("String")) {
				o2.accumulate(key.toLowerCase(), object);
			} else if (object.getClass().toString().endsWith("JSONObject")) {
				o2.accumulate(key.toLowerCase(),
						JSONTools.transObject((JSONObject) object));
			} else if (object.getClass().toString().endsWith("JSONArray")) {
				o2.accumulate(key.toLowerCase(),
						JSONTools.transArray(o1.getJSONArray(key)));
			}
		}
		return o2;
	}

	public static JSONArray transArray(JSONArray o1) {
		JSONArray o2 = new JSONArray();
		for (int i = 0; i < o1.size(); i++) {
			Object jArray = o1.getJSONObject(i);
			if (jArray.getClass().toString().endsWith("JSONObject")) {
				o2.add(JSONTools.transObject((JSONObject) jArray));
			} else if (jArray.getClass().toString().endsWith("JSONArray")) {
				o2.add(JSONTools.transArray((JSONArray) jArray));
			}
		}
		return o2;
	}

}
