package cn.qpwa.common.utils;

import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.cookie.CookiePolicy;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.DefaultHttpParams;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

/**
 * 获取经纬度
 * 
 * @author jueyue 返回格式：Map<String,Object> map map.put("status",
 *         reader.nextString());//状态 map.put("result", list);//查询结果
 *         list<map<String,String>> 密钥:f247cdb592eb43ebac6ccd27f796e2d2
 */
public class BaiDuMapUtil {

	String key = "3Ixvkcwnt5QZKdBtjpzz1tWP";
	
	/**
	 * @param addr
	 *            查询的地址
	 * @return
	 * @throws IOException
	 */
	public Object[] getCoordinate(String addr) throws IOException {
		String lng = null;// 经度
		String lat = null;// 纬度
		String address = null;
		try {
			address = java.net.URLEncoder.encode(addr, "UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		String url = String.format("http://api.map.baidu.com/geocoder?address=%s&output=json&key=%s", address, key);
		URL myURL = null;
		URLConnection httpsConn = null;
		try {
			myURL = new URL(url);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
		InputStreamReader insr = null;
		BufferedReader br = null;
		try {
			httpsConn = (URLConnection) myURL.openConnection();// 不使用代理
			if (httpsConn != null) {
				insr = new InputStreamReader(httpsConn.getInputStream(),
						"UTF-8");
				br = new BufferedReader(insr);
				String data = null;
				int count = 1;
				while ((data = br.readLine()) != null) {
					if (count == 5) {
						lng = (String) data.subSequence(data.indexOf(":") + 1,
								data.indexOf(","));// 经度
						count++;
					} else if (count == 6) {
						lat = data.substring(data.indexOf(":") + 1);// 纬度
						count++;
					} else {
						count++;
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (insr != null) {
				insr.close();
			}
			if (br != null) {
				br.close();
			}
		}
		return new Object[] { lng, lat };
	}

	public JSONObject getPosition(String address) {
		HttpClient client = new HttpClient();
		// 申请密钥（ak） 才可使用。每个key支持100万次/天，超过限制不返回数据
		// coordtype 非必填 默认值 bd09ll 格式:bd09ll 百度经纬度坐标
		// 坐标的类型，目前支持的坐标类型包括：bd09ll（百度经纬度坐标）、gcj02ll（国测局经纬度坐标）、wgs84ll（ GPS经纬度）
		// location 必填 默 格式:lat<纬度>,lng<经度>
		// pois 非必填 默认值 0 是否显示指定位置周边的poi，0为不显示，1为显示。当值为1时，显示周边100米内的poi。
		String url = String
				.format("http://api.map.baidu.com/geocoder/v2/?ak=%s&callback=renderReverse&location=%s&output=json",
						key, address);
		// 设置代理服务器地址和端口
		// client.getHostConfiguration().setProxy("proxy_host_addr",proxy_port);
		// 使用 GET 方法 ，如果服务器需要通过 HTTPS 连接，那只需要将下面 URL 中的 http 换成 https
		// HttpMethod method = new GetMethod(url);
		// 使用POST方法
		DefaultHttpParams.getDefaultParams().setParameter(
				"http.protocol.cookie-policy",
				CookiePolicy.BROWSER_COMPATIBILITY);
		HttpMethod method = new PostMethod(url);
		try {
			client.executeMethod(method);
			String str = method.getResponseBodyAsString();
			String[] address1 = str.split("\\(");
			String[] addrJson = address1[1].split("\\)");
			JSONObject jsonObject = JSONObject.fromObject(addrJson[0]);
			JSONObject addressComponent = jsonObject.getJSONObject("result").getJSONObject("addressComponent");
//			String city = addressComponent.getString("city");
//			String district = addressComponent.getString("district");
//			String province = addressComponent.getString("province");
//			System.out.println(addressComponent);
//			System.out.println(city);
//			System.out.println(district);
//			System.out.println(province);
			return addressComponent;
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// 释放连接
			method.releaseConnection();
		}
		// 打印服务器返回的状态
		// System.out.println(method.getStatusLine());
		return null;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		BaiDuMapUtil getLatAndLngByBaidu = new BaiDuMapUtil();
		try {
			Object[] o = getLatAndLngByBaidu.getCoordinate("三河");
			System.out.println(o[0]);// 经度
			System.out.println(o[1]);// 纬度
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String add = "40.033162,116.239678";
		getLatAndLngByBaidu.getPosition(add);

	}

}
