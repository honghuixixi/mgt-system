package cn.qpwa.common.utils;

import cn.qpwa.common.utils.setting.Setting;
import cn.qpwa.common.utils.setting.SettingUtils;
import cn.qpwa.common.utils.json.JSONTools;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

public class QQLoginUtil {

	private String accessToken = null;
	
	public QQLoginUtil(String code,String state){
		Setting set = SettingUtils.get();
		String url = set.getTokenUrl()+"?grant_type=authorization_code&client_id="+set.getAppId()
				+"&client_secret="+set.getAppKey()+"&code="+code+"&state="+state+"&redirect_uri="+set.getRedirectUri();
		String result = doGet(url);
		int first = result.indexOf("=");
		int end = result.indexOf("&");
		result = result.substring(first+1,end);
		System.out.println("accessToken="+result);
		this.accessToken = result;
	}
	
	//根据获取到的accessToken 去获取当前用的openid
	public String getOpenId(){
		String openId = null;
		if(StringUtils.isNotEmpty(accessToken)){
			Setting set = SettingUtils.get();
			String url = set.getOpenIDUrl()+"?access_token="+accessToken;
			String msg = doGet(url);
			if(StringUtils.isNotEmpty(msg)){
				int first = msg.indexOf("(");
				int end = msg.indexOf(")");
				msg = msg.substring(first+1, end);
				JSONObject jo1 = JSONTools.parseToJSONObject(msg.trim());
				openId = (String) jo1.get("openid");
			}
		}
		return openId;
	}
	
	//利用获取到的openid 去获取当前用用户信息
	public String getUserInfo(String openid){
		if(StringUtils.isNotEmpty(openid)){
			Setting set = SettingUtils.get();
			String url = set.getUserInfoURL()+"?access_token="+accessToken+"&oauth_consumer_key="+set.getAppId()+"&openid="+openid;
			System.out.println(getEncoding(url));
			System.out.println(url);
			String msg = doGet(url);
			return msg;
		}
		return null;
	}
	
	
	public static String doGet(String url){
		String result = "";
        BufferedReader in = null;
        try {
            URL realUrl = new URL(url);
            URLConnection connection = realUrl.openConnection();
            connection.setRequestProperty("accept", "*/*");
            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            connection.connect();
            in = new BufferedReader(new InputStreamReader(
                    connection.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return result;
	}
	
	public static void main(String[] args) {
//		String url = "https://graph.qq.com/oauth2.0/me?access_token=EC2115EDD57C0C22EB86253D8D245A6A";
//		String ss = getOpenUrl(url);
//		int first = ss.indexOf("(");
//		int end = ss.indexOf(")");
//		ss = ss.substring(first+1, end);
//		System.out.println(ss);
//		JSONObject jo1 = JSONTools.parseToJSONObject(ss.trim());
//		System.out.println(jo1.get("openid"));
//		String url = "https://graph.qq.com/oauth2.0/token?grant_type=authorization_code&client_id=101170010&client_secret=ba7468ac22109de29e5928bd54db6c50&" +
//				"code=482067DE48873383E7EC55673BCE8553&state=ss&redirect_uri=www.qpwa.cn";
		String urlUser = "https://graph.qq.com/user/get_user_info?access_token=EC2115EDD57C0C22882D36541C513821&oauth_consumer_key=101170010&openid=079E122476E99B3755130608870AF95D";
		System.out.println(getEncoding(urlUser));
		String ssUser = doGet(urlUser);
		JSONObject jo = JSONTools.parseToJSONObject(ssUser);
		System.out.println(jo.get("nickname"));
//		String result = "access_token=EC2115EDD57C0C22882D36541C513821&expires_in=7776000&refresh_token=45877F8E80D092A3B4AB3F00B26905E0";
////		String result = doGet(url);
//		int first = result.indexOf("=");
//		int end = result.indexOf("&");
//		result = result.substring(first+1,end);
//		System.out.println(result);
	}
	
	public static String getEncoding(String str) {      
	       String encode = "GB2312";      
	      try {      
	          if (str.equals(new String(str.getBytes(encode), encode))) {      
	               String s = encode;      
	              return s;      
	           }      
	       } catch (Exception exception) {      
	       }      
	       encode = "ISO-8859-1";      
	      try {      
	          if (str.equals(new String(str.getBytes(encode), encode))) {      
	               String s1 = encode;      
	              return s1;      
	           }      
	       } catch (Exception exception1) {      
	       }      
	       encode = "UTF-8";      
	      try {      
	          if (str.equals(new String(str.getBytes(encode), encode))) {      
	               String s2 = encode;      
	              return s2;      
	           }      
	       } catch (Exception exception2) {      
	       }      
	       encode = "GBK";      
	      try {      
	          if (str.equals(new String(str.getBytes(encode), encode))) {      
	               String s3 = encode;      
	              return s3;      
	           }      
	       } catch (Exception exception3) {      
	       }      
	      return "";      
	   }
}
