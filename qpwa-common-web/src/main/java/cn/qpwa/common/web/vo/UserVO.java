package cn.qpwa.common.web.vo;

import java.math.BigDecimal;

/**
 * 用户信息前台展示对象，用于web前台数据交互
 */
public class UserVO {

	/** "用户名"Cookie名称 */
	public static final String USERNAME_COOKIE_NAME = "username";
	/** "密码"Cookie名称 */
	public static final String PASS_COOKIE_NAME = "password";
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
	
	/** 店铺名称 */
	private String name;
	
	/** 密码 */
	private String userPassword;

	/** 公司名称 */
	private String companyName;

	/** 公司地区 */
	private BigDecimal areaId;

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
	
	/** 是否记录登陆密码，1为记录；0为不记录 */
	private String rememberPassword;
	
	/** 是否通过审核用户，Y为通过；N为不通过*/
	private String guestFlg;
	
	/**业务员id*/
	private BigDecimal picNo;
	
	public BigDecimal getPicNo() {
		return picNo;
	}

	public void setPicNo(BigDecimal picNo) {
		this.picNo = picNo;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
	
	public String getUserpassword() {
		return userPassword;
	}
	
	public void setUserpassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public BigDecimal getAreaId() {
		return areaId;
	}

	public void setAreaId(BigDecimal areaId) {
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
	
	public String getRememberPassword() {
		return rememberPassword;
	}
	
	public void setRememberPassword(String rememberPassword) {
		this.rememberPassword = rememberPassword;
	}
	
	public String getGuestFlg() {
		return guestFlg;
	}
	
	public void setGuestFlg(String guestFlg) {
		this.guestFlg = guestFlg;
	}

	/**
	 * 通过entity实体组装vo实体
	 * 
	 * @param entity
	 *            数据对象
	 * @return vo视图对象
	 */
	public static UserVO do2vo(User entity) {
		UserVO vo = null;
		if (entity != null) {
			vo = new UserVO();
			vo.setUserNo(entity.getUserNo());
			vo.setUsername(entity.getUserName());
			vo.setOrgNo(entity.getOrgNo());
			vo.setSalesMenFlg(entity.getSalesMenFlg());
			vo.setCompanyName(entity.getName());
			vo.setComNo(entity.getComNo());
			vo.setLocNo(entity.getLocNo());
			vo.setUrlAddr(entity.getUrlAddr());
			vo.setAreaId(entity.getAreaId());
			vo.setCompanyAddr(entity.getCrmAddress1());
			vo.setCrmTel(entity.getCrmTel());
			vo.setUrlAddr(entity.getUrlAddr());
			vo.setContactName(entity.getCrmPic());
			vo.setCrmMobile(entity.getCrmMobile());
			vo.setGuestFlg(entity.getGuestFlg());
			vo.setPicNo(entity.getPicNo());
			vo.setName(entity.getName());

		}
		return vo;
	}
	
	/**
	 * 通过vo实体组装entity实体
	 * @param vo  vo实体         
	 * @return entity实体
	 */
	public static User vo2Entity(UserVO vo) {
		User entity = null;
		if (vo != null) {
			entity = new User();
			if (vo.getUserNo() != null)
				entity.setUserNo(vo.getUserNo());
			entity.setUserName(vo.getUsername());
			entity.setOrgNo(vo.getOrgNo());
			entity.setSalesMenFlg(vo.getSalesMenFlg());
			entity.setComNo(vo.getComNo());
			entity.setName(vo.getCompanyName());
			entity.setLocNo(vo.getLocNo());
			entity.setUrlAddr(vo.getUrlAddr());
			entity.setAreaId(vo.getAreaId());
			entity.setCrmAddress1(vo.getCompanyAddr());
			entity.setCrmTel(vo.getCrmTel());
			entity.setUrlAddr(vo.getUrlAddr());
			entity.setCrmPic(vo.getContactName());
			entity.setCrmMobile(vo.getCrmMobile());
			entity.setGuestFlg(vo.getGuestFlg());
			entity.setPicNo(vo.getPicNo());
		}
		return entity;
	}
}
