package cn.qpwa.common.utils;

import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

/**
 * 请求、响应数据传输json工具类
 *
 */
public class TransferJson {
	private static JSONObject jobj = new JSONObject();
	protected static Logger log = Logger.getLogger(TransferJson.class);

	/**
	 * 设置默认请求、响应数据传输json实体
	 * @return
	 */
	public static JSONObject defTransferJson() {
		return makeDefTransferJson();
	}

	/**
	 * 设置请求数据传输json实体
	 * 
	 * @param type 业务数据类型 ,service前缀名称
	 * @param oper 请求动作，service方法
	 * @param source 请求来源，B2B 、MGT、WAP、APP
	 * @param para 请求参数JSONObject对象
	 * 
	 * @return 请求数据传输json实体
	 */
	public static JSONObject setSimpleReqTransferJson(String type, String oper, String source,
			JSONObject para) {
		makeDefTransferJson();
		jobj.put(RequestKey.type.name(), type);
		jobj.put(RequestKey.oper.name(), oper);
		jobj.put(RequestKey.source.name(), source);
		jobj.put(RequestKey.para.name(), para);
		log.info(jobj.toString());
		return jobj;
	}

	/**
	 * 构建默认请求、响应数据传输json实体
	 * @return
	 */
	private static JSONObject makeDefTransferJson() {
		for (RequestKey pk : RequestKey.values())
			jobj.put(pk.name(), "");
		return jobj;
	}
}