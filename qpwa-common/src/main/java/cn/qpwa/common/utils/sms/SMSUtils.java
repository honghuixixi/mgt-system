package cn.qpwa.common.utils.sms;

import cn.qpwa.common.utils.http.HttpUtil;
import net.sf.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 发送短信工具类
 *
 返回值											说明
success:msgid								提交成功，发送状态请见4.1
error:msgid									提交失败
error:Missing username						用户名为空
error:Missing password						密码为空
error:Missing apikey						APIKEY为空
error:Missing recipient						手机号码为空
error:Missing message content				短信内容为空
error:Account is blocked					帐号被禁用
error:Unrecognized encoding					编码未能识别
error:APIKEY or password error				APIKEY 或密码错误
error:Unauthorized IP address				未授权 IP 地址
error:Account balance is insufficient		余额不足
error:Black keywords is:党中央				屏蔽词
 */
public class SMSUtils {
	static HttpUtil httpUtil = HttpUtil.getInstall();

	/**
	 * 发送短信
	 * @param tel
	 * 			电话号码，给一个号码发的时候直接写号码就行，群发的时候格式为(注意最后以;结尾):133xxxxxx,133xxxxxx,133xxxxxx
	 * @param SMSContent
	 * 			发送短信的内容
	 * @throws IOException
	 */
	public static String sendSMS(String tel, String SMSContent) throws IOException {
		//发送内容
		String content = SMSContent;
		// 创建StringBuffer对象用来操作字符串
		StringBuffer sb = new StringBuffer("http://m.5c.com.cn/api/send/?");
		
		// APIKEY
		sb.append("apikey=f09e6d1ad848e03a19f1d3126cc6260a");

		//用户名
		sb.append("&username=qianping");

		// 向StringBuffer追加密码
		sb.append("&password=141120");
		
		// 向StringBuffer追加手机号码
		sb.append("&mobile=" + removeDuplicate(tel));

		// 向StringBuffer追加消息内容转URL标准码
		sb.append("&content="+URLEncoder.encode(content,"GBK"));

		// 创建url对象
		URL url = new URL(sb.toString());

		// 打开url连接
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();

		// 设置url请求方式 ‘get’ 或者 ‘post’
		connection.setRequestMethod("POST");

		// 发送
		BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

		// 返回发送结果
		String inputline = in.readLine();

		// 输出结果
//		System.out.println(inputline);
		return inputline;
		
	}
	
	/**
	 * 筛选号码，重复的、格式不正确的号码全部都去掉
	 * @param tel
	 * 			电话号码，一个或多个，多个的格式为130xxxxxxxx,130xxxxxxxx,130xxxxxxxx
	 * @return String
	 */
	private static String removeDuplicate(String tel) {
		if(tel.contains(",")) {
			String[] tels = tel.split(",");
			Set<String> set = new HashSet<String>();
			for(int i=0; i<tels.length; i++) {
				//筛掉错误的电话号码，例如号码为空(别误解成空号)、位数不够的号码、或者不是正确开头的错号码
				if(isMobileNO(tels[i])) {
					set.add(tels[i]);
				} else {
					i++;
				}
			}
			String result = "";
			for(String str : set) {
				result += str + ",";
			}
			result = result.substring(0, result.length()-1);
			return result;
		} else {
			return tel;
		}
	}
	
	/**
	 * 验证手机号的正确性的（空号、错号都不行），支持的号段有：
	 * 移动：139 138 137 136 135 134 147 150 151 152 157 158 159 178 182 183 184 187 188
	 * 联通：130 131 132 155 156 185 186 145 176
	 * 电信：133 153 177 180 181 189
	 * @param mobiles
	 * 			手机号码
	 * @return boolean
	 */
	public static boolean isMobileNO(String mobiles) {
		Pattern p = Pattern.compile("^0?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}
	
	/**
	 * 发送短信
	 * @param tel
	 * 			电话号码，给一个号码发的时候直接写号码就行，群发的时候格式为(注意最后以;结尾):133xxxxxx,133xxxxxx,133xxxxxx
	 * @param SMSContent
	 * 			发送短信的内容
	 * @throws IOException
	 */
	public static String sendSMSContent(String tel, String SMSContent) throws IOException {
		//发送内容
		String content = SMSContent;
		// 创建StringBuffer对象用来操作字符串
		StringBuffer sb = new StringBuffer("http://m.5c.com.cn/api/send/?");
		
		// APIKEY
		sb.append("apikey=f09e6d1ad848e03a19f1d3126cc6260a");

		//用户名
		sb.append("&username=qianping");

		// 向StringBuffer追加密码
		sb.append("&password=141120");
		
		// 向StringBuffer追加手机号码
		sb.append("&mobile=" + removeDuplicate(tel));

		// 向StringBuffer追加消息内容转URL标准码
		sb.append("&content="+URLEncoder.encode(content,"GBK"));

		String message = httpUtil.sendJSON(sb.toString(), new JSONObject().toString());

		// 输出结果
//		System.out.println(inputline);
		return message;
		
	}
}
