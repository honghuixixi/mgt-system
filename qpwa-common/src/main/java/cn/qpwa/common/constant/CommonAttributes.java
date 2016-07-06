package cn.qpwa.common.constant;

import java.math.BigDecimal;

/**
 * 公共参数
 * @author wei
 * @version 1.0
 */
public final class CommonAttributes {

	/** 日期格式配比 */
	public static final String[] DATE_PATTERNS = new String[] { "yyyy", "yyyy-MM", "yyyyMM", "yyyy/MM", "yyyy-MM-dd", "yyyyMMdd", "yyyy/MM/dd", "yyyy-MM-dd HH:mm:ss", "yyyyMMddHHmmss", "yyyy/MM/dd HH:mm:ss" };

	/** qpwa.xml文件路径 */
	public static final String QPWA_XML_PATH = "/qpwa.xml";

	/** qpwa.properties文件路径 */
	public static final String QPWA_PROPERTIES_PATH = "/qpwa.properties";
	
	/**字段默认值 Y*/
	public static final String COLUMN_DEFAULT_YES = "Y";
	
	/**字段默认值 N*/
	public static final String COLUMN_DEFAULT_NO = "N";
	
	/**组织机构代码*/
	public static final BigDecimal ORG_NO = new BigDecimal(100);
	
	/**默认地址*/
	public static final BigDecimal AREA_ID = new BigDecimal(3350);
	
	/**商品图片服务器访问地址前缀*/
//	public static final String PRO_IMG_SERV = "http://192.168.1.228/upload/prod/";
	public static final String PRO_IMG_SERV = "http://image1.qpwa.cn/upload/prod/";
	
	/**广告图片服务器访问地址前缀*/
//	public static final String PRO_IMG_SERV = "http://192.168.1.228/upload/adImg/";
	public static final String AD_IMG_SERV = "http://image1.qpwa.cn/upload/adImg/";
	
	/**促销图片服务器访问地址前缀*/
	public static final String PROM_IMG_SERV = "http://image1.qpwa.cn/upload/prod/promotion/";

	/**
	 * 不可实例化
	 */
	private CommonAttributes() {
	}

}