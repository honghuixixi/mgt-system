package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "SCUSER")
@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_SYS_PK_NO")
public class User implements Serializable {
	
	private BigDecimal orgNo;
	
	/**1001*/
	private BigDecimal comNo;
	
	private BigDecimal locNo;
	
	/**业务员id*/
	private BigDecimal picNo;
	
	/** ID */
	private BigDecimal userNo;
	
	/** 用户名 */
	private String userName;

	/** 密码 */
	private BigDecimal userPassword;

	/** 公司名称 */
	private String name;
	
	/**针对店铺客户默认为Y **/
	private String comFlg;
	
	/**针对店铺/供应商默认为Y**/
	private String publicFlg;
	
	/** 店铺为Y，供应商为N */
	private String salesMenFlg;
	
	/**店铺为N，供应商为Y*/
	private String purchaserFlg;
	
	/** 店铺/供应商 公司网址 */
	private String urlAddr;
	
	/**区域代码**/
	private BigDecimal areaId;
	
	/**城市**/
	private String crmCity;
	
	/**省份**/
	private String crmState;
	
	/**电话**/
	private String crmTel;
	
	/**是否共享，默认N**/
	private String shareFlg;
	
	/**详细地址*/
	private String crmAddress1;
	
	/**地图标注位置*/
	private String crmAddress4;
	
	/**联系人*/
	private String crmPic;
	
	/**联系人电话*/
	private String crmMobile;
	
	/**店铺图标*/
	private String reMark1;
	
	/**营业面积*/
	private String reMark4;
	
	/**备注*/
	private String reMark;
	
	/**别名*/
	private String altName;
	
	/**更新标志*/
	private String upLoadFlg;
	
	/**创建日期*/
	private Date createDate;
	
	/**店铺公告*/
	private String reMark2;
	
	/**配送范围*/
	private String reMark3;
	
	/**店铺免运费最低购物金额*/
	private BigDecimal orderAmt;
	
	/**运费*/
	private BigDecimal freight;
	
	/**是否已开通微店*/
	private String refStatus;
	
	/**开通微店日期*/
	private Date refDate;
	
	/** E-mail */
	private String email;
	
	/**系统默认*/
	private String charSet;
	
	/**QQ绑定ID*/
	private String openID;
	
	/**绑定手机号（登陆时，等同于USER_NAME）*/
	private String bundingMobile;
	
	/**是否通过审核*/
	private String guestFlg;
	
	/**纬度*/
	private BigDecimal latitude;
	
	/**经度*/
	private BigDecimal longitude;
	
	/**邮编*/
	private String crmZip;
	
	/**是否能登录网站*/
	private String showFlg;
	
	private String currCode;
	
	private BigDecimal currRate;

	private String crmCountry;
	
	/**传真*/
	private String crmFax;
	/**是否临时锁定，Y为锁定*/
	private String blockFlg;
	
	/** 物流公司人员*/
	private String logisticsProviderFlg;
	
	/** 企业登录用户名*/
	private String refUserName;
	/** 结算帐期*/
	private String discTerms;
	
	/**店铺类别码*/
	private String accCat2;
	
	/**拣货员标示*/
	private String pickFlg;
	/**是否为运营中心或运营中心用户*/
	private String opcFlg;
	/**是否为运营中心总部*/
	private String hqFlg;
	
	private BigDecimal parentAcc;
	/**图片1地址*/
	private String img1Url;
	/**图片2地址*/
	private String img2Url;
	/**图片3地址*/
	private String img3Url;
	/**图片4地址*/
	private String img4Url;
	/**营业执照图片*/
	private String businessLicenseUrl;
	/**是否O2O店铺 Y是N否 默认值N*/
	private String o2oFlg;
	/**2016-02-26 新增*/
	private String needPwdFlg;
	/**审核通过的为Y*/
	private String agreementStatus;
	/** 对帐帐期*/
	private String invTerms;
	
	@Column(name = "LATITUDE", precision = 22, scale = 0)
	public BigDecimal getLatitude() {
		return this.latitude;
	}

	public void setLatitude(BigDecimal latitude) {
		this.latitude = latitude;
	}

	@Column(name = "LONGITUDE", precision = 22, scale = 0)
	public BigDecimal getLongitude() {
		return this.longitude;
	}

	public void setLongitude(BigDecimal longitude) {
		this.longitude = longitude;
	}
	
	@Column(name="CRM_QQ")
	public String getOpenID() {
		return openID;
	}

	public void setOpenID(String openID) {
		this.openID = openID;
	}
	
	@Column(name="BUNDING_MOBILE")
	public String getBundingMobile() {
		return bundingMobile;
	}
	
	public void setBundingMobile(String bundingMobile) {
		this.bundingMobile = bundingMobile;
	}

	@Column(name="ORG_NO")
	public BigDecimal getOrgNo() {
		return orgNo;
	}

	public void setOrgNo(BigDecimal orgNo) {
		this.orgNo = orgNo;
	}
	
	/**
	 * 公司名
	 * @return
	 */
	@Column(name="NAME")
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	@Column(name="COM_NO")
	public BigDecimal getComNo() {
		return comNo;
	}

	public void setComNo(BigDecimal comNo) {
		this.comNo = comNo;
	}

	@Column(name="LOC_NO")
	public BigDecimal getLocNo() {
		return locNo;
	}

	public void setLocNo(BigDecimal locNo) {
		this.locNo = locNo;
	}

	/**
	 * 默认值
	 * @return
	 */
	@Column(nullable = false, name="CHAR_SET")
	public String getCharSet() {
		return charSet;
	}

	public void setCharSet(String charSet) {
		this.charSet = charSet;
	}

	/**
	 * 获取联系人手机
	 * @return
	 */
	@Column(nullable = false, name="CRM_MOBILE")
	public String getCrmMobile() {
		return crmMobile;
	}

	public void setCrmMobile(String crmMobile) {
		this.crmMobile = crmMobile;
	}

	/**
	 * 获取联系人
	 * @return
	 */
	@Column(nullable = false, name="CRM_PIC")
	public String getCrmPic() {
		return crmPic;
	}

	public void setCrmPic(String crmPic) {
		this.crmPic = crmPic;
	}

	/**
	 * 获取详细地址
	 * @return
	 */
	@Column(nullable = false, name="CRM_ADDRESS1")
	public String getCrmAddress1() {
		return crmAddress1;
	}

	public void setCrmAddress1(String crmAddress1) {
		this.crmAddress1 = crmAddress1;
	}
	
	/**
	 * 获取详细地址
	 * @return
	 */
	@Column(nullable = false, name="CRM_ADDRESS4")
	public String getCrmAddress4() {
		return crmAddress4;
	}

	public void setCrmAddress4(String crmAddress4) {
		this.crmAddress4 = crmAddress4;
	}

	/**
	 * 获取ID
	 * 
	 * @return ID
	 */
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name="USER_NO")
	public BigDecimal getUserNo() {
		return userNo;
	}

	/**
	 * 设置ID
	 * 
	 * @param id
	 *            ID
	 */
	public void setUserNo(BigDecimal userNo) {
		this.userNo = userNo;
	}
	/**
	 * 获取用户名
	 * 
	 * @return 用户名
	 */
	@Column(nullable = false, name="USER_NAME")
	public String getUserName() {
		return userName;
	}

	/**
	 * 设置用户名
	 * 
	 * @param username
	 *            用户名
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * 获取密码
	 * 
	 * @return 密码
	 */
	@Column(nullable = false, name="USER_PASSWORD")
	public BigDecimal getUserPassword() {
		return userPassword;
	}

	/**
	 * 设置密码
	 * 
	 * @param password
	 *            密码
	 */
	public void setUserPassword(BigDecimal userPassword) {
		this.userPassword = userPassword;
	}

	@Column(name="COM_FLG",length=1)
	public String getComFlg() {
		return comFlg;
	}

	public void setComFlg(String comFlg) {
		this.comFlg = comFlg;
	}

	@Column(name="EMAIL_ADDR",length=1)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Column(name="PUBLIC_FLG",length=1)
	public String getPublicFlg() {
		return publicFlg;
	}

	public void setPublicFlg(String publicFlg) {
		this.publicFlg = publicFlg;
	}

	@Column(name="SALESMEN_FLG",length=1)
	public String getSalesMenFlg() {
		return salesMenFlg;
	}

	public void setSalesMenFlg(String salesMenFlg) {
		this.salesMenFlg = salesMenFlg;
	}

	@Column(name="PURCHASER_FLG",length=1)
	public String getPurchaserFlg() {
		return purchaserFlg;
	}

	public void setPurchaserFlg(String purchaserFlg) {
		this.purchaserFlg = purchaserFlg;
	}

	@Column(name="URL_ADDR",length=128)
	public String getUrlAddr() {
		return urlAddr;
	}

	public void setUrlAddr(String urlAddr) {
		this.urlAddr = urlAddr;
	}

	/**
	 * 区域代码
	 */
	@Column(name="AREA_ID",length=16)
	public BigDecimal getAreaId() {
		return areaId;
	}

	public void setAreaId(BigDecimal areaId) {
		this.areaId = areaId;
	}

	/**
	 * 城市
	 */
	@Column(name="CRM_CITY",length=32)
	public String getCrmCity() {
		return crmCity;
	}

	public void setCrmCity(String crmCity) {
		this.crmCity = crmCity;
	}

	/**
	 * 省份
	 */
	@Column(name="CRM_STATE",length=32)
	public String getCrmState() {
		return crmState;
	}

	public void setCrmState(String crmState) {
		this.crmState = crmState;
	}

	@Column(name="CRM_TEL",length=32)
	public String getCrmTel() {
		return crmTel;
	}

	public void setCrmTel(String crmTel) {
		this.crmTel = crmTel;
	}

	
	@Column(name="REMARK1")
	public String getRemark1() {
		return reMark1;
	}
	public void setRemark1(String reMark1) {
		this.reMark1 = reMark1;
	}
	
	@Column(name="REMARK")
	public String getRemark() {
		return reMark;
	}
	public void setRemark(String reMark) {
		this.reMark = reMark;
	}
	
	@Column(name="REMARK4")
	public String getRemark4() {
		return reMark4;
	}
	public void setRemark4(String reMark4) {
		this.reMark4 = reMark4;
	}
	
	@Column(name="ALT_NAME")
	public String getAltName() {
		return altName;
	}
	public void setAltName(String altName) {
		this.altName = altName;
	}
	
	@Column(name="UPLOAD_FLG")
	public String getUploadFlg() {
		return upLoadFlg;
	}
	public void setUploadFlg(String upLoadFlg) {
		this.upLoadFlg = upLoadFlg;
	}
	
	@Column(name="CREATE_DATE")
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	@Column(name="REMARK2")
	public String getRemark2() {
		return reMark2;
	}
	public void setRemark2(String reMark2) {
		this.reMark2 = reMark2;
	}
	
	@Column(name="REMARK3")
	public String getRemark3() {
		return reMark3;
	}
	public void setRemark3(String reMark3) {
		this.reMark3 = reMark3;
	}
	
	@Column(name="ORDER_AMT")
	public BigDecimal getOrderAmt() {
		return orderAmt;
	}
	public void setOrderAmt(BigDecimal orderAmt) {
		this.orderAmt = orderAmt;
	}
	
	@Column(name="FREIGHT")
	public BigDecimal getFreight() {
		return freight;
	}
	public void setFreight(BigDecimal freight) {
		this.freight = freight;
	}
	
	@Column(name="REF_STATUS")
	public String getRefStatus() {
		return refStatus;
	}
	public void setRefStatus(String refStatus) {
		this.refStatus = refStatus;
	}
	
	@Column(name="REF_DATE")
	public Date getRefDate() {
		return refDate;
	}
	public void setRefDate(Date refDate) {
		this.refDate = refDate;
	}
	
	/**
	 *是否共享，默认N
	 */
	@Column(name="SHARE_FLG",length=1)
	public String getShareFlg() {
		return shareFlg;
	}

	public void setShareFlg(String shareFlg) {
		this.shareFlg = shareFlg;
	}
	
	/**
	 *是否通过审核，Y为通过该，N为不通过
	 */
	@Column(name="GUEST_FLG",length=1)
	public String getGuestFlg() {
		return guestFlg;
	}
	
	public void setGuestFlg(String guestFlg) {
		this.guestFlg = guestFlg;
	}		
	
	@Column(name = "PIC_NO", precision = 20, scale = 0)
	public BigDecimal getPicNo() {
		return this.picNo;
	}

	public void setPicNo(BigDecimal picNo) {
		this.picNo = picNo;
	}
	
	@Column(name = "CRM_ZIP")
	public String getCrmZip() {
		return this.crmZip;
	}
	
	public void setCrmZip(String crmZip) {
		this.crmZip = crmZip;
	}

	/**
	 *是否通过审核，Y可登陆，N为不可登陆
	 */
	@Column(name="SHOW_FLG",length=1)
	public String getShowFlg() {
		return showFlg;
	}

	public void setShowFlg(String showFlg) {
		this.showFlg = showFlg;
	}

	@Column(name = "CURR_CODE")
	public String getCurrCode() {
		return currCode;
	}

	public void setCurrCode(String currCode) {
		this.currCode = currCode;
	}

	@Column(name = "CURR_RATE")
	public BigDecimal getCurrRate() {
		return currRate;
	}

	public void setCurrRate(BigDecimal currRate) {
		this.currRate = currRate;
	}

	@Column(name = "CRM_COUNTRY")
	public String getCrmCountry() {
		return crmCountry;
	}

	public void setCrmCountry(String crmCountry) {
		this.crmCountry = crmCountry;
	}
	@Column(name = "CRM_FAX")
	public String getCrmFax() {
		return crmFax;
	}

	public void setCrmFax(String crmFax) {
		this.crmFax = crmFax;
	}

	@Column(name="BLOCK_FLG",length=1)
	public String getBlockFlg() {
		return blockFlg;
	}

	public void setBlockFlg(String blockFlg) {
		this.blockFlg = blockFlg;
	}

	@Column(name="LOGISTICS_PROVIDER_FLG",length=1)
	public String getLogisticsProviderFlg() {
		return logisticsProviderFlg;
	}

	public void setLogisticsProviderFlg(String logisticsProviderFlg) {
		this.logisticsProviderFlg = logisticsProviderFlg;
	}
	@Column(name="REF_USER_NAME",length=16)
	public String getRefUserName() {
		return refUserName;
	}

	public void setRefUserName(String refUserName) {
		this.refUserName = refUserName;
	}
	@Column(name="DISC_TERMS",length=32)
	public String getDiscTerms() {
		return discTerms;
	}

	public void setDiscTerms(String discTerms) {
		this.discTerms = discTerms;
	}
	@Column(name="ACC_CAT2",length=16)
	public String getAccCat2() {
		return accCat2;
	}
	
	public void setAccCat2(String accCat2) {
		this.accCat2 = accCat2;
	}
	
	@Column(name="PICK_FLG",length=1)
	public String getPickFlg() {
		return pickFlg;
	}

	public void setPickFlg(String pickFlg) {
		this.pickFlg = pickFlg;
	}
	
	@Column(name="OPC_FLG",length=1)
	public String getOpcFlg() {
		return opcFlg;
	}

	public void setOpcFlg(String opcFlg) {
		this.opcFlg = opcFlg;
	}
	
	@Column(name="HQ_FLG",length=1)
	public String getHqFlg() {
		return hqFlg;
	}

	public void setHqFlg(String hqFlg) {
		this.hqFlg = hqFlg;
	}
	
	@Column(name = "PARENT_ACC")
	public BigDecimal getParentAcc() {
		return parentAcc;
	}

	public void setParentAcc(BigDecimal parentAcc) {
		this.parentAcc = parentAcc;
	}
	
	@Column(name="IMG1_URL", length=512)
	public String getImg1Url() {
		return img1Url;
	}

	public void setImg1Url(String img1Url) {
		this.img1Url = img1Url;
	}

	@Column(name="IMG2_URL", length=512)
	public String getImg2Url() {
		return img2Url;
	}

	public void setImg2Url(String img2Url) {
		this.img2Url = img2Url;
	}

	@Column(name="IMG3_URL", length=512)
	public String getImg3Url() {
		return img3Url;
	}

	public void setImg3Url(String img3Url) {
		this.img3Url = img3Url;
	}

	@Column(name="IMG4_URL", length=512)
	public String getImg4Url() {
		return img4Url;
	}

	public void setImg4Url(String img4Url) {
		this.img4Url = img4Url;
	}

	@Column(name="BUSINESS_LICENSE_URL", length=512)
	public String getBusinessLicenseUrl() {
		return businessLicenseUrl;
	}

	public void setBusinessLicenseUrl(String businessLicenseUrl) {
		this.businessLicenseUrl = businessLicenseUrl;
	}

	@Column(name = "O2O_FLG", length = 1)
	public String getO2oFlg() {
		return this.o2oFlg;
	}

	public void setO2oFlg(String o2oFlg) {
		this.o2oFlg = o2oFlg;
	}
	
	@Column(name = "AGREEMENT_STATUS", length = 1)
	public String getAgreementStatus() {
		return this.agreementStatus;
	}

	public void setAgreementStatus(String agreementStatus) {
		this.agreementStatus = agreementStatus;
	}
	
	@Column(name = "NEED_PWD_FLG", length = 1)
	public String getNeedPwdFlg() {
		return this.needPwdFlg;
	}

	public void setNeedPwdFlg(String needPwdFlg) {
		this.needPwdFlg = needPwdFlg;
	}

	@Column(name = "INV_TERMS", length = 32)
	public String getInvTerms() {
		return invTerms;
	}

	public void setInvTerms(String invTerms) {
		this.invTerms = invTerms;
	}

}
