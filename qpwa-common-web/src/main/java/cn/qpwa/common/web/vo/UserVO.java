package cn.qpwa.common.web.vo;

import java.math.BigDecimal;
import java.util.Date;



/**
 * 用户信息前台展示对象，用于web前台数据交互
 */
public class UserVO {

	/** "用户名"Cookie名称 */
	public static final String USERNAME_COOKIE_NAME = "username";
	/** "用户登录状态1为已登录"Cookie名称 */
	public static final String STATUS_COOKIE_NAME = "status";
	/** 用户ID */
	private BigDecimal userNo;
	
	/** 组织机构代码 */
	private BigDecimal orgNo;
	
	/** 组织机构代码 */
	private BigDecimal comNo;
	
	/** 组织机构代码 */
	private BigDecimal locNo;

	/** 用户名 */
	private String username;

	/** 公司名称 */
	private String companyName;

	/** 公司地区 */
	private String areaId;

	/** 公司地址 */
	private String companyAddr;

	/** 固定电话 */
	private String crmTel;

	/** 公司网址 */
	private String urlAddr;

	/** 供货类型 */
	private String[] supplyType;

	/** 联系人姓名 */
	private String contactName;

	/** 联系人电话 */
	private String crmMobile;

	/** 店铺/供应商标志 */
	private String salesMenFlg;
	
	/** 是否记录登陆用户名，1为记录；0为不记录 */
	private String rememberUsername;
	
	/* 后台用户表对应字段*/
	/** 主键ID */
	private String id;	
	
	/** 供应商编码 */
	private String merchantCode;
	
	/** 用户登录账号 */
	private String accountName;
	
	/** 用户真实姓名 */
	private String userName;
	
	/** 用户编号 6 位 */
	private String userCode;
	
	/** 邮件 */
	private String email;
	
	/** 手机 */
	private String mobile;
	
	/** 会员标识 */
	private String customId;
	
	/** 图片URL */
	private String picUrl;
	
	/** 状态0：未启用 1：已启用 2:已删除 */
	private String status;	
	
	/** 性别 */
	private String sex;	
	
	/** 创建者 */
	private String createBy;
	
	/** 创建日期 */
	private Date createDate = new Date();
	
	/** 修改人ID */
	private String updateBy;
	
	/** 修改日期 */
	private Date updateDate;
	/**创库*/
	private String whC;
	/**供应商username*/
	private String merchantUserName;

	public String getMerchantUserName() {
		return merchantUserName;
	}

	public void setMerchantUserName(String merchantUserName) {
		this.merchantUserName = merchantUserName;
	}

	public String getWhC() {
		return whC;
	}

	public void setWhC(String whC) {
		this.whC = whC;
	}

	public BigDecimal getOrgNo() {
		return orgNo;
	}

	public void setOrgNo(BigDecimal orgNo) {
		this.orgNo = orgNo;
	}

	public BigDecimal getComNo() {
		return comNo;
	}

	public void setComNo(BigDecimal comNo) {
		this.comNo = comNo;
	}

	public BigDecimal getLocNo() {
		return locNo;
	}

	public void setLocNo(BigDecimal locNo) {
		this.locNo = locNo;
	}

	public BigDecimal getUserNo() {
		return userNo;
	}

	public void setUserNo(BigDecimal userNo) {
		this.userNo = userNo;
	}

	public String getSalesMenFlg() {
		return salesMenFlg;
	}

	public void setSalesMenFlg(String salesMenFlg) {
		this.salesMenFlg = salesMenFlg;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public String getCompanyAddr() {
		return companyAddr;
	}

	public void setCompanyAddr(String companyAddr) {
		this.companyAddr = companyAddr;
	}

	public String getCrmTel() {
		return crmTel;
	}

	public void setCrmTel(String crmTel) {
		this.crmTel = crmTel;
	}

	public String getUrlAddr() {
		return urlAddr;
	}

	public void setUrlAddr(String urlAddr) {
		this.urlAddr = urlAddr;
	}

	public String[] getSupplyType() {
		return supplyType;
	}

	public void setSupplyType(String[] supplyType) {
		this.supplyType = supplyType;
	}

	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getCrmMobile() {
		return crmMobile;
	}

	public void setCrmMobile(String crmMobile) {
		this.crmMobile = crmMobile;
	}

	public String getRememberUsername() {
		return rememberUsername;
	}

	public void setRememberUsername(String rememberUsername) {
		this.rememberUsername = rememberUsername;
	}

	//后台管理表对应字段
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}

	public String getMerchantCode() {
		return merchantCode;
	}

	public void setMerchantCode(String merchantCode) {
		this.merchantCode = merchantCode;
	}

	public String getCustomId() {
		return this.customId;
	}

	public void setCustomId(String customId) {
		this.customId = customId;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserCode() {
		return this.userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getMobile() {
		return this.mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getPicUrl() {
		return this.picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAccountName() {
		return this.accountName;
	}

	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}

	public String getSex() {
		return this.sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getUpdateBy() {
		return updateBy;
	}

	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	/**
	 * 通过数据对象转换视图对象
	 * 
	 * @param entity
	 *            数据对象
	 * @return视图对象
	 */
//	public static UserVO do2vo(User entity) {
//		UserVO vo = null;
//		if (entity != null) {
//			vo = new UserVO();
//
//		}
//		return vo;
//	}
}
