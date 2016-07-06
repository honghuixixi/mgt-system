package cn.qpwa.common.utils.setting;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 系统设置
 * 
 * @author 
 * @version 1.0
 */
public class Setting implements Serializable {

	private static final long serialVersionUID = -1478999889661796840L;
	
	/**
	 * 小数位精确方式
	 */
	public enum RoundType {

		/** 四舍五入 */
		roundHalfUp,

		/** 向上取整 */
		roundUp,

		/** 向下取整 */
		roundDown
	}

	/**
	 * 验证码类型
	 */
	public enum CaptchaType {

		/** 会员登录 */
		memberLogin,

		/** 会员注册 */
		memberRegister,

		/** 后台登录 */
		adminLogin,

		/** 商品评论 */
		review,

		/** 商品咨询 */
		consultation,

		/** 找回密码 */
		findPassword,

		/** 重置密码 */
		resetPassword,
		/** 修改验证手机 */
		modifyMobile,

		/** 其它 */
		other
	}
	/** 图片存储路径 */
	private String imgSave;
	
	/** 缓存管理请求路径 */
	private String cacheUrl;
	
	private String cacheClearUrl;
	
	/** 缓存名称 */
	public static final String CACHE_NAME = "setting";

	/** 缓存Key */
	public static final Integer CACHE_KEY = 0;

	/** 分隔符 */
	private static final String SEPARATOR = ",";

	/** 验证码类型 */
	private CaptchaType[] captchaTypes;
	
	/** 密码最小长度 */
	private Integer passwordMaxLength;
	
	/** 用户名最小长度 */
	private Integer usernameMinLength;

	/** 用户名最大长度 */
	private Integer usernameMaxLength;
	
	/** 禁用用户名 */
	private String disabledUsername;
	
	/** 上传文件最大限制 */
	private Integer uploadMaxSize;
	
	/** 允许上传图片扩展名 */
	private String uploadImageExtension;
	
	/** 邮箱链接有效时间 */
	private Integer expiryTime;
	
	/** 发件人邮箱 */
	private String smtpFromMail;

	/** SMTP服务器地址 */
	private String smtpHost;

	/** SMTP服务器端口 */
	private Integer smtpPort;

	/** SMTP用户名 */
	private String smtpUsername;

	/** SMTP密码 */
	private String smtpPassword;
	
	/** 网站名称 */
	private String siteName;
	
	/** QQ第三方登录ID */
	private String appId;
	
	/** QQ第三方登录返回类型 */
	private String responseType;
	
	/** QQ第三方登录请求API */
	private String scope;
	
	/** QQ第三方登录KEY */
	private String appKey;
	
	/** QQ第三方登录回调地址 */
	private String redirectUri;
	
	/** QQ第三方登录回调地址 */
	private String qqLoginUrl;
	
	/** QQ第三方登录令牌获取URL */
	private String tokenUrl;
	
	/** QQ第三方登录OpenID */
	private String openIDUrl;
	
	/** QQ第三方登录获取用户信息接口URL */
	private String userInfoURL;
	
	/** P2C百度云推送apikey */
	private String p2cApiKey;
	
	/**P2C百度云推送secretKey */
	private String p2cSecretKey;
	
	/** B2B百度云推送apikey */
	private String b2bApiKey;
	
	/**B2B百度云推送secretKey */
	private String b2bSecretKey;
	
	/**前台结果返回地址 */
	private String frontUrl;
	
	/**后台结果返回地址 */
	private String backUrl;
	
	/**产品类型  
	 * 依据实际业务场景填写(目前仅使用后 4 位，签名 2 位
	 * 	默认为 00)
	 * 	默认取值：000000
	 * 	具体取值范围：
	 * 	000101：基金业务之股票基金
	 * 	000102：基金业务之货币基金
	 * 	000201：B2C 网关支付
	 * 	000301：认证支付 2.0
	 * 	000302：评级支付
	 * 	000401：代付
	 * 	000501：代收
	 * 	000601：账单支付
	 * 	 000801：跨行收单
	 * 	000901：绑定支付
	 * 	001001：订购
	 * 	000202：B2B
	 * */
	private String bizType;
	
	/**渠道类型   05：语音      07：互联网          08：移动 */
	private String channelType;
	
	/**商户号*/
	private String merId;
	
	public String getFrontUrl() {
		return frontUrl;
	}

	public void setFrontUrl(String frontUrl) {
		this.frontUrl = frontUrl;
	}

	public String getBackUrl() {
		return backUrl;
	}

	public void setBackUrl(String backUrl) {
		this.backUrl = backUrl;
	}

	public String getBizType() {
		return bizType;
	}

	public void setBizType(String bizType) {
		this.bizType = bizType;
	}

	public String getChannelType() {
		return channelType;
	}

	public void setChannelType(String channelType) {
		this.channelType = channelType;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}

	public String getP2cApiKey() {
		return p2cApiKey;
	}

	public void setP2cApiKey(String p2cApiKey) {
		this.p2cApiKey = p2cApiKey;
	}

	public String getP2cSecretKey() {
		return p2cSecretKey;
	}

	public void setP2cSecretKey(String p2cSecretKey) {
		this.p2cSecretKey = p2cSecretKey;
	}

	public String getB2bApiKey() {
		return b2bApiKey;
	}

	public void setB2bApiKey(String b2bApiKey) {
		this.b2bApiKey = b2bApiKey;
	}

	public String getB2bSecretKey() {
		return b2bSecretKey;
	}

	public void setB2bSecretKey(String b2bSecretKey) {
		this.b2bSecretKey = b2bSecretKey;
	}

	public String getTokenUrl() {
		return tokenUrl;
	}

	public void setTokenUrl(String tokenUrl) {
		this.tokenUrl = tokenUrl;
	}

	public String getOpenIDUrl() {
		return openIDUrl;
	}

	public void setOpenIDUrl(String openIDUrl) {
		this.openIDUrl = openIDUrl;
	}

	public String getUserInfoURL() {
		return userInfoURL;
	}

	public void setUserInfoURL(String userInfoURL) {
		this.userInfoURL = userInfoURL;
	}

	public String getResponseType() {
		return responseType;
	}

	public void setResponseType(String responseType) {
		this.responseType = responseType;
	}

	public String getScope() {
		return scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public String getQqLoginUrl() {
		return qqLoginUrl;
	}

	public void setQqLoginUrl(String qqLoginUrl) {
		this.qqLoginUrl = qqLoginUrl;
	}

	public String getAppId() {
		return appId;
	}

	public void setAppId(String appId) {
		this.appId = appId;
	}

	public String getAppKey() {
		return appKey;
	}

	public void setAppKey(String appKey) {
		this.appKey = appKey;
	}

	public String getRedirectUri() {
		return redirectUri;
	}

	public void setRedirectUri(String redirectUri) {
		this.redirectUri = redirectUri;
	}

	/**
	 * 获取邮箱链接有效时间
	 * @return 邮箱链接有效时间
	 */
	@NotNull
	@Min(0)
	public Integer getExpiryTime() {
		return expiryTime;
	}

	/**
	 * 设置安全密匙有效时间
	 * @param expiryTime 邮箱链接有效时间
	 */
	public void setExpiryTime(Integer expiryTime) {
		this.expiryTime = expiryTime;
	}
	
	/**
	 * 获取发件人邮箱
	 * @return 发件人邮箱
	 */
	@NotEmpty
	@Email
	@Length(max = 200)
	public String getSmtpFromMail() {
		return smtpFromMail;
	}

	/**
	 * 设置发件人邮箱
	 * 
	 * @param smtpFromMail
	 *            发件人邮箱
	 */
	public void setSmtpFromMail(String smtpFromMail) {
		this.smtpFromMail = smtpFromMail;
	}

	/**
	 * 获取SMTP服务器地址
	 * 
	 * @return SMTP服务器地址
	 */
	@NotEmpty
	@Length(max = 200)
	public String getSmtpHost() {
		return smtpHost;
	}

	/**
	 * 设置SMTP服务器地址
	 * 
	 * @param smtpHost
	 *            SMTP服务器地址
	 */
	public void setSmtpHost(String smtpHost) {
		this.smtpHost = smtpHost;
	}

	/**
	 * 获取SMTP服务器端口
	 * 
	 * @return SMTP服务器端口
	 */
	@NotNull
	@Min(0)
	public Integer getSmtpPort() {
		return smtpPort;
	}

	/**
	 * 设置SMTP服务器端口
	 * 
	 * @param smtpPort
	 *            SMTP服务器端口
	 */
	public void setSmtpPort(Integer smtpPort) {
		this.smtpPort = smtpPort;
	}

	/**
	 * 获取SMTP用户名
	 * 
	 * @return SMTP用户名
	 */
	@NotEmpty
	@Length(max = 200)
	public String getSmtpUsername() {
		return smtpUsername;
	}

	/**
	 * 设置SMTP用户名
	 * 
	 * @param smtpUsername
	 *            SMTP用户名
	 */
	public void setSmtpUsername(String smtpUsername) {
		this.smtpUsername = smtpUsername;
	}

	/**
	 * 获取SMTP密码
	 */
	@Length(max = 200)
	public String getSmtpPassword() {
		return smtpPassword;
	}

	/**
	 * 设置SMTP密码
	 */
	public void setSmtpPassword(String smtpPassword) {
		this.smtpPassword = smtpPassword;
	}
	
	public String getCacheClearUrl() {
		return cacheClearUrl;
	}

	public void setCacheClearUrl(String cacheClearUrl) {
		this.cacheClearUrl = cacheClearUrl;
	}

	public String getImgSave() {
		return imgSave;
	}

	public void setImgSave(String imgSave) {
		this.imgSave = imgSave;
	}
	
	public String getCacheUrl() {
		return cacheUrl;
	}

	public void setCacheUrl(String cacheUrl) {
		this.cacheUrl = cacheUrl;
	}

	/** 图片上传路径 */
	private String imageUploadPath;
	
	/**
	 * 获取图片上传路径
	 * 
	 * @return 图片上传路径
	 */
	@NotEmpty
	@Length(max = 200)
	public String getImageUploadPath() {
		return imageUploadPath;
	}

	/**
	 * 设置图片上传路径
	 * 
	 * @param imageUploadPath
	 *            图片上传路径
	 */
	public void setImageUploadPath(String imageUploadPath) {
		if (imageUploadPath != null) {
			if (!imageUploadPath.startsWith("/")) {
				imageUploadPath = "/" + imageUploadPath;
			}
			if (!imageUploadPath.endsWith("/")) {
				imageUploadPath += "/";
			}
		}
		this.imageUploadPath = imageUploadPath;
	}
	
	/**
	 * 获取允许上传图片扩展名
	 * 
	 * @return 允许上传图片扩展名
	 */
	public String[] getUploadImageExtensions() {
		return StringUtils.split(uploadImageExtension, SEPARATOR);
	}
	
	/**
	 * 设置允许上传图片扩展名
	 * 
	 * @param uploadImageExtension
	 *            允许上传图片扩展名
	 */
	public void setUploadImageExtension(String uploadImageExtension) {
		if (uploadImageExtension != null) {
			uploadImageExtension = uploadImageExtension.replaceAll("[,\\s]*,[,\\s]*", ",").replaceAll("^,|,$", "").toLowerCase();
		}
		this.uploadImageExtension = uploadImageExtension;
	}
	
	/**
	 * 获取上传文件最大限制
	 * 
	 * @return 上传文件最大限制
	 */
	@NotNull
	@Min(0)
	public Integer getUploadMaxSize() {
		return uploadMaxSize;
	}

	/**
	 * 设置上传文件最大限制
	 * 
	 * @param uploadMaxSize
	 *            上传文件最大限制
	 */
	public void setUploadMaxSize(Integer uploadMaxSize) {
		this.uploadMaxSize = uploadMaxSize;
	}
	
	/**
	 * 获取禁用用户名
	 * 
	 * @return 禁用用户名
	 */
	@Length(max = 200)
	public String getDisabledUsername() {
		return disabledUsername;
	}

	/**
	 * 设置禁用用户名
	 * 
	 * @param disabledUsername
	 *            禁用用户名
	 */
	public void setDisabledUsername(String disabledUsername) {
		if (disabledUsername != null) {
			disabledUsername = disabledUsername.replaceAll("[,\\s]*,[,\\s]*", ",").replaceAll("^,|,$", "");
		}
		this.disabledUsername = disabledUsername;
	}

	/**
	 * 获取用户名最小长度
	 * 
	 * @return 用户名最小长度
	 */
	@NotNull
	@Min(1)
	@Max(117)
	public Integer getUsernameMinLength() {
		return usernameMinLength;
	}

	/**
	 * 设置用户名最小长度
	 * 
	 * @param usernameMinLength
	 *            用户名最小长度
	 */
	public void setUsernameMinLength(Integer usernameMinLength) {
		this.usernameMinLength = usernameMinLength;
	}

	/**
	 * 获取用户名最大长度
	 * 
	 * @return 用户名最大长度
	 */
	@NotNull
	@Min(1)
	@Max(117)
	public Integer getUsernameMaxLength() {
		return usernameMaxLength;
	}

	/**
	 * 设置用户名最大长度
	 * 
	 * @param usernameMaxLength
	 *            用户名最大长度
	 */
	public void setUsernameMaxLength(Integer usernameMaxLength) {
		this.usernameMaxLength = usernameMaxLength;
	}
	
	/**
	 * 获取密码最大长度
	 * 
	 * @return 密码最大长度
	 */
	@NotNull
	@Min(1)
	@Max(117)
	public Integer getPasswordMaxLength() {
		return passwordMaxLength;
	}

	/**
	 * 设置密码最大长度
	 * 
	 * @param passwordMaxLength
	 *            密码最大长度
	 */
	public void setPasswordMaxLength(Integer passwordMaxLength) {
		this.passwordMaxLength = passwordMaxLength;
	}
	
	/**
	 * 获取验证码类型
	 * 
	 * @return 验证码类型
	 */
	public CaptchaType[] getCaptchaTypes() {
		return captchaTypes;
	}

	/**
	 * 设置验证码类型
	 * 
	 * @param captchaTypes
	 *            验证码类型
	 */
	public void setCaptchaTypes(CaptchaType[] captchaTypes) {
		this.captchaTypes = captchaTypes;
	}

	
	/** 是否允许E-mail登录 */
	private Boolean isEmailLogin;
	
	/** 价格精确方式 */
	private RoundType priceRoundType;
	
	/** 网站网址 */
	private String siteUrl;
	
	/** 密码最小长度 */
	private Integer passwordMinLength;
	
	/** 是否开放注册 */
	private Boolean isRegisterEnabled;
	
	/** 货币符号 */
	private String currencySign;
	
	/** 货币单位 */
	private String currencyUnit;
	
	/** Cookie路径 */
	private String cookiePath;

	/** Cookie作用域 */
	private String cookieDomain;
	
	/** 价格精确位数 */
	private Integer priceScale;
	
	/** 支付key */
	private String key;
	
	/** 支付网关地址 */
	private String requestUrl;
	
	/** 支付落地页地址 */
	private String redirecturl;
	
	/** 网关查询类型 */
	private String queryType;
	
	/** 网关查询方式 */
	private String queryMode;
	
	/** 网关查询密钥 */
	private String queryKey;
	
	public String getQueryKey() {
		return queryKey;
	}

	public void setQueryKey(String queryKey) {
		this.queryKey = queryKey;
	}

	public String getQueryType() {
		return queryType;
	}

	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}

	public String getQueryMode() {
		return queryMode;
	}

	public void setQueryMode(String queryMode) {
		this.queryMode = queryMode;
	}

	public String getRedirecturl() {
		return redirecturl;
	}

	public void setRedirecturl(String redirecturl) {
		this.redirecturl = redirecturl;
	}

	public String getRequestUrl() {
		return requestUrl;
	}

	public void setRequestUrl(String requestUrl) {
		this.requestUrl = requestUrl;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	@NotEmpty
	@Length(max = 200)
	public String getSiteName() {
		return siteName;
	}

	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}
	
	/** 编码方式 */
	private String inputCharset;
	
	/** 返回地址 */
	private String bgUrl;
	
	/** 版本 */
	private String version;
	
	/** 语言 */
	private String language;
	
	/** 签名类型 */
	private String signType;
	
	/** 人民币网关账号 */
	private String merchantAcctId;
	
	/** 支付方式 */
	private String payType;
	
	/** 银行代码 */
	private String bankId;
	
	/** 移动网关版本 */
	private String mobileGateway;
	
	/** 人同一订单禁止重复提交标志 */
	private String redoFlag;
	
	/** 快钱合作伙伴的帐户号，即商户编号，可为空 */
	private String pid;

	public String getMobileGateway() {
		return mobileGateway;
	}

	public void setMobileGateway(String mobileGateway) {
		this.mobileGateway = mobileGateway;
	}

	public String getInputCharset() {
		return inputCharset;
	}

	public void setInputCharset(String inputCharset) {
		this.inputCharset = inputCharset;
	}

	public String getBgUrl() {
		return bgUrl;
	}

	public void setBgUrl(String bgUrl) {
		this.bgUrl = bgUrl;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getSignType() {
		return signType;
	}

	public void setSignType(String signType) {
		this.signType = signType;
	}

	public String getMerchantAcctId() {
		return merchantAcctId;
	}

	public void setMerchantAcctId(String merchantAcctId) {
		this.merchantAcctId = merchantAcctId;
	}

	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
	}

	public String getBankId() {
		return bankId;
	}

	public void setBankId(String bankId) {
		this.bankId = bankId;
	}

	public String getRedoFlag() {
		return redoFlag;
	}

	public void setRedoFlag(String redoFlag) {
		this.redoFlag = redoFlag;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	/**
	 * 获取价格精确位数
	 * 
	 * @return 价格精确位数
	 */
	@NotNull
	@Min(0)
	@Max(3)
	public Integer getPriceScale() {
		return priceScale;
	}

	/**
	 * 设置价格精确位数
	 * 
	 * @param priceScale
	 *            价格精确位数
	 */
	public void setPriceScale(Integer priceScale) {
		this.priceScale = priceScale;
	}

	/**
	 * 获取网站网址
	 * 
	 * @return 网站网址
	 */
	@NotEmpty
	@Length(max = 200)
	public String getSiteUrl() {
		return siteUrl;
	}

	/**
	 * 设置网站网址
	 * 
	 * @param siteUrl
	 *            网站网址
	 */
	public void setSiteUrl(String siteUrl) {
		this.siteUrl = StringUtils.removeEnd(siteUrl, "/");
	}

	/**
	 * 获取价格精确方式
	 * 
	 * @return 价格精确方式
	 */
	@NotNull
	public RoundType getPriceRoundType() {
		return priceRoundType;
	}

	/**
	 * 设置价格精确方式
	 * 
	 * @param priceRoundType
	 *            价格精确方式
	 */
	public void setPriceRoundType(RoundType priceRoundType) {
		this.priceRoundType = priceRoundType;
	}

	/**
	 * 获取是否开放注册
	 * 
	 * @return 是否开放注册
	 */
	@NotNull
	public Boolean getIsRegisterEnabled() {
		return isRegisterEnabled;
	}

	/**
	 * 设置是否开放注册
	 * 
	 * @param isRegisterEnabled
	 *            是否开放注册
	 */
	public void setIsRegisterEnabled(Boolean isRegisterEnabled) {
		this.isRegisterEnabled = isRegisterEnabled;
	}

	/**
	 * 获取密码最小长度
	 * 
	 * @return 密码最小长度
	 */
	@NotNull
	@Min(1)
	@Max(117)
	public Integer getPasswordMinLength() {
		return passwordMinLength;
	}

	/**
	 * 设置密码最小长度
	 * 
	 * @param passwordMinLength
	 *            密码最小长度
	 */
	public void setPasswordMinLength(Integer passwordMinLength) {
		this.passwordMinLength = passwordMinLength;
	}

	

	/**
	 * 获取是否允许E-mail登录
	 * 
	 * @return 是否允许E-mail登录
	 */
	@NotNull
	public Boolean getIsEmailLogin() {
		return isEmailLogin;
	}

	/**
	 * 设置是否允许E-mail登录
	 * 
	 * @param isEmailLogin
	 *            是否允许E-mail登录
	 */
	public void setIsEmailLogin(Boolean isEmailLogin) {
		this.isEmailLogin = isEmailLogin;
	}

	
	/**
	 * 获取货币符号
	 * 
	 * @return 货币符号
	 */
	@NotEmpty
	@Length(max = 200)
	public String getCurrencySign() {
		return currencySign;
	}

	/**
	 * 设置货币符号
	 * 
	 * @param currencySign
	 *            货币符号
	 */
	public void setCurrencySign(String currencySign) {
		this.currencySign = currencySign;
	}

	/**
	 * 获取货币单位
	 * 
	 * @return 货币单位
	 */
	@NotEmpty
	@Length(max = 200)
	public String getCurrencyUnit() {
		return currencyUnit;
	}

	/**
	 * 设置货币单位
	 * 
	 * @param currencyUnit
	 *            货币单位
	 */
	public void setCurrencyUnit(String currencyUnit) {
		this.currencyUnit = currencyUnit;
	}

	
	/**
	 * 获取Cookie路径
	 * 
	 * @return Cookie路径
	 */
	@NotEmpty
	@Length(max = 200)
	public String getCookiePath() {
		return cookiePath;
	}

	/**
	 * 设置Cookie路径
	 * 
	 * @param cookiePath
	 *            Cookie路径
	 */
	public void setCookiePath(String cookiePath) {
		if (cookiePath != null && !cookiePath.endsWith("/")) {
			cookiePath += "/";
		}
		this.cookiePath = cookiePath;
	}

	/**
	 * 获取Cookie作用域
	 * 
	 * @return Cookie作用域
	 */
	@Length(max = 200)
	public String getCookieDomain() {
		return cookieDomain;
	}

	/**
	 * 设置Cookie作用域
	 * 
	 * @param cookieDomain
	 *            Cookie作用域
	 */
	public void setCookieDomain(String cookieDomain) {
		this.cookieDomain = cookieDomain;
	}

	/**
	 * 获取禁用用户名
	 * 
	 * @return 禁用用户名
	 */
	public String[] getDisabledUsernames() {
		return StringUtils.split(disabledUsername, SEPARATOR);
	}

	/**
	 * 设置精度
	 * 
	 * @param amount
	 *            数值
	 * @return 数值
	 */
	public BigDecimal setScale(BigDecimal amount) {
		if (amount == null) {
			return null;
		}
		int roundingMode;
		if (getPriceRoundType() == RoundType.roundUp) {
			roundingMode = BigDecimal.ROUND_UP;
		} else if (getPriceRoundType() == RoundType.roundDown) {
			roundingMode = BigDecimal.ROUND_DOWN;
		} else {
			roundingMode = BigDecimal.ROUND_HALF_UP;
		}
		return amount.setScale(getPriceScale(), roundingMode);
	}

}