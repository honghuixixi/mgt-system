package cn.qpwa.common.utils.payment;

import cn.qpwa.common.utils.DateUtil;
import cn.qpwa.common.utils.setting.Setting;
import cn.qpwa.common.utils.setting.SettingUtils;
import com.unionpay.acp.sdk.HttpClient;
import com.unionpay.acp.sdk.SDKConfig;
import com.unionpay.acp.sdk.SDKUtil;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;

/**
 * Plugin - 银联支付
 * 
 * @author zhaowei
 * @version 1.0
 */
public class UnionpayPaymentUtil {
	
	/**
	 * 通知方法
	 */
	public enum NotifyMethod {

		/** 通用 */
		general,

		/** 同步 */
		sync,

		/** 异步 */
		async
	}
	
	/**
	 * 获取通知URL
	 * 
	 * @param sn
	 *            编号
	 * @param notifyMethod
	 *            通知方法
	 * @return 通知URL
	 */
	protected String getNotifyUrl(String sn, NotifyMethod notifyMethod) {
		Setting setting = SettingUtils.get();
		if (notifyMethod == null) {
			return setting.getSiteUrl() + "/payment/notify/" + NotifyMethod.general + "/" + sn + ".jhtml";
		}
		return setting.getSiteUrl() + "/payment/notify/" + notifyMethod + "/" + sn + ".jhtml";
	}
	
	/**
	 * 生成交易请求参数
	 * @param orderId
	 * @param merchantAcctId
	 * @param orderAmount
	 * @param bankId
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	public static Map<String, String> getParameterMap(String orderId,String orderAmount,UnionpayProductType upt) {
		Setting set = SettingUtils.get();
		Map<String, String> data = new HashMap<String, String>();
		data.put("version", "5.0.0");
		data.put("encoding", "UTF-8");
		data.put("signMethod", "01");
		data.put("txnType", "01");
		data.put("txnSubType", "01");
		data.put("bizType", upt.getBizType());
		data.put("channelType", upt.getChannelType());
		data.put("frontUrl", set.getFrontUrl());
		data.put("backUrl", set.getBackUrl());
		data.put("accessType", "0");
		data.put("merId", upt.getMerId());
		data.put("orderId",orderId);
		data.put("txnTime", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
		data.put("txnAmt", orderAmount.toString());
		data.put("currencyCode", "156");
		Map<String, String> submitFromData = signData(data);
		return submitFromData;
	}
	
	/**
	 * 应答报文校验
	 * @param amount
	 * @param request
	 * @return 如果校验失败返回空，交易成功返回清算时间
	 */
	public static String verifyNotify(BigDecimal amount, HttpServletRequest request,UnionpayProductType upt) {
		Map<String, String> respParam = getAllRequestParam(request);
		if (SDKUtil.validate(respParam, "") //验签通过
				&& "00".equals(request.getParameter("respCode")) //支付结果为成功
				&& amount.multiply(new BigDecimal(100)).compareTo(new BigDecimal(request.getParameter("txnAmt"))) == 0) {//订单金额有效
			Map<String, String> data = new HashMap<String, String>();
			data.put("version", "5.0.0");
			data.put("encoding", "UTF-8");
			data.put("signMethod", "01");
			data.put("txnType", "00");
			data.put("txnSubType", "00");
			data.put("bizType", upt.getBizType());
			data.put("channelType", upt.getChannelType());
			data.put("accessType", "0");
			data.put("merId", upt.getMerId());
			data.put("orderId", request.getParameter("orderId"));
			data.put("txnTime", request.getParameter("txnTime"));
			data = signData(data);
			String url = SDKConfig.getConfig().getSingleQueryUrl();
			Map<String, String> resmap = submitUrl(data, url);
			System.out.println("==recive params:"+resmap.toString());
			if(resmap.containsKey("respCode") && "00".equals(resmap.get("respCode"))
				&&resmap.containsKey("origRespCode") && "00".equals(resmap.get("origRespCode"))	
					){
				return DateUtil.getYear()+ resmap.get("settleDate");
			}
		}
		return "";
	}
	
	/**
	 * APP控件支付获取交易流水号
	 * @param amount
	 * @param request
	 * @return 如果校验失败返回空，交易成功返回清算时间
	 */
	public static String getTn(String orderId,BigDecimal amount,UnionpayProductType upt) {
//		Setting set = SettingUtils.get();
		Map<String, String> data = new HashMap<String, String>();
		data.put("version", "5.0.0");
		data.put("encoding", "UTF-8");
		data.put("signMethod", "01");
		data.put("txnType", "01");
		data.put("txnSubType", "01");
		data.put("bizType", upt.getBizType());
		data.put("channelType", upt.getChannelType());
		data.put("frontUrl", "");
		/**
		 * 测试服务器地址
		 */
		//data.put("backUrl", "http://117.121.48.153:8078/qpwa-wireless/");
		/**
		 * 正式服务器地址
		 */
		data.put("backUrl", "http://www.11wlw.cn/payment/receive.jhtml");
		data.put("accessType", "0");
		data.put("merId", upt.getMerId());
		data.put("orderId", orderId);
		data.put("txnTime",  new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
		data.put("txnAmt", amount.toString());
		data.put("currencyCode", "156");
		data = signData(data);
		String url = SDKConfig.getConfig().getAppRequestUrl();
		System.out.println(url);
		Map<String, String> resmap = submitUrl(data, url);
		if(resmap.containsKey("respCode") && "00".equals(resmap.get("respCode"))){
			return resmap.get("tn");
		}
		return "";
	}
	
	public static Map<String, String> verifyNotifys(String orderId,String txnTime,UnionpayProductType upt) {
			Map<String, String> data = new HashMap<String, String>();
			data.put("version", "5.0.0");
			data.put("encoding", "UTF-8");
			data.put("signMethod", "01");
			data.put("txnType", "00");
			data.put("txnSubType", "00");
			data.put("bizType", upt.getBizType());
			data.put("channelType", upt.getChannelType());
			data.put("accessType", "0");
			data.put("merId", upt.getMerId());
			data.put("orderId", orderId);
			data.put("txnTime",txnTime);
			data = signData(data);
			String url = SDKConfig.getConfig().getSingleQueryUrl();
			Map<String, String> resmap = submitUrl(data, url);
		return resmap;
	}
	
	/**
	 * java main方法 数据提交 提交到后台
	 * 
	 * @param contentData
	 * @return 返回报文 map
	 */
	public static Map<String, String> submitUrl(
			Map<String, String> submitFromData,String requestUrl) {
		String resultString = "";
		/**
		 * 发送
		 */
		HttpClient hc = new HttpClient(requestUrl, 30000, 30000);
		try {
			int status = hc.send(submitFromData, "UTF-8");
			if (200 == status) {
				resultString = hc.getResult();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		Map<String, String> resData = new HashMap<String, String>();
		/**
		 * 验证签名
		 */
		if (null != resultString && !"".equals(resultString)) {
			// 将返回结果转换为map
			resData = SDKUtil.convertResultStringToMap(resultString);
			if (SDKUtil.validate(resData, "UTF-8")) {
				System.out.println("验证签名成功");
			} else {
				System.out.println("验证签名失败");
			}
			// 打印返回报文
			System.out.println("打印返回报文：" + resultString);
		}
		return resData;
	}
	
	/**
	 *对数据进行签名
	 * 
	 * @param contentData
	 * @return　签名后的map对象
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, String> signData(Map<String, ?> contentData) {
		Entry<String, String> obj = null;
		Map<String, String> submitFromData = new HashMap<String, String>();
		for (Iterator<?> it = contentData.entrySet().iterator(); it.hasNext();) {
			obj = (Entry<String, String>) it.next();
			String value = obj.getValue();
			if (StringUtils.isNotBlank(value)) {
				submitFromData.put(obj.getKey(), value.trim());
			}
		}
		SDKUtil.sign(submitFromData, "utf-8");
		return submitFromData;
	}
	
	/**
	 * 对数据进行验签
	 * 
	 * @param contentData
	 * @return　签名后的map对象
	 */
	@SuppressWarnings("unchecked")
	public static boolean validateData(Map<String, ?> contentData) {
		Entry<String, String> obj = null;
		Map<String, String> submitFromData = new HashMap<String, String>();
		for (Iterator<?> it = contentData.entrySet().iterator(); it.hasNext();) {
			obj = (Entry<String, String>) it.next();
			String value = obj.getValue();
			if (StringUtils.isNotBlank(value)) {
				submitFromData.put(obj.getKey(), value.trim());
			}
		}
		return SDKUtil.validate(submitFromData, "");
	}
	
	/**
	 * 获取请求参数中所有的信息
	 * 
	 * @param request
	 * @return
	 */
	public static Map<String, String> getAllRequestParam(
			final HttpServletRequest request) {
		Map<String, String> res = new HashMap<String, String>();
		Enumeration<?> temp = request.getParameterNames();
		if (null != temp) {
			while (temp.hasMoreElements()) {
				String en = (String) temp.nextElement();
				String value = request.getParameter(en);
				res.put(en, value);
				// 在报文上送时，如果字段的值为空，则不上送<下面的处理为在获取所有参数数据时，判断若值为空，则删除这个字段>
				if (res.get(en) == null || "".equals(res.get(en))) {
					// System.out.println("======为空的字段名===="+en);
					res.remove(en);
				}
			}
		}
		return res;
	}
	
	/**
	 * 连接Map键值对
	 * 
	 * @param map
	 *            Map
	 * @param prefix
	 *            前缀
	 * @param suffix
	 *            后缀
	 * @param separator
	 *            连接符
	 * @param ignoreEmptyValue
	 *            忽略空值
	 * @param ignoreKeys
	 *            忽略Key
	 * @return 字符串
	 */
	public static String joinKeyValue(Map<String, Object> map, String prefix, String suffix, String separator, boolean ignoreEmptyValue, String... ignoreKeys) {
		List<String> list = new ArrayList<String>();
		if (map != null) {
			for (Entry<String, Object> entry : map.entrySet()) {
				String key = entry.getKey();
				String value = ConvertUtils.convert(entry.getValue());
				if (StringUtils.isNotEmpty(key) && !ArrayUtils.contains(ignoreKeys, key) && (!ignoreEmptyValue || StringUtils.isNotEmpty(value))) {
					list.add(key + "=" + (value != null ? value : ""));
				}
			}
		}
		return (prefix != null ? prefix : "") + StringUtils.join(list, separator) + (suffix != null ? suffix : "");
	}
	
	/**
	 * 生成签名
	 * 
	 * @param parameterMap
	 *            参数
	 * @return 签名
	 * @throws UnsupportedEncodingException 
	 */
	public static String generateSign(Map<String, Object> parameterMap) throws UnsupportedEncodingException {
		String signMsgVal = joinKeyValue(parameterMap, null, null, "&", true, "signMsg");
		signMsgVal = DigestUtils.md5Hex(signMsgVal.getBytes("UTF-8")).toUpperCase();
		return signMsgVal;
	}
	
	public static void main(String[] args) {
//		BigDecimal amount = new BigDecimal("0.01");
//		System.out.println(amount);
//		amount = amount.multiply(new BigDecimal(100)).setScale(0);
//		System.out.println(amount);
//		boolean b = amount.compareTo(new BigDecimal("1")) == 0;
//		System.out.println(b);	
//		System.out.println(new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
	}
}