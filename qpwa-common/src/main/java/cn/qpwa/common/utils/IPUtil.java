package cn.qpwa.common.utils;

import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.cookie.CookiePolicy;
import org.apache.commons.httpclient.methods.GetMethod;

import java.io.*;
import java.net.*;
import java.util.Enumeration;
import java.util.StringTokenizer;


/**
 * IP工具类，提供一些处理IP的方法。
 * 
 */
@SuppressWarnings("rawtypes")
public class IPUtil {
	/**
	 * 根据某种编码方式将字节数组转换成字符串
	 * 
	 * 
	 * @param b
	 *            字节数组
	 * @param offset
	 *            要转换的起始位置
	 * @param len
	 *            要转换的长度
	 * @param encoding
	 *            编码方式
	 * @return 如果encoding不支持，返回一个缺省编码的字符串
	 */
	public static String getString(byte[] b, int offset, int len, String encoding) {
		try {
			return new String(b, offset, len, encoding);
		} catch (UnsupportedEncodingException e) {
			return new String(b, offset, len);
		}
	}

	/**
	 * @param ip
	 *            ip的字节数组形式
	 * 
	 * @return 字符串形式的ip
	 */
	public static String getIpStringFromBytes(byte[] ip) {
		StringBuilder sb = new StringBuilder();
		sb.delete(0, sb.length());
		sb.append(ip[0] & 0xFF);
		sb.append('.');
		sb.append(ip[1] & 0xFF);
		sb.append('.');
		sb.append(ip[2] & 0xFF);
		sb.append('.');
		sb.append(ip[3] & 0xFF);
		return sb.toString();
	}

	/**
	 * 从ip的字符串形式得到字节数组形式
	 * 
	 * @param ip
	 *            字符串形式的ip
	 * @return 字节数组形式的ip
	 */
	public static byte[] getIpByteArrayFromString(String ip) {
		byte[] ret = new byte[4];
		StringTokenizer st = new StringTokenizer(ip, ".");
		try {
			ret[0] = (byte) (Integer.parseInt(st.nextToken()) & 0xFF);
			ret[1] = (byte) (Integer.parseInt(st.nextToken()) & 0xFF);
			ret[2] = (byte) (Integer.parseInt(st.nextToken()) & 0xFF);
			ret[3] = (byte) (Integer.parseInt(st.nextToken()) & 0xFF);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
		return ret;
	}

	/**
	 * 利用百度服务通过ip获取地址
	 * （本机访问本机可用）
	 * @return
	 */
	public static JSONObject getAdressByIp() {
		HttpClient client = new HttpClient();
		// 申请密钥（ak） 才可使用。每个key支持100万次/天，超过限制不返回数据
		// 可选，coor不出现时，默认为百度墨卡托坐标；coor=bd09ll时，返回为百度经纬度坐标
		// 可选，ip不出现，或者出现且为空字符串的情况下，会使用当前访问者的IP地址作为定位参数
		String url = "http://api.map.baidu.com/location/ip?ak=AC1581bdb40b2c9f13d85be31fa7da97&coor=bd09ll";
		// 设置代理服务器地址和端口
		// client.getHostConfiguration().setProxy("proxy_host_addr",proxy_port);
		// 使用 GET 方法 ，如果服务器需要通过 HTTPS 连接，那只需要将下面 URL 中的 http 换成 https
		HttpMethod method = new GetMethod(url);
		// 使用POST方法
		// HttpMethod method = new PostMethod("http://java.sun.com");
		//设置policy避免Cookie rejected问题
		method.getParams().setParameter("http.protocol.cookie-policy",CookiePolicy.BROWSER_COMPATIBILITY);
		method.getParams().setParameter("http.protocol.cookie-policy",CookiePolicy.BROWSER_COMPATIBILITY);
		try {
			client.executeMethod(method);
			String str = method.getResponseBodyAsString();
			return JSONObject.fromObject(str);
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			// 释放连接
			method.releaseConnection();
		}
		// 打印服务器返回的状态
		// System.out.println(method.getStatusLine());
		return null;
	}
	
	/**
	 * 利用百度服务通过ip获取地址
	 * （外网访问服务器）
	 * @param 客户端IP字符串
	 * @return
	 */
	public static JSONObject getAdressByIp(String IPString) {
		HttpClient client = new HttpClient();
		// 申请密钥（ak） 才可使用。每个key支持100万次/天，超过限制不返回数据
		// 可选，coor不出现时，默认为百度墨卡托坐标；coor=bd09ll时，返回为百度经纬度坐标
		// 可选，ip不出现，或者出现且为空字符串的情况下，会使用当前访问者的IP地址作为定位参数
		String url = "http://api.map.baidu.com/location/ip?ak=AC1581bdb40b2c9f13d85be31fa7da97&coor=bd09ll&ip="+IPString;
		// 设置代理服务器地址和端口
		// client.getHostConfiguration().setProxy("proxy_host_addr",proxy_port);
		// 使用 GET 方法 ，如果服务器需要通过 HTTPS 连接，那只需要将下面 URL 中的 http 换成 https
		HttpMethod method = new GetMethod(url);
		// 使用POST方法
		// HttpMethod method = new PostMethod("http://java.sun.com");
		//设置policy避免Cookie rejected问题
		method.getParams().setParameter("http.protocol.cookie-policy",CookiePolicy.BROWSER_COMPATIBILITY);
//		method.getParams().setParameter("http.protocol.cookie-policy",CookiePolicy.BROWSER_COMPATIBILITY);
		try {
			client.executeMethod(method);
			String str = method.getResponseBodyAsString();
			return JSONObject.fromObject(str);
		} catch (HttpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			// 释放连接
			method.releaseConnection();
		}
		// 打印服务器返回的状态
		// System.out.println(method.getStatusLine());
		return null;
	}
	
	/**
	 * 获取ip地址的省级名称
	 * 
	 * @return 省级名称
	 */
	public static String getIpProvince(JSONObject jobj) {
		String provinceName = null;
		if (jobj != null && jobj.get("content") != null ) {
			jobj = JSONObject.fromObject(jobj.get("content"));
			jobj = JSONObject.fromObject(jobj.get("address_detail"));
			provinceName = jobj.getString("province");
		}
		return provinceName;
	}

	/**
	 * 转码 (如:\u5409\u6797\u7701\u957f\u6625\u5e02转完后为“吉林省长春市”)
	 * 
	 * @param utfString
	 * @return
	 */
	public static String convert(String utfString) {
		StringBuilder sb = new StringBuilder();
		int i = -1;
		int pos = 0;
		while ((i = utfString.indexOf("\\u", pos)) != -1) {
			sb.append(utfString.substring(pos, i));
			if (i + 5 < utfString.length()) {
				pos = i + 6;
				sb.append((char) Integer.parseInt(utfString.substring(i + 2, i + 6), 16));
			}
		}
		return sb.toString();
	}

	/**
	 * 取本机ip地址
	 * 
	 * @return
	 */
	public static String getLocalhostIp() {
		Enumeration allNetInterfaces = null;
		try {
			allNetInterfaces = NetworkInterface.getNetworkInterfaces();
		} catch (SocketException e) {
			e.printStackTrace();
		}
		InetAddress ip = null;
		while (allNetInterfaces.hasMoreElements()) {
			NetworkInterface netInterface = (NetworkInterface) allNetInterfaces.nextElement();
			Enumeration addresses = netInterface.getInetAddresses();
			while (addresses.hasMoreElements()) {
				ip = (InetAddress) addresses.nextElement();
				if (ip != null && ip instanceof Inet4Address) {
					System.out.println("本机的IP = " + ip.getHostAddress());
					if (!"127.0.0.1".equals(ip.getHostAddress())) {
						return ip.getHostAddress();
					}
				}
			}
		}
		return null;
	}

	public static void main(String[] agrs) {
		System.out.println(getAdressByIp());
		System.out.println(getIpByteArrayFromString("192.168.1.1"));
		System.out.println(getIpStringFromBytes(getIpByteArrayFromString("192.168.1.1")));
	}
	
	public static String getIp() {
		InetAddress ia=null;
		try {
			ia=ia.getLocalHost();
			
			String localname=ia.getHostName();
			String localip=ia.getHostAddress();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ia.toString();
	}
	
	private static final String DATA_PATH = "/qqwry.dat"; // 纯真ip数据库v2016.05.25

	/**
     * 获取指定IP的城市
     * @param ip
     * @return
     */
 	public static String getCountry(String ip) {
 		return new SubIPParser(DATA_PATH).seek(ip).getCountry();
 	}

 	/**
 	 * 获取指定IP的位置
 	 * @param ip
 	 * @return
 	 */
 	public static String getLocal(String ip) {
 		return new SubIPParser(DATA_PATH).seek(ip).getLocation();
 	}

 	/**
 	 * 获取指定IP的城市+位置
 	 * @param ip
 	 * @param sep
 	 * @return
 	 */
 	public static String getForSeparator(String ip, String sep) {
 		SubIPParser parser = new SubIPParser(DATA_PATH).seek(ip);
 		return parser.getCountry() + sep + parser.getLocation();
 	}
	
	// IP地址查询器
 	static class SubIPParser {
 		private String dataClasspath;
 		private String country;
 		private String location;
 		private int recordCount, countryFlag;
 		private long rangE, rangB, offSet, startIP, endIP, firstStartIP, lastStartIP, endIPOff;

 		public SubIPParser(String classpath) {
 			dataClasspath = classpath;
 		}

 		public SubIPParser seek(String ip) {
 			RandomAccessFile fis = null;
 			byte[] buff = null;
 			long ipn;
 			try {
 				ipn = ipToLong(ip);
 				String rootPath=getClass().getResource("/").getFile().toString(); 
				File file = new File(rootPath + "qqwry.dat");
				if(!file.exists()){
					InputStream ins = this.getClass().getResourceAsStream(DATA_PATH);
					OutputStream os = new FileOutputStream(file);
					int bytesRead = 0;
					byte[] buffer = new byte[1024*1024*10];
					while ((bytesRead = ins.read(buffer, 0, 1024*1024*10)) != -1) {
						os.write(buffer, 0, bytesRead);
					}
					os.close();
					ins.close();
				}
 				fis = new RandomAccessFile(file, "r");
 				buff = new byte[4];
 				fis.seek(0);
 				fis.read(buff);
 				firstStartIP = this.byteToLong(buff);
 				fis.read(buff);
 				lastStartIP = this.byteToLong(buff);
 				recordCount = (int) ((lastStartIP - firstStartIP) / 7);
 				if (recordCount <= 1) {
 					location = country = "未知";
 					return this;
 				}
 				rangB = 0;
 				rangE = recordCount;
 				long RecNo;
 				do {
 					RecNo = (rangB + rangE) / 2;
 					loadStartIP(RecNo, fis);
 					if (ipn == startIP) {
 						rangB = RecNo;
 						break;
 					}
 					if (ipn > startIP)
 						rangB = RecNo;
 					else
 						rangE = RecNo;
 				} while (rangB < rangE - 1);
 				loadStartIP(rangB, fis);
 				loadEndIP(fis);
 				loadCountry(ipn, fis);
 			} catch (Exception e) {
 				e.printStackTrace();
 			} finally {
 				if (fis != null) {
 					try {
 						fis.close();
 					} catch (IOException e) {
 					}
 				}
 			}
 			return this;
 		}

 		public String getLocation() {
 			return this.location==null?"未知":location;
 		}

 		public String getCountry() {
 			return this.country==null?"未知":country;
 		}

 		private long byteToLong(byte[] b) {
 			long ret = 0;
 			for (int i = 0; i < b.length; i++) {
 				long t = 1L;
 				for (int j = 0; j < i; j++) {
 					t = t * 256L;
 				}
 				ret += ((b[i] < 0) ? 256 + b[i] : b[i]) * t;
 			}
 			return ret;
 		}

 		private long ipToLong(String ip) {
 			String[] arr = ip.split("\\.");
 			long ret = 0;
 			for (int i = 0; i < arr.length; i++) {
 				long l = 1;
 				for (int j = 0; j < i; j++)
 					l *= 256;
 				try {
 					ret += Long.parseLong(arr[arr.length - i - 1]) * l;
 				} catch (Exception e) {
 					ret += 0;
 				}
 			}
 			return ret;
 		}

 		private URL getDataPath() {
 			Thread.currentThread().getContextClassLoader().getResource("");
 			URL url = null;
 			url = Thread.currentThread().getContextClassLoader().getResource(dataClasspath);
 			if (url == null) {
 				url = IPUtil.class.getClassLoader().getResource(dataClasspath);
 			}
 			return url;
 		}

 		private String getFlagStr(long OffSet, RandomAccessFile fis) throws IOException {
 			int flag = 0;
 			byte[] buff = null;
 			do {
 				fis.seek(OffSet);
 				buff = new byte[1];
 				fis.read(buff);
 				flag = (buff[0] < 0) ? 256 + buff[0] : buff[0];
 				if (flag == 1 || flag == 2) {
 					buff = new byte[3];
 					fis.read(buff);
 					if (flag == 2) {
 						countryFlag = 2;
 						endIPOff = OffSet - 4;
 					}
 					OffSet = this.byteToLong(buff);
 				} else
 					break;
 			} while (true);

 			if (OffSet < 12) {
 				return "";
 			} else {
 				fis.seek(OffSet);
 				return getText(fis);
 			}
 		}

 		private String getText(RandomAccessFile fis) throws IOException {
 			long len = fis.length();
 			ByteArrayOutputStream byteout = new ByteArrayOutputStream();
 			byte ch = fis.readByte();
 			do {
 				byteout.write(ch);
 				ch = fis.readByte();
 			} while (ch != 0 && fis.getFilePointer() < len);
 			return byteout.toString("gbk");
 		}

 		private void loadCountry(long ipn, RandomAccessFile fis) throws IOException {
 			if (countryFlag == 1 || countryFlag == 2) {
 				country = getFlagStr(endIPOff + 4, fis);
 				if (countryFlag == 1) {
 					location = getFlagStr(fis.getFilePointer(), fis);
 					if (ipn >= ipToLong("255.255.255.0") && ipn <= ipToLong("255.255.255.255")) {
 						location = getFlagStr(endIPOff + 21, fis);
 						country = getFlagStr(endIPOff + 12, fis);
 					}
 				} else {
 					location = getFlagStr(endIPOff + 8, fis);
 				}
 			} else {
 				country = getFlagStr(endIPOff + 4, fis);
 				location = getFlagStr(fis.getFilePointer(), fis);
 			}
 		}

 		private long loadEndIP(RandomAccessFile fis) throws IOException {
 			byte[] buff = null;
 			fis.seek(endIPOff);
 			buff = new byte[4];
 			fis.read(buff);
 			endIP = this.byteToLong(buff);
 			buff = new byte[1];
 			fis.read(buff);
 			countryFlag = (buff[0] < 0) ? 256 + buff[0] : buff[0];
 			return endIP;
 		}

 		private long loadStartIP(long RecNo, RandomAccessFile fis) throws IOException {
 			byte[] buff = null;
 			offSet = firstStartIP + RecNo * 7;
 			fis.seek(offSet);
 			buff = new byte[4];
 			fis.read(buff);
 			startIP = this.byteToLong(buff);
 			buff = new byte[3];
 			fis.read(buff);
 			endIPOff = this.byteToLong(buff);
 			return startIP;
 		}
 	}
	
}
