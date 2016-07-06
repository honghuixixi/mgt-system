package cn.qpwa.common.utils.http;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.http.*;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.io.*;
import java.net.*;
import java.nio.charset.Charset;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * httpclient工具类
 */
@SuppressWarnings("all")
public class HttpUtil {
	// private static final DefaultHttpClient httpClient = new
	// DefaultHttpClient();

	Logger logger = Logger.getLogger(this.getClass());
	private DefaultHttpClient httpClient;

	private HttpUtil() {

	}

	private static class INSTALL_HANDLER {
		private static HttpUtil INSTALL;
		static {
			INSTALL = new HttpUtil();
			INSTALL.httpClient = new DefaultHttpClient();
		}
	}

	public static HttpUtil getInstall() {
		return INSTALL_HANDLER.INSTALL;
	}

	public static enum HttpMethod {
		GET, POST
	}

	public void asyncConnect(final String url, final HttpMethod method, final HttpConnectionCallback callback) {
		asyncConnect(url, null, method, callback);
	}

	public void syncConnect(final String url, final HttpMethod method, final HttpConnectionCallback callback) {
		syncConnect(url, null, method, callback);
	}

	public void asyncConnect(final String url, final Map<String, String> params, final HttpMethod method,
			final HttpConnectionCallback callback) {
		// Handler handler = new Handler();
		Runnable runnable = new Runnable() {
			public void run() {
				syncConnect(url, params, method, callback);
			}
		};

		new Thread(runnable).start();
		// handler.post(runnable);
	}

	public void syncConnect(final String url, final Map<String, String> params, final HttpMethod method,
			final HttpConnectionCallback callback) {
		String json = null;
		BufferedReader reader = null;
		try {
			HttpClient client = getHttpClient();
			HttpUriRequest request = getRequest(url, params, method);
			HttpResponse response = client.execute(request);
			if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
				StringBuilder sb = new StringBuilder();
				for (String s = reader.readLine(); s != null; s = reader.readLine()) {
					sb.append(s);
				}
				json = sb.toString();
			}
		} catch (ClientProtocolException e) {
			// Log.e("HttpConnectionUtil", e.getMessage(), e);
		} catch (IOException e) {
			// Log.e("HttpConnectionUtil", e.getMessage(), e);
		} finally {
			try {
				if (reader != null) {
					reader.close();
				}
			} catch (IOException e) {
			}
		}
		callback.execute(json);
	}

	@SuppressWarnings("deprecation")
	private HttpUriRequest getRequest(String url, Map<String, String> params, HttpMethod method) {
		if (method.equals(HttpMethod.POST)) {
			List<NameValuePair> listParams = new ArrayList<NameValuePair>();
			if (params != null) {
				for (String name : params.keySet()) {
					listParams.add(new BasicNameValuePair(name, params.get(name)));
				}
			}
			try {
				UrlEncodedFormEntity entity = new UrlEncodedFormEntity(listParams);
				HttpPost request = new HttpPost(url);
				request.setHeader(HTTP.CONTENT_TYPE, "application/x-www-form-urlencoded");
				request.setEntity(entity);
				return request;
			} catch (UnsupportedEncodingException e) {
				throw new RuntimeException(e.getMessage(), e);
			}
		} else {
			if (url.indexOf("?") < 0) {
				url += "?";
			}
			if (params != null) {
				for (String name : params.keySet()) {
					url += "&" + name + "=" + URLEncoder.encode(params.get(name));
				}
			}
			HttpGet request = new HttpGet(url);
			return request;
		}
	}

	public HttpClient getHttpClient() {
		HttpClient result = new DefaultHttpClient();
		return result;
	}

	/**
	 *
	 * 发送HTTP_GET请求
	 *
	 * @see 该方法会自动关闭连接,释放资源
	 *
	 * @param requestURL
	 *            请求地址(含参数)
	 *
	 * @param decodeCharset
	 *            解码字符集,解析响应数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @return 远程主机响应正文
	 */

	public String sendGetRequest(String reqURL, String decodeCharset) {
		long responseLength = 0; // 响应长度
		String responseContent = null; // 响应内容
		HttpClient httpClient = getHttpClient(); // 创建默认的httpClient实例
		HttpGet httpGet = new HttpGet(reqURL); // 创建org.apache.http.client.methods.HttpGet
		try {
			HttpResponse response = httpClient.execute(httpGet); // 执行GET请求
			HttpEntity entity = response.getEntity(); // 获取响应实体
			if (null != entity) {
				responseLength = entity.getContentLength();
				responseContent = EntityUtils.toString(entity, decodeCharset == null ? "UTF-8" : decodeCharset);
				EntityUtils.consume(entity); // Consume response content
			}

			System.out.println("请求地址: " + httpGet.getURI());
			System.out.println("响应状态: " + response.getStatusLine());
			System.out.println("响应长度: " + responseLength);
			System.out.println("响应内容: " + responseContent);

		} catch (ClientProtocolException e) {
			log("该异常通常是协议错误导致,比如构造HttpGet对象时传入的协议不对(将'http'写成'htp')或者服务器端返回的内容不符合HTTP协议要求等,堆栈信息如下", e);
		} catch (ParseException e) {
			log(e.getMessage(), e);
		} catch (IOException e) {
			log("该异常通常是网络原因引起的,如HTTP服务器未启动等,堆栈信息如下", e);
		} finally {
			httpClient.getConnectionManager().shutdown(); // 关闭连接,释放资源
		}

		return responseContent;
	}

	/**
	 *
	 * 发送HTTP_POST请求
	 *
	 * @see 该方法为<code>sendPostRequest(String,String,boolean,String,String)</code>的简化方法
	 *
	 * @see 该方法在对请求数据的编码和响应数据的解码时,所采用的字符集均为UTF-8
	 *
	 * @see 当<code>isEncoder=true</code>时,其会自动对<code>sendData</code>中的[中文][|][ ]等特殊字符进行<code>URLEncoder.encode(string,"UTF-8")</code>
	 *
	 * @param isEncoder
	 *            用于指明请求数据是否需要UTF-8编码,true为需要
	 */

	public String sendPostRequest(String reqURL, String sendData, boolean isEncoder) {
		return sendPostRequest(reqURL, sendData, isEncoder, null, null);

	}

	/**
	 *
	 * {方法的功能/动作描述}
	 */
	public String sendPostRequest(String reqURL, String sendData) {
		String responseContent = null;
		HttpClient httpClient = getHttpClient();

		return this.sendPostRequest(reqURL, sendData, null);

	}

	/**
	 *
	 * {方法的功能/动作描述}
	 */
	public String sendPostRequest(String reqURL, String sendData, String contentType) {
		String responseContent = null;
		HttpClient httpClient = getHttpClient();

		try {

			HttpPost httpPost = new HttpPost(reqURL);
			if (null == contentType || "".equals(contentType)) {
				httpPost.setHeader(HTTP.CONTENT_TYPE, "application/x-www-form-urlencoded");
			} else {
				httpPost.setHeader(HTTP.CONTENT_TYPE, contentType);
			}

			StringEntity entity = new StringEntity(sendData, "UTF-8");
			httpPost.setEntity(entity);
			HttpResponse response = httpClient.execute(httpPost);
			HttpEntity resEntity = response.getEntity();

			if (null != resEntity) {
				responseContent = EntityUtils.toString(resEntity);
				EntityUtils.consume(resEntity);

			}
		} catch (Exception e) {// 异常时返回0
			e.printStackTrace();
			return "0";

		} finally {
			httpClient.getConnectionManager().shutdown();
		}

		return responseContent;

	}

	/**
	 *
	 * 发送HTTP_POST请求
	 *
	 * @see 该方法会自动关闭连接,释放资源
	 *
	 * @see 当<code>isEncoder=true</code>时,其会自动对<code>sendData</code>中的[中文][|][ ]等特殊字符进行<code>URLEncoder.encode(string,encodeCharset)</code>
	 *
	 * @param reqURL
	 *            请求地址
	 *
	 * @param sendData
	 *            请求参数,若有多个参数则应拼接成param11=value11¶m22=value22¶m33=value33的形式后,传入该参数中
	 *
	 * @param isEncoder
	 *            请求数据是否需要encodeCharset编码,true为需要
	 *
	 * @param encodeCharset
	 *            编码字符集,编码请求数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @param decodeCharset
	 *            解码字符集,解析响应数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @return 远程主机响应正文
	 */

	public String sendPostRequest(String reqURL, String sendData, boolean isEncoder, String encodeCharset,
			String decodeCharset) {

		String responseContent = null;

		HttpClient httpClient = getHttpClient();

		HttpPost httpPost = new HttpPost(reqURL);

		// httpPost.setHeader(HTTP.CONTENT_TYPE,
		// "application/x-www-form-urlencoded; charset=UTF-8");

		httpPost.setHeader(HTTP.CONTENT_TYPE, "application/x-www-form-urlencoded");

		try {

			if (isEncoder) {

				List<NameValuePair> formParams = new ArrayList<NameValuePair>();

				for (String str : sendData.split("&")) {

					formParams.add(new BasicNameValuePair(str.substring(0, str.indexOf("=")), str.substring(str
							.indexOf("=") + 1)));

				}

				httpPost.setEntity(new StringEntity(URLEncodedUtils.format(formParams, encodeCharset == null ? "UTF-8"
						: encodeCharset)));

			} else {
				httpPost.setEntity(new StringEntity(sendData));
			}

			HttpResponse response = httpClient.execute(httpPost);
			HttpEntity entity = response.getEntity();

			if (null != entity) {
				responseContent = EntityUtils.toString(entity, decodeCharset == null ? "UTF-8" : decodeCharset);
				EntityUtils.consume(entity);
			}

		} catch (Exception e) {

			log("与[" + reqURL + "]通信过程中发生异常,堆栈信息如下", e);

		} finally {

			httpClient.getConnectionManager().shutdown();

		}

		return responseContent;

	}

	/**
	 *
	 * 发送HTTP_POST请求
	 *
	 * @see 该方法会自动关闭连接,释放资源
	 *
	 * @see 该方法会自动对<code>params</code>中的[中文][|][ ]等特殊字符进行<code>URLEncoder.encode(string,encodeCharset)</code>
	 *
	 * @param reqURL
	 *            请求地址
	 *
	 * @param params
	 *            请求参数
	 *
	 * @param encodeCharset
	 *            编码字符集,编码请求数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @param decodeCharset
	 *            解码字符集,解析响应数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @return 远程主机响应正文
	 */

	public String sendPostRequest(String reqURL, Map<String, String> params, String encodeCharset, String decodeCharset) {

		String responseContent = null;

		HttpClient httpClient = getHttpClient();

		HttpPost httpPost = new HttpPost(reqURL);

		List<NameValuePair> formParams = new ArrayList<NameValuePair>(); // 创建参数队列

		for (Entry<String, String> entry : params.entrySet()) {

			formParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));

		}

		try {

			httpPost.setEntity(new UrlEncodedFormEntity(formParams, encodeCharset == null ? "UTF-8" : encodeCharset));

			HttpResponse response = httpClient.execute(httpPost);

			HttpEntity entity = response.getEntity();

			if (null != entity) {

				responseContent = EntityUtils.toString(entity, decodeCharset == null ? "UTF-8" : decodeCharset);

				EntityUtils.consume(entity);

			}

		} catch (Exception e) {
			log("与[" + reqURL + "]通信过程中发生异常,堆栈信息如下", e);
		} finally {
			httpClient.getConnectionManager().shutdown();
		}

		return responseContent;

	}

	/**
	 *
	 * 发送HTTPS_POST请求
	 *
	 * @see 该方法为<code>sendPostSSLRequest(String,Map<String,String>,String,String)</code>方法的简化方法
	 *
	 * @see 该方法在对请求数据的编码和响应数据的解码时,所采用的字符集均为UTF-8
	 *
	 * @see 该方法会自动对<code>params</code>中的[中文][|][ ]等特殊字符进行<code>URLEncoder.encode(string,"UTF-8")</code>
	 */

	public String sendPostSSLRequest(String reqURL, Map<String, String> params) {

		return sendPostSSLRequest(reqURL, params, null, null);

	}

	/**
	 *
	 * 发送HTTPS_POST请求
	 *
	 * @see 该方法会自动关闭连接,释放资源
	 *
	 * @see 该方法会自动对<code>params</code>中的[中文][|][ ]等特殊字符进行<code>URLEncoder.encode(string,encodeCharset)</code>
	 *
	 * @param reqURL
	 *            请求地址
	 *
	 * @param params
	 *            请求参数
	 *
	 * @param encodeCharset
	 *            编码字符集,编码请求数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @param decodeCharset
	 *            解码字符集,解析响应数据时用之,其为null时默认采用UTF-8解码
	 *
	 * @return 远程主机响应正文
	 */

	public String sendPostSSLRequest(String reqURL, Map<String, String> params, String encodeCharset,
			String decodeCharset) {

		String responseContent = "";

		HttpClient httpClient = getHttpClient();

		X509TrustManager xtm = new X509TrustManager() {

			public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
			}

			public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
			}

			public X509Certificate[] getAcceptedIssuers() {
				return null;
			}

		};

		try {

			SSLContext ctx = SSLContext.getInstance("TLS");

			ctx.init(null, new TrustManager[] { xtm }, null);

			SSLSocketFactory socketFactory = new SSLSocketFactory(ctx);

			httpClient.getConnectionManager().getSchemeRegistry().register(new Scheme("https", 443, socketFactory));

			HttpPost httpPost = new HttpPost(reqURL);

			List<NameValuePair> formParams = new ArrayList<NameValuePair>();

			for (Entry<String, String> entry : params.entrySet()) {

				formParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));

			}

			httpPost.setEntity(new UrlEncodedFormEntity(formParams, encodeCharset == null ? "UTF-8" : encodeCharset));

			HttpResponse response = httpClient.execute(httpPost);

			HttpEntity entity = response.getEntity();

			if (null != entity) {

				responseContent = EntityUtils.toString(entity, decodeCharset == null ? "UTF-8" : decodeCharset);

				EntityUtils.consume(entity);

			}

		} catch (Exception e) {

			log("与[" + reqURL + "]通信过程中发生异常,堆栈信息为", e);

		} finally {

			httpClient.getConnectionManager().shutdown();

		}

		return responseContent;

	}

	/**
	 *
	 * 发送HTTP_POST请求
	 *
	 * @see 若发送的<code>params</code>中含有中文,记得按照双方约定的字符集将中文<code>URLEncoder.encode(string,encodeCharset)</code>
	 *
	 * @see 本方法默认的连接超时时间为30秒,默认的读取超时时间为30秒
	 *
	 * @param reqURL
	 *            请求地址
	 *
	 * @param params
	 *            发送到远程主机的正文数据,其数据类型为<code>java.util.Map<String, String></code>
	 *
	 * @return 远程主机响应正文`HTTP状态码,如<code>"SUCCESS`200"</code><br>
	 *         若通信过程中发生异常则返回"Failed`HTTP状态码",如<code>"Failed`500"</code>
	 */

	public static String sendPostRequestByJava(String reqURL, Map<String, String> params) {

		StringBuilder sendData = new StringBuilder();

		for (Entry<String, String> entry : params.entrySet()) {

			sendData.append(entry.getKey()).append("=").append(entry.getValue()).append("&");
		}

		if (sendData.length() > 0) {
			sendData.setLength(sendData.length() - 1); // 删除最后一个&符号
		}

		return sendPostRequestByJava(reqURL, sendData.toString());

	}

	/**
	 * 
	 * 发送HTTP_POST请求
	 * 
	 * @see 若发送的<code>sendData</code>中含有中文,记得按照双方约定的字符集将中文<code>URLEncoder.encode(string,encodeCharset)</code>
	 * 
	 * @see 本方法默认的连接超时时间为30秒,默认的读取超时时间为30秒
	 * 
	 * @param reqURL
	 *            请求地址
	 * 
	 * @param sendData
	 *            发送到远程主机的正文数据
	 * 
	 * @return 远程主机响应正文`HTTP状态码,如<code>"SUCCESS`200"</code><br>
	 *         若通信过程中发生异常则返回"Failed`HTTP状态码",如<code>"Failed`500"</code>
	 */

	public static String sendPostRequestByJava(String reqURL, String sendData) {
		HttpURLConnection httpURLConnection = null;
		OutputStream out = null; // 写
		InputStream in = null; // 读
		int httpStatusCode = 0; // 远程主机响应的HTTP状态码
		try {
			URL sendUrl = new URL(reqURL);
			httpURLConnection = (HttpURLConnection) sendUrl.openConnection();
			httpURLConnection.setRequestMethod("POST");
			httpURLConnection.setDoOutput(true); // 指示应用程序要将数据写入URL连接,其值默认为false
			httpURLConnection.setUseCaches(false);
			httpURLConnection.setConnectTimeout(30000); // 30秒连接超时
			httpURLConnection.setReadTimeout(30000); // 30秒读取超时
			out = httpURLConnection.getOutputStream();
			out.write(sendData.toString().getBytes());

			// 清空缓冲区,发送数据

			out.flush();

			// 获取HTTP状态码

			httpStatusCode = httpURLConnection.getResponseCode();

			// 该方法只能获取到[HTTP/1.0 200 OK]中的[OK]

			// 若对方响应的正文放在了返回报文的最后一行,则该方法获取不到正文,而只能获取到[OK],稍显遗憾

			// respData = httpURLConnection.getResponseMessage();

			// //处理返回结果

			// BufferedReader br = new BufferedReader(new
			// InputStreamReader(httpURLConnection.getInputStream()));

			// String row = null;

			// String respData = "";

			// if((row=br.readLine()) != null){
			// //readLine()方法在读到换行[\n]或回车[\r]时,即认为该行已终止

			// respData = row; //HTTP协议POST方式的最后一行数据为正文数据

			// }

			// br.close();
			in = httpURLConnection.getInputStream();

			byte[] byteDatas = new byte[in.available()];

			in.read(byteDatas);

			return new String(byteDatas) + "`" + httpStatusCode;

		} catch (Exception e) {

			log(e.getMessage(), e);

			return "Failed`" + httpStatusCode;

		} finally {

			if (out != null) {

				try {

					out.close();

				} catch (Exception e) {
					log("关闭输出流时发生异常,堆栈信息如下", e);
				}
			}
			if (in != null) {
				try {
					in.close();
				} catch (Exception e) {
					log("关闭输入流时发生异常,堆栈信息如下", e);
				}
			}
			if (httpURLConnection != null) {
				httpURLConnection.disconnect();
				httpURLConnection = null;
			}
		}
	}

	/**
	 * 上传附件
	 * @Title: postFiles
	 * @param files
	 * @param params
	 * @param url
	 * @return
	 */
	public String postFiles(Map<String, File> files, Map<String, String> params, String url) {
		String result = null;
		try {
			if (StringUtils.isBlank(url)) {
				logger.debug("postFiles url is null or empty");
				return result;
			}

			HttpClient client = getHttpClient();
			HttpPost httppost = new HttpPost(url);

			MultipartEntity reqEntity = new MultipartEntity();
			if (params != null && params.size() > 0) {
				for (Entry<String, String> entry : params.entrySet()) {
					reqEntity.addPart(entry.getKey(), new StringBody(entry.getValue(), Charset.forName("utf-8")));

				}
			}

			if (files != null && files.size() > 0) {
				for (Entry<String, File> entry : files.entrySet()) {
					String key = entry.getKey();
					File file = entry.getValue();
					if (StringUtils.isNotBlank(key) && file != null && file.exists() && file.isFile()) {
						reqEntity.addPart(key, new FileBody(file, getFileNameRcn(file.getName()), "", "utf-8"));
					}
				}
			}

			httppost.setEntity(reqEntity);

			// System.out.println("执行: " + httppost.getRequestLine());
			logger.debug("执行: " + httppost.getRequestLine());
			HttpResponse response = client.execute(httppost);

			HttpEntity resEntity = response.getEntity();

			logger.debug("执行结果：" + response.getStatusLine().getStatusCode());
			if (null != resEntity) {
				result = EntityUtils.toString(resEntity, "utf-8");
				logger.debug("返回结果:" + result);
				EntityUtils.consume(resEntity);
			}

		} catch (Exception e) {
			logger.error(ExceptionUtils.getFullStackTrace(e));
		}

		return result;
	}

	/**
	 * 去除非字母与数值 的其他字符  如中文，中文的标点，英文标点等
	 * @Title: getFileNameRcn
	 *
	 * @param str
	 * @return
	 */
	private static String getFileNameRcn(String str) {
		String result = null;
		result = StringUtils.defaultIfEmpty(str, Math.round(Math.random() * 10000) + "");
		StringBuffer sb = new StringBuffer();

		for (byte b : result.getBytes()) {
			int i = b;
			if (i >= 97 && i <= 122) {
				sb.append((char) b);
			} else if (i >= 65 && i <= 90) {
				sb.append((char) b);
			} else if (i >= 48 && i <= 57) {
				sb.append((char) b);
			} else if (i == 46) {
				sb.append((char) b);
			}
			// String abc = "azAZ09.";
			// for (byte b : abc.getBytes()) {
			// System.out.println((int)b);
			// }
			// 97
			// 122
			// 65
			// 90
			// 48
			// 57
			// 46
		}

		result = sb.toString();
		return result;
	}

	/**
	 * 下载文件，把文件保存在System.property 的 java.io.tmpdir 目录中
	 * @Title: download
	 * @param params
	 * @param url
	 * @return
	 */
	public File download(Map<String, String> params, String url) {
		File result = null;
		HttpClient httpClient = getHttpClient();
		OutputStream out = null;
		InputStream in = null;
		try {
			HttpPost post = new HttpPost(url);
			if (params != null && params.size() > 0) {
				List<NameValuePair> listParams = new ArrayList<NameValuePair>();
				for (Entry<String, String> entry : params.entrySet()) {
					listParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
				}
				post.setEntity(new UrlEncodedFormEntity(listParams, Charset.forName("utf-8")));
				HttpResponse response = httpClient.execute(post);
				String filename = "";
				if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
					Header d_header = response.getLastHeader("Content-Disposition");
					// 取文件名称
					if (d_header != null) {
						HeaderElement[] els = d_header.getElements();
						if (els != null && els.length > 0) {
							loop: for (HeaderElement headerElement : els) {
								String name = headerElement.getName();
								if ("attachment".equalsIgnoreCase(name)) {
									NameValuePair[] nameValuepairs = headerElement.getParameters();
									if (nameValuepairs != null && nameValuepairs.length > 0) {
										for (NameValuePair nameValuePair : nameValuepairs) {
											if ("filename".equalsIgnoreCase(nameValuePair.getName())) {
												filename = nameValuePair.getValue();
												filename = new String(filename.getBytes("ISO-8859-1"), "utf-8");
												break loop;
											}
										}
									}
								}
							}
						}
					}

					HttpEntity responseEntity = response.getEntity();
					if (responseEntity != null) {
						in = responseEntity.getContent();
						filename = System.getProperty("java.io.tmpdir")
								+ File.separator
								+ StringUtils.defaultIfEmpty(filename,
										String.valueOf(Math.round(Math.random() * 100000)));
						result = new File(filename);
						out = new FileOutputStream(result);

						byte[] b = new byte[1024];
						int length = 0;
						while ((length = in.read(b)) != -1) {
							out.write(b, 0, length);
						}
						out.flush();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				httpClient.getConnectionManager().shutdown(); // 关闭连接,释放资源
				if (in != null) {
					in.close();
				}
				if (out != null) {
					out.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	public String sendJSON(String url, String jsonStr) {
		String result = "";
		HttpClient client = getHttpClient();

		HttpPost post = new HttpPost(url);
		post.setHeader (HTTP.CONTENT_TYPE, "application/json;charset=UTF-8");
		post.setEntity(new StringEntity(jsonStr, Charset.forName("UTF-8")));

		try {
			HttpResponse response = client.execute(post);
			HttpEntity entity = response.getEntity();
			result = EntityUtils.toString(entity);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 是否异步发送json
	 * @Title: sendJSON
	 *
	 * @param url
	 * @param jsonStr
	 * @param asyncFlag
	 * @return
	 */
	public String sendJSON(final String url, final String jsonStr, boolean asyncFlag) {
		if (asyncFlag) {
			ExecutorService executorService = Executors.newSingleThreadExecutor();
			try {
				executorService.execute(new Runnable() {
					@Override
					public void run() {
						if (logger.isDebugEnabled()) {
							HttpUtil.this.logger.debug("sendJSON(url,jsonStr,asycFlag),url=" + url + ";jsonStr="
									+ jsonStr);
						}
						String result = HttpUtil.this.sendJSON(url, jsonStr);
						Logger logger = HttpUtil.this.logger;
						if (logger.isDebugEnabled()) {
							HttpUtil.this.logger.debug("sendJSON(url,jsonStr,asycFlag) result:" + result);
						}
					}
				});
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				executorService.shutdown();
			}
		} else {
			return HttpUtil.this.sendJSON(url, jsonStr);
		}
		return "";
	}

	public static void log(String str, Exception e) {
		System.out.println(str);
	}
	public String sendXML(String url, String xmlStr) {
		String result = "";
		HttpClient client = getHttpClient();
		
		HttpPost post = new HttpPost(url);
		post.setHeader(HTTP.CONTENT_TYPE, "text/xml");
		post.setEntity(new StringEntity(xmlStr, Charset.forName("utf-8")));
		
		try {
			HttpResponse response = client.execute(post);
			HttpEntity entity = response.getEntity();
			result = EntityUtils.toString(entity);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 获取本地主机的地址信息
	 * This class represents an Internet Protocol (IP) address.
	 * @return
	 */
    public static InetAddress getInetAddress(){
        try{
            return InetAddress.getLocalHost();
        }catch(UnknownHostException e){
            System.out.println("unknown host!");
        }
        return null;
    }
    
    /**
     * 获取ip地址
     * @param netAddress
     * @return
     */
    public static String getHostAddress(){
    	 InetAddress netAddress = getInetAddress();
    	 if(null == netAddress){
             return null;
         }
    	 String ipAddress = netAddress.getHostAddress();
    	 return ipAddress;
    }
    
    /**
     * 获取本地主机名称
     * @param netAddress
     * @return
     */
    public static String getHostName(){
    	InetAddress netAddress = getInetAddress();
        if(null == netAddress){
            return null;
        }
        String name = netAddress.getHostName(); //get the host address
        return name;
    }


}
